import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/bottom_nav_bar.dart';
import 'package:go_finance/features/savings/models/savings_target.dart';
import 'package:go_finance/features/savings/pages/create_savings_target_page.dart';
import 'package:go_finance/features/savings/providers/savings_provider.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  Future<void> _createTarget(BuildContext context) async {
    final target = await Navigator.of(context).push<SavingsTarget>(
      MaterialPageRoute(builder: (_) => const CreateSavingsTargetPage()),
    );
    if (target != null && context.mounted) {
      context.read<SavingsProvider>().addTarget(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final targets = context.watch<SavingsProvider>().targets;
    final isEmpty = targets.isEmpty;

    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.lg,
                AppSpacing.pageHorizontal,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.targetSavings,
                      style: AppTextStyles.pageTitle.copyWith(
                        color: context.colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    key: const Key('btn_add_savings_target'),
                    tooltip: l10n.createSavingsTargetTooltip,
                    onPressed: () => _createTarget(context),
                    icon: Icon(Icons.add_rounded,
                        color: context.colors.primaryText,
                        size: AppSpacing.navIconSize),
                  ),
                ],
              ),
            ),
            if (!isEmpty)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    0,
                    AppSpacing.pageHorizontal,
                    AppSpacing.xxl,
                  ),
                  children: [
                    _SavingsSummary(
                      totalSaved: context.watch<SavingsProvider>().totalSaved,
                      targetCount: targets.length,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.activeTargets,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...targets.map(
                      (target) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _TargetCard(target: target),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _SavingHabitCard(target: targets.first),
                    const SizedBox(height: AppSpacing.lg),
                    const _MonthlyActivity(),
                  ],
                ),
              ),
            if (isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageHorizontal,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.savings_rounded,
                          size: 72,
                          color: context.colors.primaryText
                              .withValues(alpha: 0.35),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.startSavingTitle,
                          style: AppTextStyles.pageTitle.copyWith(
                            color: context.colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l10n.savingEmptyMessage,
                          style: AppTextStyles.billMeta.copyWith(
                            color: context.colors.mutedText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        FilledButton.icon(
                          onPressed: () => _createTarget(context),
                          icon: const Icon(Icons.add_rounded),
                          label: Text(l10n.createFirstSavings),
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusCard,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: NavTab.savings),
    );
  }
}

class _SavingsSummary extends StatelessWidget {
  final double totalSaved;
  final int targetCount;

  const _SavingsSummary({required this.totalSaved, required this.targetCount});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final onPrimary = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Theme.of(context).colorScheme.onPrimary;
    final money = NumberFormat.currency(
      locale: locale,
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(totalSaved);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        gradient: LinearGradient(
          colors: [context.colors.primary, context.colors.deepGreen],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.totalSavings,
                  style: AppTextStyles.footnote.copyWith(
                    color: onPrimary.withValues(alpha: 0.82),
                  ),
                ),
                Text(
                  money,
                  style: AppTextStyles.pageTitle.copyWith(
                    color: onPrimary,
                  ),
                ),
                Text(
                  l10n.collectedFromTargets(targetCount),
                  style: AppTextStyles.billRemainingDays.copyWith(
                    color: onPrimary.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            width: AppSpacing.cardIconContainerSize,
            height: AppSpacing.cardIconContainerSize,
            decoration: BoxDecoration(
              color: context.colors.surface,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Image.asset(
              'assets/images/piggy_icon.png',
              errorBuilder: (_, __, ___) => Icon(
                Icons.savings_rounded,
                color: context.colors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  final SavingsTarget target;

  const _TargetCard({required this.target});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final money = NumberFormat.currency(
      locale: locale,
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final percent = (target.progress * 100).round();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(
          color: context.colors.border,
          width: AppSpacing.borderThin,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.billIconCircleSize,
            height: AppSpacing.billIconCircleSize,
            decoration: BoxDecoration(
              color: context.colors.softSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.savings_rounded,
                color: context.colors.primaryText,
                size: AppSpacing.billIconSize),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(target.name,
                    style: AppTextStyles.billName.copyWith(
                      color: context.colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.savedAmountSummary(
                    money.format(target.savedAmount),
                    money.format(target.amount),
                  ),
                  style: AppTextStyles.billMeta.copyWith(
                    color: context.colors.mutedText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  child: LinearProgressIndicator(
                    value: target.progress,
                    minHeight: AppSpacing.calendarDotSize,
                    backgroundColor: context.colors.softSurface,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        l10n.targetReached(percent),
                        style: AppTextStyles.billRemainingDays.copyWith(
                          color: context.colors.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        l10n.targetDate(
                          DateFormat('d MMM yyyy', locale)
                              .format(target.targetDate),
                        ),
                        style: AppTextStyles.billRemainingDays.copyWith(
                          color: context.colors.mutedText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingHabitCard extends StatelessWidget {
  final SavingsTarget target;

  const _SavingHabitCard({required this.target});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final interval = target.intervalDays == 1
        ? l10n.everyDay
        : target.intervalDays == 7
            ? l10n.everyWeek
            : l10n.everyDays(target.intervalDays);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(
          color: context.colors.border,
          width: AppSpacing.borderThin,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSpacing.billIconCircleSize / 2,
            backgroundColor: context.colors.todayFill,
            child: Icon(Icons.local_fire_department_rounded,
                color: context.colors.warningText,
                size: AppSpacing.billIconSize),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.savingHabitTitle,
                  style: AppTextStyles.billName.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  l10n.checkInNotDone,
                  style: AppTextStyles.billMeta.copyWith(
                    color: context.colors.mutedText,
                  ),
                ),
                Text(l10n.targetPrefix(interval),
                    style: AppTextStyles.billMeta.copyWith(
                      color: context.colors.primaryText,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: context.colors.primaryText, size: AppSpacing.navIconSize),
        ],
      ),
    );
  }
}

class _MonthlyActivity extends StatelessWidget {
  const _MonthlyActivity();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final firstWeekday = DateTime(now.year, now.month, 1).weekday % 7;
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final month = DateFormat('MMMM yyyy', locale).format(now);
    final cells = <Widget>[];
    for (var index = 0; index < 7; index++) {
      final weekday =
          DateFormat('E', locale).format(DateTime(2023, 1, index + 1));
      cells.add(Center(
        child: Text(
          weekday,
          style: AppTextStyles.weekdayLabel.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
      ));
    }
    for (var i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final isToday = day == now.day;
      cells.add(Center(
        child: Container(
          width: AppSpacing.calendarDaySize,
          height: AppSpacing.calendarDaySize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isToday
                ? context.colors.todayFill
                : context.colors.canvas.withValues(alpha: 0),
            shape: BoxShape.circle,
            border:
                isToday ? Border.all(color: context.colors.todayRing) : null,
          ),
          child: Text('$day',
              style: (isToday
                      ? AppTextStyles.calendarDayBold
                      : AppTextStyles.calendarDay)
                  .copyWith(color: context.colors.textPrimary)),
        ),
      ));
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(
          color: context.colors.border,
          width: AppSpacing.borderThin,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  l10n.monthlyActivity,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  month,
                  style: AppTextStyles.billMeta.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.xs,
            crossAxisSpacing: AppSpacing.xxs,
            childAspectRatio: 1.0,
            children: cells,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.noMonthlyCheckIn,
            style: AppTextStyles.footnote.copyWith(
              color: context.colors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}
