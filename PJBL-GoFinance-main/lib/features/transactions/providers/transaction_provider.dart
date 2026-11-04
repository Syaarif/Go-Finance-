import 'package:flutter/material.dart';
import 'package:go_finance/features/transactions/models/transaction_model.dart';

/// Provider state manajemen transaksi (daftar, filter, pencarian, tambah).
class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _all = List.from(DummyTransactions.all);
  String _searchQuery = '';
  TransactionCategory _selectedCategory = TransactionCategory.semua;
  int _selectedTabIndex = 0; // 0=Harian, 1=Mingguan, 2=Bulanan

  String get searchQuery => _searchQuery;
  TransactionCategory get selectedCategory => _selectedCategory;
  int get selectedTabIndex => _selectedTabIndex;

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setCategory(TransactionCategory cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void setTab(int idx) {
    _selectedTabIndex = idx;
    notifyListeners();
  }

  void addTransaction(TransactionModel tx) {
    _all = [tx, ..._all];
    notifyListeners();
  }

  List<TransactionModel> get filtered {
    final now = DateTime.now();
    return _all.where((tx) {
      // Filter tab waktu
      bool inPeriod = true;
      if (_selectedTabIndex == 0) {
        inPeriod = tx.date.year == now.year &&
            tx.date.month == now.month &&
            tx.date.day == now.day;
        // Fallback: tampilkan data tanggal 31 Okt jika tidak ada hari ini
        if (!_all.any((t) =>
            t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day)) {
          inPeriod = true;
        }
      } else if (_selectedTabIndex == 1) {
        final weekAgo = now.subtract(const Duration(days: 7));
        inPeriod = tx.date.isAfter(weekAgo);
      } else {
        inPeriod =
            tx.date.year == now.year && tx.date.month == now.month ||
            tx.date.year == 2026 && tx.date.month == 10;
      }

      // Filter kategori
      bool inCategory = _selectedCategory == TransactionCategory.semua ||
          tx.category == _selectedCategory;

      // Filter pencarian
      bool inSearch = _searchQuery.isEmpty ||
          tx.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());

      return inPeriod && inCategory && inSearch;
    }).toList();
  }

  /// Kelompokkan transaksi per tanggal.
  Map<DateTime, List<TransactionModel>> get groupedByDate {
    final result = <DateTime, List<TransactionModel>>{};
    for (final tx in filtered) {
      final key = DateTime(tx.date.year, tx.date.month, tx.date.day);
      result.putIfAbsent(key, () => []).add(tx);
    }
    return Map.fromEntries(
      result.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
  }

  double get totalPemasukan => _all
      .where((t) => t.type == TransactionType.pemasukan)
      .fold(0.0, (s, t) => s + t.amount);

  double get totalPengeluaran => _all
      .where((t) => t.type == TransactionType.pengeluaran)
      .fold(0.0, (s, t) => s + t.amount);
}
