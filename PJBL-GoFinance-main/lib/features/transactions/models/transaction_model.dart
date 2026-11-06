import 'package:flutter/material.dart';

/// Enum tipe transaksi: pemasukan atau pengeluaran.
enum TransactionType { pemasukan, pengeluaran }

/// Enum kategori transaksi yang tersedia.
enum TransactionCategory {
  semua,
  makananMinuman,
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
}

/// Data dummy transaksi untuk preview.
class DummyTransactions {
  static final List<TransactionModel> all = [
    TransactionModel(
      id: '1',
      title: 'Indomaret',
      subtitle: 'Makanan & Minuman',
      amount: 24500,
      type: TransactionType.pengeluaran,
      category: TransactionCategory.makananMinuman,
      date: DateTime(2026, 10, 31, 12, 30),
    ),
    TransactionModel(
      id: '2',
      title: 'Gaji Bulanan',
      subtitle: 'Pemasukan',
      amount: 3500000,
      type: TransactionType.pemasukan,
      category: TransactionCategory.gaji,
      date: DateTime(2026, 10, 31, 8, 15),
    ),
    TransactionModel(
      id: '3',
      title: 'Transportasi Online',
      subtitle: 'Transportasi',
      amount: 18000,
      type: TransactionType.pengeluaran,
      category: TransactionCategory.transportasi,
      date: DateTime(2026, 10, 31, 7, 46),
    ),
    TransactionModel(
      id: '4',
      title: 'Alfamart',
      subtitle: 'Makanan & Minuman',
      amount: 25000,
      type: TransactionType.pengeluaran,
      category: TransactionCategory.makananMinuman,
      date: DateTime(2026, 10, 30, 14, 20),
    ),
    TransactionModel(
      id: '5',
      title: 'Top Up E-Wallet',
      subtitle: 'Transfer',
      amount: 200000,
      type: TransactionType.pemasukan,
      category: TransactionCategory.transfer,
      date: DateTime(2026, 10, 30, 10, 05),
    ),
    TransactionModel(
      id: '6',
      title: 'Tagihan Internet',
      subtitle: 'Tagihan',
      amount: 300000,
      type: TransactionType.pengeluaran,
      category: TransactionCategory.tagihan,
      date: DateTime(2026, 10, 29, 9, 00),
    ),
    TransactionModel(
      id: '7',
      title: 'Makan Siang',
      subtitle: 'Makanan & Minuman',
      amount: 35000,
      type: TransactionType.pengeluaran,
      category: TransactionCategory.makananMinuman,
      date: DateTime(2026, 10, 29, 13, 00),
    ),
    TransactionModel(
      id: '8',
      title: 'Bensin Motor',
      subtitle: 'Transportasi',
      amount: 50000,
      type: TransactionType.pengeluaran,
      category: TransactionCategory.transportasi,
      date: DateTime(2026, 10, 28, 7, 30),
    ),
    TransactionModel(
      id: '9',
      title: 'Transfer ke Teman',
      subtitle: 'Transfer',
      amount: 150000,
      type: TransactionType.pengeluaran,
      category: TransactionCategory.transfer,
      date: DateTime(2026, 10, 28, 11, 45),
    ),
    TransactionModel(
      id: '10',
      title: 'Tagihan Listrik',
      subtitle: 'Tagihan',
      amount: 450000,
      type: TransactionType.pengeluaran,
      category: TransactionCategory.tagihan,
      date: DateTime(2026, 10, 27, 10, 00),
    ),
  ];
}
