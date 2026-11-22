import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_finance/core/services/aws_api_service.dart';
import 'package:go_finance/core/services/aws_auth_service.dart';
import 'package:go_finance/features/transactions/models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  static const String _keySaldoAktif = 'gf_saldo_aktif_v1';
  static const String _keySaldoTabungan = 'gf_saldo_tabungan_v1';
  static const String _keyTransactions = 'gf_transactions_json_v1';

  double _saldoAktif = 0.0;
  double _saldoTabungan = 0.0;
  int? _defaultWalletId;
  List<TransactionModel> _all = [];
  bool _isLoaded = false;

  String _searchQuery = '';
  TransactionCategory _selectedCategory = TransactionCategory.semua;
  int _selectedTabIndex = 0;

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

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _saldoAktif = prefs.getDouble(_keySaldoAktif) ?? 0.0;
      _saldoTabungan = prefs.getDouble(_keySaldoTabungan) ?? 0.0;

      final jsonStr = prefs.getString(_keyTransactions);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final list = jsonDecode(jsonStr) as List<dynamic>;
        _all = list
            .map((item) =>
                TransactionModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      final token = await AwsAuthService.instance.getToken();
      if (token != null && token.isNotEmpty) {
        await syncFromAws();
      }
    } catch (e) {
      debugPrint('[TransactionProvider] Gagal memuat data: $e');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Sinkronisasi saldo dompet & riwayat transaksi user dari AWS RDS MySQL
  Future<void> syncFromAws() async {
    try {
      final wallets = await AwsApiService.instance.getWallets();
      if (wallets.isNotEmpty) {
        final primaryWallet = wallets.first as Map<String, dynamic>;
        _defaultWalletId = (primaryWallet['id'] as num?)?.toInt();
        _saldoAktif =
            double.tryParse(primaryWallet['balance'].toString()) ?? _saldoAktif;

        if (wallets.length > 1) {
          final savingsWallet = wallets[1] as Map<String, dynamic>;
          _saldoTabungan =
              double.tryParse(savingsWallet['balance'].toString()) ??
                  _saldoTabungan;
        }
      }

      final rawTx = await AwsApiService.instance.getTransactions();
      _all = rawTx.map((item) {
        final map = item as Map<String, dynamic>;
        final typeStr = (map['type'] ?? 'expense').toString();
        final isIncome = typeStr == 'income' || typeStr == 'pemasukan';
        final catName = (map['category_name'] ?? '').toString();
        final rawNote = (map['note'] ?? '').toString();

        String title = catName.isNotEmpty ? catName : 'Transaksi';
        String subtitle = rawNote;
        if (rawNote.contains(' - ')) {
          final parts = rawNote.split(' - ');
          title = parts.first;
          subtitle = parts.sublist(1).join(' - ');
        } else if (rawNote.isNotEmpty) {
          title = rawNote;
          subtitle = catName;
        }

        return TransactionModel(
          id: map['id'].toString(),
          title: title,
          subtitle: subtitle,
          amount: double.tryParse(map['amount'].toString()) ?? 0.0,
          type: isIncome
              ? TransactionType.pemasukan
              : TransactionType.pengeluaran,
          category: _mapBackendCategory(catName),
          date: DateTime.tryParse(map['transaction_date'].toString()) ??
              DateTime.now(),
          note: rawNote,
        );
      }).toList();

      await _saveToStorage();
      notifyListeners();
    } catch (e) {
      debugPrint('[TransactionProvider] Gagal sync dari AWS: $e');
    }
  }

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

  int _categoryToBackendId(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.makananMinuman:
        return 1;
      case TransactionCategory.transportasi:
        return 2;
      case TransactionCategory.belanja:
        return 3;
      case TransactionCategory.tagihan:
        return 4;
      case TransactionCategory.gaji:
        return 5;
      case TransactionCategory.transfer:
        return 6;
      case TransactionCategory.semua:
      case TransactionCategory.lainnya:
        return 7;
    }
  }

  TransactionCategory _mapBackendCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('makan') || lower.contains('minum')) {
      return TransactionCategory.makananMinuman;
    }
    if (lower.contains('transport')) return TransactionCategory.transportasi;
    if (lower.contains('belanja')) return TransactionCategory.belanja;
    if (lower.contains('tagihan')) return TransactionCategory.tagihan;
    if (lower.contains('gaji') || lower.contains('pemasukan')) {
      return TransactionCategory.gaji;
    }
    if (lower.contains('transfer')) return TransactionCategory.transfer;
    return TransactionCategory.lainnya;
  }

  Future<void> _pushTransactionToAws(TransactionModel tx) async {
    try {
      if (_defaultWalletId == null) {
        final wallets = await AwsApiService.instance.getWallets();
        if (wallets.isNotEmpty) {
          _defaultWalletId = (wallets.first['id'] as num).toInt();
        }
      }
      if (_defaultWalletId == null) return;

      final combinedNote = tx.subtitle.isNotEmpty
          ? '${tx.title} - ${tx.subtitle}'
          : tx.title;

      await AwsApiService.instance.createTransaction(
        walletId: _defaultWalletId!,
        categoryId: _categoryToBackendId(tx.category),
        type: tx.type == TransactionType.pemasukan ? 'income' : 'expense',
        amount: tx.amount,
        note: combinedNote,
        transactionDate: tx.date.toIso8601String().split('T').first,
      );
      await syncFromAws();
    } catch (e) {
      debugPrint('[TransactionProvider] Gagal kirim transaksi ke AWS: $e');
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

  void addTransaction(TransactionModel tx) {
    _all = [tx, ..._all];
    if (tx.type == TransactionType.pemasukan) {
      _saldoAktif += tx.amount;
    } else {
      _saldoAktif -= tx.amount;
    }
    _saveToStorage();
    notifyListeners();
    _pushTransactionToAws(tx);
  }

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
    _pushTransactionToAws(tx);
    return true;
  }

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
    _pushTransactionToAws(tx);
    return true;
  }

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
    _pushTransactionToAws(tx);
  }

  List<TransactionModel> get filtered {
    final now = DateTime.now();
    return _all.where((tx) {
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
            (tx.date.year == now.year && tx.date.month == now.month) ||
                (tx.date.year == 2026 && tx.date.month == 10);
      }

      bool inCategory = _selectedCategory == TransactionCategory.semua ||
          tx.category == _selectedCategory;

      bool inSearch = _searchQuery.isEmpty ||
          tx.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());

      return inPeriod && inCategory && inSearch;
    }).toList();
  }

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