const Busboy = require('busboy');
const {
  S3Client,
  PutObjectCommand,
  DeleteObjectCommand,
} = require('@aws-sdk/client-s3');
const {
  TextractClient,
  StartExpenseAnalysisCommand,
  GetExpenseAnalysisCommand,
} = require('@aws-sdk/client-textract');

const s3 = new S3Client({});
const textract = new TextractClient({});
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'Content-Type',
};

function parseMultipart(event) {
  return new Promise((resolve, reject) => {
    const contentType =
      event.headers?.['content-type'] ||
      event.headers?.['Content-Type'];
    if (!contentType) {
      reject(new Error('Content-Type multipart/form-data diperlukan.'));
      return;
    }

    const buffer = Buffer.from(
      event.body || '',
      event.isBase64Encoded ? 'base64' : 'utf8',
    );
    const busboy = Busboy({ headers: { 'content-type': contentType } });
    let file;

    busboy.on('file', (_name, stream, info) => {
      const chunks = [];
      stream.on('data', (chunk) => chunks.push(chunk));
      stream.on('end', () => {
        file = {
          buffer: Buffer.concat(chunks),
          name: info.filename || 'receipt',
        };
      });
    });
    busboy.on('finish', () => resolve(file));
    busboy.on('error', reject);
    busboy.end(buffer);
  });
}

function normalizeAmount(value) {
  if (!value) return 0;
  const match = String(value).replace(/[^\d.,]/g, '');
  if (!match) return 0;
  const normalized = match
    .replace(/\./g, '')
    .replace(/,/g, '.');
  return Number.parseFloat(normalized) || 0;
}

function normalizeDate(value) {
  if (!value) return new Date().toISOString().slice(0, 10);
  const compact = String(value).replace(/[^\d]/g, '');
  if (/^\d{8}$/.test(compact)) {
    const year = compact.slice(0, 4);
    const month = compact.slice(4, 6);
    const day = compact.slice(6, 8);
    return `${year}-${month}-${day}`;
  }
  const parsed = new Date(value);
  return Number.isNaN(parsed.getTime())
    ? new Date().toISOString().slice(0, 10)
    : parsed.toISOString().slice(0, 10);
}

function getCategory(merchant) {
  const text = merchant.toLowerCase();
  if (/indomaret|alfamart|super|market|toko|minimarket/.test(text)) {
    return 'belanja';
  }
  if (/resto|cafe|warung|makan|kopi|bakso|pizza|kfc|burger/.test(text)) {
    return 'makananMinuman';
  }
  if (/grab|gojek|bensin|pertamina|spbu|parkir|tol|kereta/.test(text)) {
    return 'transportasi';
  }
  if (/listrik|pln|internet|wifi|air|pdam|telepon|tagihan/.test(text)) {
    return 'tagihan';
  }
  return 'lainnya';
}

function fieldMap(expenseDocuments) {
  const result = {
    merchant: 'Merchant',
    amount: 0,
    date: new Date().toISOString().slice(0, 10),
  };

  for (const document of expenseDocuments || []) {
    for (const summary of document.SummaryFields || []) {
      const type = summary.Type?.Text || summary.Type?.Confidence;
      const label = type || summary.LabelDetection?.Text || '';
      const value = summary.ValueDetection?.Text;
      if (!value) continue;

      const key = String(label).toUpperCase();
      if (/VENDOR.?NAME|MERCHANT|PAYEE/.test(key)) {
        result.merchant = value;
      } else if (/TOTAL|AMOUNT_PAID/.test(key)) {
        result.amount = normalizeAmount(value);
      } else if (/DATE|INVOICE_RECEIPT_DATE/.test(key)) {
        result.date = normalizeDate(value);
      }
    }
  }

  result.category = getCategory(result.merchant);
  return result;
}

async function analyzeDocument(bucket, key) {
  const started = await textract.send(new StartExpenseAnalysisCommand({
    DocumentLocation: { S3Object: { Bucket: bucket, Name: key } },
  }));
  const jobId = started.JobId;
  if (!jobId) throw new Error('Textract tidak menghasilkan JobId.');

  const expenseDocuments = [];
  let nextToken;
  let status;

  do {
    const response = await textract.send(new GetExpenseAnalysisCommand({
      JobId: jobId,
      NextToken: nextToken,
    }));
    status = response.JobStatus;
    if (status === 'FAILED') {
      throw new Error(response.StatusMessage || 'Analisis AWS gagal.');
    }
    if (status === 'SUCCEEDED') {
      expenseDocuments.push(...(response.ExpenseDocuments || []));
      nextToken = response.NextToken;
    } else {
      await new Promise((resolve) => setTimeout(resolve, 1500));
    }
  } while (status !== 'SUCCEEDED' || nextToken);

  return fieldMap(expenseDocuments);
}

exports.handler = async (event) => {
  let key;
  try {
    const file = await parseMultipart(event);
    if (!file?.buffer?.length) {
      return {
        statusCode: 400,
        headers: corsHeaders,
        body: JSON.stringify({ message: 'File struk tidak ditemukan.' }),
      };
    }
    if (file.buffer.length > 10 * 1024 * 1024) {
      return {
        statusCode: 413,
        headers: corsHeaders,
        body: JSON.stringify({ message: 'Ukuran file maksimal 10 MB.' }),
      };
    }

    const bucket = process.env.RECEIPT_BUCKET;
    key = `uploads/${Date.now()}-${file.name.replace(/[^a-zA-Z0-9._-]/g, '_')}`;
    await s3.send(new PutObjectCommand({
      Bucket: bucket,
      Key: key,
      Body: file.buffer,
      ContentType: 'application/octet-stream',
      ServerSideEncryption: 'AES256',
    }));

    const result = await analyzeDocument(bucket, key);
    if (result.amount <= 0) {
      return {
        statusCode: 422,
        headers: corsHeaders,
        body: JSON.stringify({
          message: 'Total pembayaran tidak berhasil dibaca. Periksa kembali foto struk.',
        }),
      };
    }

    return {
      statusCode: 200,
      headers: corsHeaders,
      body: JSON.stringify({ result }),
    };
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      headers: corsHeaders,
      body: JSON.stringify({
        message: error.message || 'Gagal menganalisis struk.',
      }),
    };
  } finally {
    if (key && process.env.RECEIPT_BUCKET) {
      await s3.send(new DeleteObjectCommand({
        Bucket: process.env.RECEIPT_BUCKET,
        Key: key,
      })).catch(() => {});
    }
  }
};
