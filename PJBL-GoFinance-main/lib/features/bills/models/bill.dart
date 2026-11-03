/// Status tagihan yang belum selesai.
enum BillStatus { pending, overdue }

/// Model data tagihan pada fitur Kalender Tagihan.
class Bill {
  final String id;
  final String name;
  final int amount;
  final DateTime dueDate;
  final bool isDone;

  const Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    this.isDone = false,
  });

  /// Tanggal jatuh tempo tanpa komponen jam (00:00:00).
  DateTime get dateOnly => DateTime(dueDate.year, dueDate.month, dueDate.day);

  /// Selisih hari dari [referenceDate] ke tanggal jatuh tempo.
  int daysRemainingFrom(DateTime referenceDate) {
    final today = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );
    return dateOnly.difference(today).inDays;
  }

  /// Status otomatis: OVERDUE jika lewat jatuh tempo, selain itu PENDING.
  BillStatus statusAt(DateTime referenceDate) {
    return daysRemainingFrom(referenceDate) < 0
        ? BillStatus.overdue
        : BillStatus.pending;
  }

  /// Label sisa hari untuk ditampilkan di kartu tagihan.
  String remainingLabelFrom(DateTime referenceDate) {
    final diff = daysRemainingFrom(referenceDate);
    if (diff < 0) {
      return 'Terlambat ${diff.abs()} hari';
    }
    if (diff == 0) {
      return 'Hari ini';
    }
    if (diff == 1) {
      return 'Besok';
    }
    return '$diff hari lagi';
  }

  Bill copyWith({
    String? id,
    String? name,
    int? amount,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return Bill(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}

