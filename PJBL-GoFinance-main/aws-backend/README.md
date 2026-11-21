# Go Finance Receipt API

Backend AWS untuk analisis struk menggunakan Amazon Textract AnalyzeExpense.

## Deploy

```powershell
cd aws-backend
npm install
npx serverless deploy --stage dev --region ap-southeast-1
```

Set `RECEIPT_API_URL` saat menjalankan aplikasi Flutter ke endpoint:

```powershell
flutter run --dart-define=RECEIPT_API_URL=https://API-ID.execute-api.ap-southeast-1.amazonaws.com/dev/analyze
```

Endpoint menerima `multipart/form-data` dengan field `receipt`.
