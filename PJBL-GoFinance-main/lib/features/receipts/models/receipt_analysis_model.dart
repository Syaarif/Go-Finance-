import 'package:go_finance/features/transactions/models/transaction_model.dart';

class ReceiptAnalysisModel {
  final String merchant;
  final double amount;
  final DateTime date;
  final TransactionCategory category;

  const ReceiptAnalysisModel({
    required this.merchant,
    required this.amount,
    required this.date,
    required this.category,
  });

  factory ReceiptAnalysisModel.fromJson(Map<String, dynamic> json) {
    final rawCategory = json['category'] as String?;
    final category = TransactionCategory.values.firstWhere(
      (item) => item.name == rawCategory,
      orElse: () => TransactionCategory.belanja,
    );

    return ReceiptAnalysisModel(
      merchant: json['merchant'] as String? ?? 'Merchant',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      date: DateTime.tryParse(json['date'] as String? ?? '') ??
          DateTime.now(),
      category: category,
    );
  }
}
