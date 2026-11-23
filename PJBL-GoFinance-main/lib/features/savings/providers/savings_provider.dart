import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_finance/features/savings/models/savings_target.dart';

class SavingsProvider extends ChangeNotifier {
  static const String _keyTargets = 'gf_savings_targets_v1';

  final List<SavingsTarget> _targets = [];

  SavingsProvider() {
    _loadFromStorage();
  }

  List<SavingsTarget> get targets => List.unmodifiable(_targets);

  double get totalSaved =>
      _targets.fold(0, (total, target) => total + target.savedAmount);

  double get totalTarget =>
      _targets.fold(0, (total, target) => total + target.amount);

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyTargets);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final list = jsonDecode(jsonStr) as List<dynamic>;
        _targets.clear();
        for (final item in list) {
          final map = item as Map<String, dynamic>;
          _targets.add(
            SavingsTarget(
              id: map['id'].toString(),
              name: map['name'].toString(),
              amount: (map['amount'] as num).toDouble(),
              savedAmount: (map['savedAmount'] as num? ?? 0).toDouble(),
              targetDate: DateTime.parse(map['targetDate'].toString()),
              intervalDays: (map['intervalDays'] as num? ?? 1).toInt(),
            ),
          );
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[SavingsProvider] Gagal memuat target tabungan: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _targets
          .map((t) => {
                'id': t.id,
                'name': t.name,
                'amount': t.amount,
                'savedAmount': t.savedAmount,
                'targetDate': t.targetDate.toIso8601String(),
                'intervalDays': t.intervalDays,
              })
          .toList();
      await prefs.setString(_keyTargets, jsonEncode(list));
    } catch (e) {
      debugPrint('[SavingsProvider] Gagal menyimpan target tabungan: $e');
    }
  }

  Future<void> clearLocalSession() async {
    _targets.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTargets);
    notifyListeners();
  }

  void addTarget(SavingsTarget target) {
    _targets.insert(0, target);
    notifyListeners();
    _saveToStorage();
  }
}