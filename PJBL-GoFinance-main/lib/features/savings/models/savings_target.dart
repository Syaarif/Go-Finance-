class SavingsTarget {
  final String id;
  final String name;
  final double amount;
  final DateTime targetDate;
  final int intervalDays;
  final double savedAmount;

  const SavingsTarget({
    required this.id,
    required this.name,
    required this.amount,
    required this.targetDate,
    required this.intervalDays,
    this.savedAmount = 0,
  });

  double get progress => amount <= 0 ? 0 : (savedAmount / amount).clamp(0, 1);
}