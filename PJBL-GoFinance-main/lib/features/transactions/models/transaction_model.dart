import 'package:flutter/material.dart';

/// Enum tipe transaksi: pemasukan atau pengeluaran.
enum TransactionType { pemasukan, pengeluaran }

/// Enum kategori transaksi yang tersedia.
enum TransactionCategory {
  semua,
  makananMinuman,
  belanja,
  tagihan,
  transportasi,
  transfer,
  gaji,
  lainnya,
}

extension TransactionCategoryX on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.semua:
        return 'Semua';
      case TransactionCategory.makananMinuman:
        return 'Makanan & Minuman';
      case TransactionCategory.belanja:
        return 'Belanja';
      case TransactionCategory.tagihan:
        return 'Tagihan';
      case TransactionCategory.transportasi:
        return 'Transportasi';
      case TransactionCategory.transfer:
        return 'Transfer';
      case TransactionCategory.gaji:
        return 'Pemasukan';
      case TransactionCategory.lainnya:
        return 'Lainnya';
    }
  }

  String get shortLabel {
    switch (this) {
      case TransactionCategory.semua:
        return 'Semua';
      case TransactionCategory.makananMinuman:
        return 'Makanan';
      case TransactionCategory.belanja:
        return 'Belanja';
      case TransactionCategory.tagihan:
        return 'Tagihan';
      case TransactionCategory.transportasi:
        return 'Transport';
      case TransactionCategory.transfer:
        return 'Transfer';
      case TransactionCategory.gaji:
        return 'Pemasukan';
      case TransactionCategory.lainnya:
        return 'Lainnya';
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionCategory.semua:
        return Icons.apps_rounded;
      case TransactionCategory.makananMinuman:
        return Icons.restaurant_rounded;
      case TransactionCategory.belanja:
        return Icons.shopping_bag_rounded;
      case TransactionCategory.tagihan:
        return Icons.receipt_long_rounded;
      case TransactionCategory.transportasi:
        return Icons.directions_car_rounded;
      case TransactionCategory.transfer:
        return Icons.swap_horiz_rounded;
      case TransactionCategory.gaji:
        return Icons.account_balance_wallet_rounded;
      case TransactionCategory.lainnya:
        return Icons.more_horiz_rounded;
    }
  }

  Color get iconColor {
    switch (this) {
      case TransactionCategory.semua:
        return const Color(0xFF347928);
      case TransactionCategory.makananMinuman:
        return const Color(0xFFE87A3A);
      case TransactionCategory.belanja:
        return const Color(0xFF347928);
      case TransactionCategory.tagihan:
        return const Color(0xFF6694B5);
      case TransactionCategory.transportasi:
        return const Color(0xFF42683A);
      case TransactionCategory.transfer:
        return const Color(0xFFE7BD50);
      case TransactionCategory.gaji:
        return const Color(0xFF347928);
      case TransactionCategory.lainnya:
        return const Color(0xFF82917D);
    }
  }

  Color get iconBg {
    switch (this) {
      case TransactionCategory.semua:
        return const Color(0xFFEDF5E8);
      case TransactionCategory.makananMinuman:
        return const Color(0xFFFFF0E6);
      case TransactionCategory.belanja:
        return const Color(0xFFEDF5E8);
      case TransactionCategory.tagihan:
        return const Color(0xFFE8F0F6);
      case TransactionCategory.transportasi:
        return const Color(0xFFE8F2E6);
      case TransactionCategory.transfer:
        return const Color(0xFFFFF8E6);
      case TransactionCategory.gaji:
        return const Color(0xFFEDF5E8);
      case TransactionCategory.lainnya:
        return const Color(0xFFF0F0F0);
    }
  }
}

/// Model data satu transaksi keuangan.
class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final String? note;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
  });

  bool get isIncome => type == TransactionType.pemasukan;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'amount': amount,
        'type': type.name,
        'category': category.name,
        'date': date.toIso8601String(),
        'note': note,
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? UniqueKey().toString(),
      title: json['title'] as String? ?? 'Transaksi',
      subtitle: json['subtitle'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: (json['type'] == 'pemasukan')
          ? TransactionType.pemasukan
          : TransactionType.pengeluaran,
      category: TransactionCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => TransactionCategory.lainnya,
      ),
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      note: json['note'] as String?,
    );
  }
}

/// Kosong — semua data transaksi diambil langsung dari database AWS RDS.
class DummyTransactions {
  static final List<TransactionModel> all = [];
}