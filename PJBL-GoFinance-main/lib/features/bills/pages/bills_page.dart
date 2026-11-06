import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/bottom_nav_bar.dart';
import 'package:go_finance/core/widgets/profile_action.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/features/bills/providers/bill_provider.dart';
import 'package:go_finance/features/bills/widgets/add_bill_sheet.dart';
import 'package:go_finance/features/bills/widgets/bill_calendar.dart';
import 'package:go_finance/features/bills/widgets/bill_card.dart';

/// Halaman utama "Kalender Tagihan" Go Finance.
class BillsPage extends StatelessWidget {
  const BillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BillProvider>(
      builder: (context, provider, _) {
        final bills = provider.filteredBills;
        final selectedDate = provider.selectedDate;

        return Scaffold(
          backgroundColor: AppColors.canvas,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.lg,
                AppSpacing.pageHorizontal,
                AppSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header halaman: "Kalender Tagihan" + tombol "+" & Profil
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Kalender Tagihan',
                          style: AppTextStyles.pageTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RoundedSquareIcon(
                            actionKey: const Key('btn_open_add_bill'),
                            icon: Icons.add_rounded,
                            backgroundColor: AppColors.primary,
                            iconColor: AppColors.surface,
                            size: 40,
                            iconSize: 22,
                            borderRadius: AppSpacing.radiusSm,
                            tooltip: 'Tambah Tagihan',
                            onTap: () => AddBillSheet.show(context),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const ProfileAction(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 1. Kalender Tagihan (kustom)
                  BillCalendar(
                    focusedMonth: provider.focusedMonth,
                    today: provider.today,
                    selectedDate: selectedDate,
                    hasBillOnDate: provider.hasUnpaidBillOn,
                    onDateSelected: provider.toggleDateSelection,
                    onPreviousMonth: provider.previousMonth,
                    onNextMonth: provider.nextMonth,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // 2. Header daftar "Tagihan Mendatang" + "Lihat semua"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Tagihan Mendatang',
                          style: AppTextStyles.sectionTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      InkWell(
                        key: const Key('btn_reset_date_filter'),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusXs),
                        onTap: provider.clearSelectedDate,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: AppSpacing.xxs,
                          ),
                          child: Text(
                            'Lihat semua',
                            style: AppTextStyles.sectionAction,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 3. Daftar kartu tagihan atau Empty State
                  if (bills.isEmpty)
                    _EmptyBillsCard(
                      selectedDate: selectedDate,
                      onResetFilter: provider.clearSelectedDate,
                    )
                  else
                    Column(
                      children: [
                        for (int i = 0; i < bills.length; i++) ...[
                          if (i > 0) const SizedBox(height: AppSpacing.md),
                          BillCard(
                            key: ValueKey(bills[i].id),
                            bill: bills[i],
                            referenceDate: provider.today,
                            onMarkDone: () => provider.markAsDone(bills[i].id),
                          ),
                        ],
                      ],
                    ),

                  const SizedBox(height: AppSpacing.xl),

                  // 4. Catatan kaki sesuai instruksi
                  Text(
                    'Tagihan yang ditandai selesai akan\ndihapus dari daftar.',
                    style: AppTextStyles.footnote,
                  ),
                ],
              ),
            ),
          ),
          // ===== BOTTOM NAV START: pakai di halaman lain =====
          bottomNavigationBar: const AppBottomNav(currentIndex: NavTab.bills),
        );
      },
    );
  }
}

class _EmptyBillsCard extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onResetFilter;

  const _EmptyBillsCard({
    required this.selectedDate,
    required this.onResetFilter,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDate != null ? _formatShort(selectedDate!) : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.border,
          width: AppSpacing.borderThin,
        ),
      ),
      child: Column(
        children: [
          const RoundedSquareIcon(
            svgAsset: 'assets/svg/Bill.svg',
            backgroundColor: AppColors.billHighlight,
            iconColor: AppColors.deepGreen,
            size: AppSpacing.billIconCircleSize,
            iconSize: AppSpacing.billIconSize,
            borderRadius: AppSpacing.radiusSm,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            dateText != null
                ? 'Tidak ada tagihan pada $dateText'
                : 'Belum ada tagihan mendatang',
            style: AppTextStyles.billName,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            dateText != null
                ? 'Ketuk tanggal yang sama atau tombol di bawah untuk melihat semua tagihan.'
                : 'Tambahkan tagihan baru melalui tombol + di kanan atas.',
            style: AppTextStyles.footnote,
            textAlign: TextAlign.center,
          ),
          if (dateText != null) ...[
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: onResetFilter,
              child: Text('Lihat semua', style: AppTextStyles.sectionAction),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatShort(DateTime date) {
    try {
      return DateFormat('d MMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('d MMM yyyy').format(date);
    }
  }
}

