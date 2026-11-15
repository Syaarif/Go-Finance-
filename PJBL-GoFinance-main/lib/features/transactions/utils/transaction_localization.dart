import 'package:go_finance/features/transactions/models/transaction_model.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

String localizedCategoryLabel(
  AppLocalizations l10n,
  TransactionCategory category, {
  bool short = false,
}) {
  return switch (category) {
    TransactionCategory.semua => l10n.allCategories,
    TransactionCategory.makananMinuman =>
      short ? l10n.food : l10n.foodAndDrinks,
    TransactionCategory.belanja => l10n.shopping,
    TransactionCategory.tagihan => l10n.bills,
    TransactionCategory.transportasi =>
      short ? l10n.transport : l10n.transportation,
    TransactionCategory.transfer => l10n.transfer,
    TransactionCategory.gaji => l10n.income,
    TransactionCategory.lainnya => l10n.other,
  };
}

String localizedTransactionType(
  AppLocalizations l10n,
  TransactionType type,
) {
  return switch (type) {
    TransactionType.pemasukan => l10n.income,
    TransactionType.pengeluaran => l10n.expense,
  };
}
