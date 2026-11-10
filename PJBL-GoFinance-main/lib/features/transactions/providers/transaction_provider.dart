import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_finance/features/transactions/models/transaction_model.dart';

/// Provider state manajemen transaksi & saldo persisten (tersimpan permanen di HP).
class TransactionProvider extends ChangeNotifier {
  static const String _keySaldoAktif = 'gf_saldo_aktif_v1';
  static const String _keySaldoTabungan = 'gf_saldo_tabungan_v1';
  static const String _keyTransactions = 'gf_transactions_json_v1';

  double _saldoAktif = 2450000.0;
  double _saldoTabungan = 1250000.0;
  List<TransactionModel> _all = [];
  bool _isLoaded = false;

  String _searchQuery = '';
  TransactionCategory _selectedCategory = TransactionCategory.semua;
  int _selectedTabIndex = 0; // 0=Harian, 1=Mingguan, 2=Bulanan

  TransactionProvider() {
    _loadFromStorage();
  }

  double get saldoAktif => _saldoAktif;
  double get saldoTabungan => _saldoTabungan;
  bool get isLoaded => _isLoaded;
  List<TransactionModel> get allTransactions => List.unmodifiable(_all);

  String get searchQuery => _searchQuery;
  TransactionCategory get selectedCategory => _selectedCategory;
  int get selectedTabIndex => _selectedTabIndex;

  /// Memuat saldo & riwayat transaksi dari memori permanen HP (SharedPreferences)
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _saldoAktif = prefs.getDouble(_keySaldoAktif) ?? 2450000.0;
      _saldoTabungan = prefs.getDouble(_keySaldoTabungan) ?? 1250000.0;

      final jsonStr = prefs.getString(_keyTransactions);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final list = jsonDecode(jsonStr) as List<dynamic>;
        _all = list
            .map((item) =>
                TransactionModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _all = List.from(DummyTransactions.all);
      }
    } catch (e) {
      debugPrint('[TransactionProvider] Gagal memuat dari storage: $e');
      _all = List.from(DummyTransactions.all);
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Menyimpan saldo & riwayat transaksi ke memori permanen HP
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_keySaldoAktif, _saldoAktif);
      await prefs.setDouble(_keySaldoTabungan, _saldoTabungan);
      final jsonList = _all.map((t) => t.toJson()).toList();
      await prefs.setString(_keyTransactions, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('[TransactionProvider] Gagal menyimpan ke storage: $e');
    }
  }

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

  /// Menambah transaksi baru (mempengaruhi saldo aktif secara permanen)
  void addTransaction(TransactionModel tx) {
    _all = [tx, ..._all];
    if (tx.type == TransactionType.pemasukan) {
      _saldoAktif += tx.amount;
    } else {
      _saldoAktif -= tx.amount;
    }
    _saveToStorage();
    notifyListeners();
  }

  /// Menabung: Mengurangi saldo aktif & menambah saldo tabungan secara nyata & permanen
  bool setorTabungan(double nominal, {String? catatan}) {
    if (nominal <= 0) return false;
    if (_saldoAktif < nominal) return false;

    _saldoAktif -= nominal;
    _saldoTabungan += nominal;

    final tx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Setor Tabungan',
      subtitle: catatan != null && catatan.isNotEmpty
          ? catatan
          : 'Tabungan Masa Depan',
      amount: nominal,
      type: TransactionType.pengeluaran,
      category: TransactionCategory.lainnya,
      date: DateTime.now(),
      note: 'Setor ke Saldo Tabungan',
    );
    _all = [tx, ..._all];

    _saveToStorage();
    notifyListeners();
    return true;
  }

  /// Tarik Tabungan: Mengembalikan uang dari tabungan ke saldo aktif secara nyata & permanen
  bool tarikTabungan(double nominal, {String? catatan}) {
    if (nominal <= 0) return false;
    if (_saldoTabungan < nominal) return false;

    _saldoTabungan -= nominal;
    _saldoAktif += nominal;

    final tx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Tarik Tabungan',
      subtitle: catatan != null && catatan.isNotEmpty
          ? catatan
          : 'Pencairan Tabungan',
      amount: nominal,
      type: TransactionType.pemasukan,
      category: TransactionCategory.transfer,
      date: DateTime.now(),
      note: 'Tarik dari Tabungan ke Saldo Aktif',
    );
    _all = [tx, ..._all];

    _saveToStorage();
    notifyListeners();
    return true;
  }

  /// Top Up Saldo Aktif langsung
  void topUpSaldo(double nominal, {String? sumber}) {
    if (nominal <= 0) return;
    _saldoAktif += nominal;

    final tx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Top Up Saldo',
      subtitle: sumber ?? 'Pemasukan Tunai/Transfer',
      amount: nominal,
      type: TransactionType.pemasukan,
      category: TransactionCategory.transfer,
      date: DateTime.now(),
      note: 'Penambahan saldo aktif',
    );
    _all = [tx, ..._all];

    _saveToStorage();
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
