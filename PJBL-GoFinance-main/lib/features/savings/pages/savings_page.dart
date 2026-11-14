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
                      'Target Tabungan',
                      style: AppTextStyles.pageTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    key: const Key('btn_add_savings_target'),
                    tooltip: 'Buat target tabungan',
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
                    Text('Target Aktif', style: AppTextStyles.sectionTitle),
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
                          'Yuk, Mulai Menabung!',
                          style: AppTextStyles.pageTitle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Tentukan target dan sisihkan sedikit demi sedikit — langkah kecil menuju impian besar.',
                          style: AppTextStyles.billMeta,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        FilledButton.icon(
                          onPressed: () => _createTarget(context),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Buat Tabungan Pertama'),
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
    final money = NumberFormat.currency(
      locale: 'id_ID',
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
                  'Total Tabungan',
                  style: AppTextStyles.footnote.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.82),
                  ),
                ),
                Text(
                  money,
                  style: AppTextStyles.pageTitle.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  'Terkumpul dari $targetCount target',
                  style: AppTextStyles.billRemainingDays.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.8),
                  ),
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
    final money = NumberFormat.currency(
      locale: 'id_ID',
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
                    style: AppTextStyles.billName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${money.format(target.savedAmount)} dari ${money.format(target.amount)}',
                  style: AppTextStyles.billMeta,
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
                    Text('$percent% tercapai',
                        style: AppTextStyles.billRemainingDays.copyWith(
                          color: context.colors.primaryText,
                          fontWeight: FontWeight.w700,
                        )),
                    const Spacer(),
                    Text(
                      'Target: ${DateFormat('d MMM yyyy', 'id_ID').format(target.targetDate)}',
                      style: AppTextStyles.billRemainingDays,
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
    final interval = target.intervalDays == 1
        ? 'Setiap hari'
        : target.intervalDays == 7
            ? 'Setiap minggu'
            : 'Setiap ${target.intervalDays} hari';
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
                Text('Mulai kebiasaan menabung', style: AppTextStyles.billName),
                Text('Check-in belum dilakukan', style: AppTextStyles.billMeta),
                Text('Target: $interval',
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
    final now = DateTime.now();
    final firstWeekday = DateTime(now.year, now.month, 1).weekday % 7;
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final month = DateFormat('MMMM yyyy', 'id_ID').format(now);
    final cells = <Widget>[];
    const weekdays = ['Mi', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    for (final weekday in weekdays) {
      cells.add(Center(
        child: Text(weekday, style: AppTextStyles.weekdayLabel),
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
                ? context.colors.softSurface
                : context.colors.canvas.withValues(alpha: 0),
            shape: BoxShape.circle,
            border:
                isToday ? Border.all(color: context.colors.primaryText) : null,
          ),
          child: Text('$day',
              style: isToday
                  ? AppTextStyles.calendarDayBold
                  : AppTextStyles.calendarDay),
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
              Text('Aktivitas Bulan Ini', style: AppTextStyles.sectionTitle),
              const Spacer(),
              Text(month, style: AppTextStyles.billMeta),
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
          Text('Belum ada check-in bulan ini', style: AppTextStyles.footnote),
        ],
      ),
    );
  }
}
