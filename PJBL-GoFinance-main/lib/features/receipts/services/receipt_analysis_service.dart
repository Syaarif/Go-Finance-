import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:go_finance/features/receipts/models/receipt_analysis_model.dart';
import 'package:go_finance/features/transactions/models/transaction_model.dart';

class ReceiptAnalysisService {
  Future<ReceiptAnalysisModel> analyze({
    required String filePath,
  }) async {
    final recognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    try {
      final recognizedText = await recognizer.processImage(
        InputImage.fromFilePath(filePath),
      );
      return parseRecognizedText(recognizedText.text);
    } on ReceiptAnalysisException {
      rethrow;
    } on PlatformException {
      throw const ReceiptAnalysisException(
        'Tidak dapat membaca gambar. Coba pilih foto JPG atau PNG yang lebih jelas.',
      );
    } on FileSystemException {
      throw const ReceiptAnalysisException('File struk tidak dapat dibaca.');
    } finally {
      await recognizer.close();
    }
  }

  static ReceiptAnalysisModel parseRecognizedText(String text) {
    final lines = text
        .split(RegExp(r'[\r\n]+'))
        .map((line) => line.trim().replaceAll(RegExp(r'\s+'), ' '))
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      throw const ReceiptAnalysisException(
        'Teks tidak ditemukan. Pastikan foto struk cukup terang dan fokus.',
      );
    }

    final merchant = _extractMerchant(lines);
    final amount = _extractAmount(lines);
    final date = _extractDate(lines);
    final missingFields = <String>[
      if (merchant == null) 'nama toko',
      if (amount == null) 'total pembayaran',
      if (date == null) 'tanggal',
    ];

    if (merchant == null || amount == null || date == null) {
      throw ReceiptAnalysisException(
        'Belum berhasil membaca ${missingFields.join(', ')}. '
        'Coba foto ulang atau pilih gambar yang lebih jelas.',
      );
    }

    return ReceiptAnalysisModel(
      merchant: merchant,
      amount: amount,
      date: date,
      category: _inferCategory(merchant),
    );
  }

  static String? _extractMerchant(List<String> lines) {
    final ignoredLine = RegExp(
      r'^(?:TANGGAL|DATE|WAKTU|TIME|KASIR|CASHIER|NO\.?|TELP|TELEPON|PHONE|ALAMAT|ADDRESS|STRUK|RECEIPT|NOTA)\b',
      caseSensitive: false,
    );
    final numericLine = RegExp(r'^[\d\s.,:/#-]+$');

    for (final line in lines.take(8)) {
      if (line.length < 3 ||
          ignoredLine.hasMatch(line) ||
          numericLine.hasMatch(line) ||
          !RegExp(r'[A-Za-z]').hasMatch(line) ||
          _datePattern.hasMatch(line)) {
        continue;
      }
      return line;
    }
    return null;
  }

  static double? _extractAmount(List<String> lines) {
    final totalLabel = RegExp(
      r'\b(?:GRAND\s*TOTAL|TOTAL(?:\s+(?:BAYAR|PEMBAYARAN|BELANJA|DUE|PAYABLE))?|AMOUNT\s+DUE|JUMLAH(?:\s+(?:BAYAR|TOTAL))?|TAGIHAN|PAYABLE)\b',
      caseSensitive: false,
    );
    final numberPattern = RegExp(r'\d[\d.,]*');
    final candidates = <({int score, int position, double amount})>[];

    for (var index = 0; index < lines.length; index++) {
      if (!totalLabel.hasMatch(lines[index])) continue;
      final label = lines[index].toLowerCase();
      final score = RegExp(
        r'grand|bayar|pembayaran|belanja|amount|jumlah|tagihan|payable',
      ).hasMatch(label)
          ? 2
          : 1;

      for (var offset = 0;
          offset <= 2 && index + offset < lines.length;
          offset++) {
        final candidateLine = lines[index + offset];
        if (offset > 0 && totalLabel.hasMatch(candidateLine)) break;
        final matches = numberPattern.allMatches(candidateLine).toList();
        if (matches.isEmpty) continue;

        final amount = _parseAmount(matches.last.group(0)!);
        if (amount != null) {
          candidates.add((
            score: score - offset,
            position: index + offset,
            amount: amount,
          ));
          break;
        }
      }
    }

    if (candidates.isEmpty) return null;
    candidates.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      return byScore != 0 ? byScore : b.position.compareTo(a.position);
    });
    return candidates.first.amount;
  }

  static double? _parseAmount(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^\d.,-]'), '');
    if (cleaned.isEmpty || cleaned.startsWith('-')) return null;

    final lastDot = cleaned.lastIndexOf('.');
    final lastComma = cleaned.lastIndexOf(',');
    final lastSeparator = lastDot > lastComma ? lastDot : lastComma;
    late final String normalized;

    if (lastSeparator == -1) {
      normalized = cleaned;
    } else {
      final decimalDigits = cleaned.length - lastSeparator - 1;
      final hasBothSeparators = lastDot != -1 && lastComma != -1;
      final hasDecimalPart =
          hasBothSeparators || (decimalDigits > 0 && decimalDigits < 3);
      if (hasDecimalPart) {
        normalized =
            '${cleaned.substring(0, lastSeparator).replaceAll(RegExp(r'[.,]'), '')}.'
            '${cleaned.substring(lastSeparator + 1)}';
      } else {
        normalized = cleaned.replaceAll(RegExp(r'[.,]'), '');
      }
    }

    final amount = double.tryParse(normalized);
    return amount != null && amount > 0 ? amount : null;
  }

  static final _datePattern = RegExp(
    r'\b(?:\d{1,2}[./-]\d{1,2}[./-]\d{2,4}|\d{4}[./-]\d{1,2}[./-]\d{1,2}|\d{1,2}\s+[A-Za-z]+\s+\d{4})\b',
    caseSensitive: false,
  );
  static final _dayMonthYearPattern = RegExp(
    r'\b(\d{1,2})[./-](\d{1,2})[./-](\d{2,4})\b',
  );
  static final _yearMonthDayPattern = RegExp(
    r'\b(\d{4})[./-](\d{1,2})[./-](\d{1,2})\b',
  );
  static final _namedDatePattern = RegExp(
    r'\b(\d{1,2})\s+([A-Za-z]+)\s+(\d{4})\b',
    caseSensitive: false,
  );

  static DateTime? _extractDate(List<String> lines) {
    for (final line in lines) {
      final yearMonthDay = _yearMonthDayPattern.firstMatch(line);
      if (yearMonthDay != null) {
        final date = _validDate(
          int.parse(yearMonthDay.group(1)!),
          int.parse(yearMonthDay.group(2)!),
          int.parse(yearMonthDay.group(3)!),
        );
        if (date != null) return date;
      }

      final dayMonthYear = _dayMonthYearPattern.firstMatch(line);
      if (dayMonthYear != null) {
        var year = int.parse(dayMonthYear.group(3)!);
        if (year < 100) year += 2000;
        final date = _validDate(
          year,
          int.parse(dayMonthYear.group(2)!),
          int.parse(dayMonthYear.group(1)!),
        );
        if (date != null) return date;
      }

      final namedDate = _namedDatePattern.firstMatch(line);
      if (namedDate != null) {
        final month = _monthNumber(namedDate.group(2)!);
        if (month != null) {
          final date = _validDate(
            int.parse(namedDate.group(3)!),
            month,
            int.parse(namedDate.group(1)!),
          );
          if (date != null) return date;
        }
      }
    }
    return null;
  }

  static DateTime? _validDate(int year, int month, int day) {
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  static int? _monthNumber(String month) {
    const months = {
      'jan': 1,
      'januari': 1,
      'january': 1,
      'feb': 2,
      'februari': 2,
      'february': 2,
      'mar': 3,
      'maret': 3,
      'march': 3,
      'apr': 4,
      'april': 4,
      'may': 5,
      'mei': 5,
      'jun': 6,
      'juni': 6,
      'june': 6,
      'jul': 7,
      'juli': 7,
      'july': 7,
      'agu': 8,
      'agustus': 8,
      'aug': 8,
      'august': 8,
      'sep': 9,
      'september': 9,
      'okt': 10,
      'oktober': 10,
      'oct': 10,
      'october': 10,
      'nov': 11,
      'november': 11,
      'des': 12,
      'desember': 12,
      'dec': 12,
      'december': 12,
    };
    return months[month.toLowerCase()];
  }

  static TransactionCategory _inferCategory(String merchant) {
    final text = merchant.toLowerCase();
    if (RegExp(r'indomaret|alfamart|supermarket|minimarket|toko')
        .hasMatch(text)) {
      return TransactionCategory.belanja;
    }
    if (RegExp(r'resto|cafe|warung|makan|kopi|bakso|pizza|kfc|burger')
        .hasMatch(text)) {
      return TransactionCategory.makananMinuman;
    }
    if (RegExp(r'grab|gojek|bensin|pertamina|spbu|parkir|tol|kereta')
        .hasMatch(text)) {
      return TransactionCategory.transportasi;
    }
    if (RegExp(r'listrik|pln|internet|wifi|pdam|telepon|tagihan')
        .hasMatch(text)) {
      return TransactionCategory.tagihan;
    }
    return TransactionCategory.lainnya;
  }
}

class ReceiptAnalysisException implements Exception {
  final String message;

  const ReceiptAnalysisException(this.message);

  @override
  String toString() => message;
}
