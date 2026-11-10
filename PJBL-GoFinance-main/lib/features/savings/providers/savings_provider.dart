import 'package:flutter/foundation.dart';
import 'package:go_finance/features/savings/models/savings_target.dart';

class SavingsProvider extends ChangeNotifier {
  final List<SavingsTarget> _targets = [];

  List<SavingsTarget> get targets => List.unmodifiable(_targets);

  double get totalSaved =>
      _targets.fold(0, (total, target) => total + target.savedAmount);

  double get totalTarget =>
      _targets.fold(0, (total, target) => total + target.amount);

  void addTarget(SavingsTarget target) {
    _targets.insert(0, target);
    notifyListeners();
  }
}