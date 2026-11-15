import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/features/bills/models/bill.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final status = bill.statusAt(referenceDate);
    final isOverdue = status == BillStatus.overdue;
    final statusLabel = isOverdue ? l10n.overdue : l10n.pending;
    final statusColor =
        isOverdue ? context.colors.negative : context.colors.warning;

    final formattedAmount = NumberFormat.decimalPattern(locale).format(
      bill.amount,
    );
    final formattedDue = DateFormat('d MMM', locale).format(bill.dueDate);
    final billName = _localizedBillName(l10n);
    final daysRemaining = bill.daysRemainingFrom(referenceDate);
    final remainingText = daysRemaining < 0
        ? l10n.overdueDays(daysRemaining.abs())
        : daysRemaining == 0
            ? l10n.today
            : daysRemaining == 1
                ? l10n.tomorrow
                : l10n.daysRemaining(daysRemaining);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: context.colors.border,
          width: AppSpacing.borderThin,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.cardShadow,
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, AppSpacing.xxs),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon dokumen di rounded square hijau muda
          RoundedSquareIcon(
            svgAsset: 'assets/svg/Bill.svg',
            backgroundColor: context.colors.billHighlight,
            iconColor: context.colors.primaryText,
            size: AppSpacing.billIconCircleSize,
            iconSize: AppSpacing.billIconSize,
            borderRadius: AppSpacing.radiusSm,
          ),
          const SizedBox(width: AppSpacing.md),

          // Informasi tengah: nama, nominal, jatuh tempo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  billName,
                  style: AppTextStyles.billName.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Rp $formattedAmount',
                  style: AppTextStyles.billAmount.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.dueDatePrefix(formattedDue),
                  style: AppTextStyles.billMeta.copyWith(
                    color: context.colors.mutedText,
                  ),
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
                style: AppTextStyles.badgeStatus(statusColor).copyWith(
                  color: statusColor,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                remainingText,
                style: AppTextStyles.billRemainingDays.copyWith(
                  color: context.colors.mutedText,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Material(
                color: context.colors.softSurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  onTap: () => _confirmMarkAsDone(
                    context,
                    billName,
                    formattedAmount,
                  ),
                  child: Container(
                    height: AppSpacing.actionButtonHeight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                        color: context.colors.border,
                        width: AppSpacing.borderThin,
                      ),
                    ),
                    child: Text(
                      l10n.payNow,
                      style: AppTextStyles.cardActionButton.copyWith(
                        color: context.colors.primaryText,
                      ),
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
    String billName,
    String formattedAmount,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        title: Text(
          l10n.markBillDoneTitle,
          style: AppTextStyles.sheetTitle.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        content: Text(
          l10n.markBillDoneConfirmation(billName, formattedAmount),
          style: AppTextStyles.inputText.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.cancel,
              style: AppTextStyles.billMeta.copyWith(
                color: context.colors.mutedText,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.markDone,
              style: AppTextStyles.primaryButton.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onMarkDone();
    }
  }

  String _localizedBillName(AppLocalizations l10n) {
    switch (bill.id) {
      case 'bill_internet_rumah':
        return l10n.homeInternetBill;
      case 'bill_listrik':
        return l10n.electricityBill;
      case 'bill_streaming':
        return l10n.streamingBill;
      default:
        return bill.name;
    }
  }
}
