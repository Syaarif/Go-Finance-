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
}
