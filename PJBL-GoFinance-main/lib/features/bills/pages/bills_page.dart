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
import 'package:go_finance/l10n/generated/app_localizations.dart';

/// Halaman utama "Kalender Tagihan" Go Finance.
class BillsPage extends StatelessWidget {
  const BillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BillProvider>(
      builder: (context, provider, _) {
        final l10n = AppLocalizations.of(context)!;
        final bills = provider.filteredBills;
        final selectedDate = provider.selectedDate;

        return Scaffold(
          backgroundColor: context.colors.canvas,
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
                          l10n.billCalendarTitle,
                          style: AppTextStyles.pageTitle.copyWith(
                            color: context.colors.textPrimary,
                          ),
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
                            backgroundColor: context.colors.primary,
                            iconColor: Colors.white,
                            size: 40,
                            iconSize: 22,
                            borderRadius: AppSpacing.radiusSm,
                            tooltip: l10n.addBillTooltip,
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
                          l10n.upcomingBills,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: context.colors.textPrimary,
                          ),
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
                            l10n.seeAll,
                            style: AppTextStyles.sectionAction.copyWith(
                              color: context.colors.primaryText,
                            ),
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
                    l10n.completedBillsFootnote,
                    style: AppTextStyles.footnote.copyWith(
                      color: context.colors.mutedText,
                    ),
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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final dateText = selectedDate != null
        ? DateFormat('d MMM yyyy', locale).format(selectedDate!)
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: context.colors.border,
          width: AppSpacing.borderThin,
        ),
      ),
      child: Column(
        children: [
          RoundedSquareIcon(
            svgAsset: 'assets/svg/Bill.svg',
            backgroundColor: context.colors.billHighlight,
            iconColor: context.colors.primaryText,
            size: AppSpacing.billIconCircleSize,
            iconSize: AppSpacing.billIconSize,
            borderRadius: AppSpacing.radiusSm,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            dateText != null
                ? l10n.noBillsForDate(dateText)
                : l10n.noUpcomingBills,
            style: AppTextStyles.billName.copyWith(
              color: context.colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            dateText != null ? l10n.filteredBillsHint : l10n.addBillHint,
            style: AppTextStyles.footnote.copyWith(
              color: context.colors.mutedText,
            ),
            textAlign: TextAlign.center,
          ),
          if (dateText != null) ...[
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: onResetFilter,
              child: Text(
                l10n.seeAll,
                style: AppTextStyles.sectionAction.copyWith(
                  color: context.colors.primaryText,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
