import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/features/bills/models/bill.dart';

/// Kartu item pada daftar "Tagihan Mendatang".
/// Tombol menggunakan teks sesuai desain ("Bayar sekarang") yang berfungsi
/// sebagai penanda "Tandai selesai" (tanpa logika transaksi/pembayaran).
class BillCard extends StatelessWidget {
  final Bill bill;
  final DateTime referenceDate;
  final VoidCallback onMarkDone;

  const BillCard({
    super.key,
    required this.bill,
    required this.referenceDate,
    required this.onMarkDone,
  });

  @override
  Widget build(BuildContext context) {
    final status = bill.statusAt(referenceDate);
    final isOverdue = status == BillStatus.overdue;
    final statusLabel = isOverdue ? 'OVERDUE' : 'PENDING';
    final statusColor = isOverdue ? AppColors.negative : AppColors.warning;

    final formattedAmount = _formatCurrency(bill.amount);
    final formattedDue = _formatDueDate(bill.dueDate);
    final remainingText = bill.remainingLabelFrom(referenceDate);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.border,
          width: AppSpacing.borderThin,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: AppSpacing.sm,
            offset: Offset(0, AppSpacing.xxs),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon dokumen di lingkaran hijau muda
          Container(
            width: AppSpacing.billIconCircleSize,
            height: AppSpacing.billIconCircleSize,
            decoration: const BoxDecoration(
              color: AppColors.billHighlight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/svg/Bill.svg',
              width: AppSpacing.billIconSize,
              height: AppSpacing.billIconSize,
              colorFilter: const ColorFilter.mode(
                AppColors.deepGreen,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Informasi tengah: nama, nominal, jatuh tempo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.name,
                  style: AppTextStyles.billName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Rp $formattedAmount',
                  style: AppTextStyles.billAmount,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Jatuh tempo $formattedDue',
                  style: AppTextStyles.billMeta,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Informasi kanan: badge status, sisa hari, tombol aksi
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                statusLabel,
                style: AppTextStyles.badgeStatus(statusColor),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                remainingText,
                style: AppTextStyles.billRemainingDays,
              ),
              const SizedBox(height: AppSpacing.sm),
              Material(
                color: AppColors.softSurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  onTap: () => _confirmMarkAsDone(context, formattedAmount),
                  child: Container(
                    height: AppSpacing.actionButtonHeight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                        color: AppColors.border,
                        width: AppSpacing.borderThin,
                      ),
                    ),
                    child: Text(
                      'Bayar sekarang',
                      style: AppTextStyles.cardActionButton,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmMarkAsDone(
    BuildContext context,
    String formattedAmount,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        title: Text('Tandai Selesai?', style: AppTextStyles.sheetTitle),
        content: Text(
          'Tandai tagihan "${bill.name}" (Rp $formattedAmount) sebagai selesai? '
          'Tagihan akan dihapus dari daftar dan pengingat dibatalkan.',
          style: AppTextStyles.inputText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Batal', style: AppTextStyles.billMeta),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Tandai Selesai', style: AppTextStyles.primaryButton),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onMarkDone();
    }
  }

  static String _formatCurrency(int value) {
    try {
      return NumberFormat.decimalPattern('id_ID').format(value);
    } catch (_) {
      return value.toString();
    }
  }

  static String _formatDueDate(DateTime date) {
    try {
      return DateFormat('d MMM', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('d MMM').format(date);
    }
  }
}

