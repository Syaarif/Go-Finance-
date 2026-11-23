import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_finance/features/bills/models/bill.dart';
import 'package:go_finance/features/bills/services/notification_service.dart';

/// State provider untuk fitur Kalender Tagihan.
class BillProvider extends ChangeNotifier {
  static const String _keyBills = 'gf_bills_json_v1';

  final NotificationService _notificationService;
  final DateTime _today;
  late DateTime _focusedMonth;
  DateTime? _selectedDate;
  final List<Bill> _bills = [];

  BillProvider({
    NotificationService? notificationService,
    DateTime? initialToday,
    List<Bill>? initialBills,
  })  : _notificationService =
            notificationService ?? NotificationService.instance,
        _today = _dateOnly(initialToday ?? DateTime.now()) {
    _focusedMonth = DateTime(_today.year, _today.month, 1);

    if (initialBills != null) {
      _bills.addAll(initialBills);
      _sortBills();
      for (final bill in _bills) {
        if (!bill.isDone) {
          _notificationService.scheduleBillReminders(bill);
        }
      }
    } else {
      _loadFromStorage();
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyBills);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final list = jsonDecode(jsonStr) as List<dynamic>;
        _bills.clear();
        for (final item in list) {
          final map = item as Map<String, dynamic>;
          _bills.add(
            Bill(
              id: map['id'].toString(),
              name: map['name'].toString(),
              amount: (map['amount'] as num).toInt(),
              dueDate: DateTime.parse(map['dueDate'].toString()),
              isDone: map['isDone'] == true,
            ),
          );
        }
        _sortBills();
        for (final bill in _bills) {
          if (!bill.isDone) {
            _notificationService.scheduleBillReminders(bill);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[BillProvider] Gagal memuat tagihan: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _bills
          .map((b) => {
                'id': b.id,
                'name': b.name,
                'amount': b.amount,
                'dueDate': b.dueDate.toIso8601String(),
                'isDone': b.isDone,
              })
          .toList();
      await prefs.setString(_keyBills, jsonEncode(list));
    } catch (e) {
      debugPrint('[BillProvider] Gagal menyimpan tagihan: $e');
    }
  }

  /// Bersihkan cache tagihan lokal saat logout
  Future<void> clearLocalSession() async {
    for (final bill in _bills) {
      await _notificationService.cancelBillReminders(bill.id);
    }
    _bills.clear();
    _selectedDate = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBills);
    notifyListeners();
  }

  DateTime get today => _today;
  DateTime get focusedMonth => _focusedMonth;
  DateTime? get selectedDate => _selectedDate;

  /// Tanggal yang ditampilkan pada sub-header kalender ("<Bulan> <Tahun> · <tgl>").
  DateTime get headerDate => _selectedDate ?? _today;

  /// Semua tagihan yang belum selesai, urut jatuh tempo terdekat.
  List<Bill> get activeBills {
    final list = _bills.where((b) => !b.isDone).toList()
      ..sort((a, b) => a.dateOnly.compareTo(b.dateOnly));
    return List.unmodifiable(list);
  }

  /// Daftar "Tagihan Mendatang" (terfilter ke [_selectedDate] bila ada).
  List<Bill> get filteredBills {
    final active = activeBills;
    if (_selectedDate == null) return active;
    return active
        .where((b) => isSameDay(b.dateOnly, _selectedDate!))
        .toList(growable: false);
  }

  /// Apakah tanggal [date] memiliki minimal satu tagihan yang belum selesai.
  bool hasUnpaidBillOn(DateTime date) {
    final target = _dateOnly(date);
    return _bills.any((b) => !b.isDone && isSameDay(b.dateOnly, target));
  }

  /// Ganti ke bulan sebelumnya (panah ‹).
  void previousMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    notifyListeners();
  }

  /// Ganti ke bulan berikutnya (panah ›).
  void nextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    notifyListeners();
  }

  /// Tap tanggal di kalender: pilih tanggal, atau tap ulang untuk reset filter.
  void toggleDateSelection(DateTime date) {
    final normalized = _dateOnly(date);
    if (_selectedDate != null && isSameDay(_selectedDate!, normalized)) {
      _selectedDate = null;
    } else {
      _selectedDate = normalized;
    }
    notifyListeners();
  }

  /// Reset filter tanggal ("Lihat semua").
  void clearSelectedDate() {
    if (_selectedDate == null) return;
    _selectedDate = null;
    notifyListeners();
  }

  /// Tambah tagihan baru, urutkan berdasarkan jatuh tempo terdekat,
  /// dan jadwalkan notifikasi H-7 & H-1.
  Future<Bill> addBill({
    required String name,
    required int amount,
    required DateTime dueDate,
  }) async {
    final normalizedDue = _dateOnly(dueDate);
    final newBill = Bill(
      id: 'bill_${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      amount: amount,
      dueDate: normalizedDue,
    );

    _bills.add(newBill);
    _sortBills();
    _focusedMonth = DateTime(normalizedDue.year, normalizedDue.month, 1);
    notifyListeners();

    await _saveToStorage();
    await _notificationService.scheduleBillReminders(newBill);
    return newBill;
  }

  /// Tandai tagihan selesai (`isDone = true`) dan batalkan notifikasinya.
  Future<void> markAsDone(String billId) async {
    final index = _bills.indexWhere((b) => b.id == billId);
    if (index == -1) return;

    _bills[index] = _bills[index].copyWith(isDone: true);
    notifyListeners();

    await _saveToStorage();
    await _notificationService.cancelBillReminders(billId);
  }

  /// Hapus tagihan dan batalkan notifikasinya.
  Future<void> deleteBill(String billId) async {
    _bills.removeWhere((b) => b.id == billId);
    notifyListeners();

    await _saveToStorage();
    await _notificationService.cancelBillReminders(billId);
  }

  void _sortBills() {
    _bills.sort((a, b) => a.dateOnly.compareTo(b.dateOnly));
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}