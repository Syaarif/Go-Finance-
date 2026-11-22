import 'package:flutter_test/flutter_test.dart';
import 'package:go_finance/features/receipts/services/receipt_analysis_service.dart';
import 'package:go_finance/features/transactions/models/transaction_model.dart';

void main() {
  group('ReceiptAnalysisService.parseRecognizedText', () {
    test('extracts merchant, total, date, and category from receipt text', () {
      final result = ReceiptAnalysisService.parseRecognizedText('''
INDOMARET
JL. MERDEKA NO. 10
TANGGAL: 20/11/2026 14:30
SUBTOTAL Rp 30.000
GRAND TOTAL Rp 32.500
''');

      expect(result.merchant, 'INDOMARET');
      expect(result.amount, 32500);
      expect(result.date, DateTime(2026, 11, 20));
      expect(result.category, TransactionCategory.belanja);
    });

    test('reads amount on the line after TOTAL and Indonesian month names', () {
      final result = ReceiptAnalysisService.parseRecognizedText('''
Warung Makan Sederhana
15 November 2026
TOTAL
Rp 1.250,00
''');

      expect(result.merchant, 'Warung Makan Sederhana');
      expect(result.amount, 1250);
      expect(result.date, DateTime(2026, 11, 15));
      expect(result.category, TransactionCategory.makananMinuman);
    });

    test('reports missing fields instead of returning placeholder values', () {
      expect(
        () => ReceiptAnalysisService.parseRecognizedText('''
TOKO MAKMUR
TANGGAL 20/11/2026
'''),
        throwsA(
          isA<ReceiptAnalysisException>().having(
            (error) => error.message,
            'message',
            contains('total pembayaran'),
          ),
        ),
      );
    });
  });
}
