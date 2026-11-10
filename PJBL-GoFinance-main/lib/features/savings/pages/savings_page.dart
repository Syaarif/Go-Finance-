import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/theme/app_colors.dart';
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
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Target Tabungan',
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 18),
                    ),
                  ),
                  IconButton(
                    key: const Key('btn_add_savings_target'),
                    tooltip: 'Buat target tabungan',
                    onPressed: () => _createTarget(context),
                    icon: const Icon(Icons.add_rounded,
                        color: AppColors.deepGreen, size: 25),
                  ),
                ],
              ),
            ),
            if (!isEmpty)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
                  children: [
                    _SavingsSummary(
                      totalSaved: context.watch<SavingsProvider>().totalSaved,
                      targetCount: targets.length,
                    ),
                    const SizedBox(height: 12),
                    Text('Target Aktif', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 8),
                    ...targets.map(
                      (target) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _TargetCard(target: target),
                      ),
                    ),
                    const SizedBox(height: 2),
                    _SavingHabitCard(target: targets.first),
                    const SizedBox(height: 14),
                    const _MonthlyActivity(),
                  ],
                ),
              ),
            if (isEmpty) const Expanded(child: SizedBox.shrink()),
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
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.deepGreen],
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
                    color: AppColors.surface.withValues(alpha: 0.82),
                    fontSize: 9,
                  ),
                ),
                Text(
                  money,
                  style: AppTextStyles.pageTitle.copyWith(
                    color: AppColors.surface,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Terkumpul dari $targetCount target',
                  style: AppTextStyles.footnote.copyWith(
                    color: AppColors.surface.withValues(alpha: 0.8),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/piggy_icon.png',
              errorBuilder: (_, __, ___) => const Icon(
                Icons.savings_rounded,
                color: AppColors.primary,
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
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.softSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.savings_rounded,
                color: AppColors.primary, size: 19),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(target.name,
                    style: AppTextStyles.billName.copyWith(fontSize: 11)),
                const SizedBox(height: 2),
                Text(
                  '${money.format(target.savedAmount)} dari ${money.format(target.amount)}',
                  style: AppTextStyles.footnote.copyWith(fontSize: 8),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: target.progress,
                    minHeight: 5,
                    backgroundColor: AppColors.softSurface,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text('$percent% tercapai',
                        style: AppTextStyles.billMeta.copyWith(
                          color: AppColors.primary,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        )),
                    const Spacer(),
                    Text(
                      'Target: ${DateFormat('d MMM yyyy', 'id_ID').format(target.targetDate)}',
                      style: AppTextStyles.billMeta.copyWith(fontSize: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.todayFill,
            child: Icon(Icons.local_fire_department_rounded,
                color: AppColors.warningText, size: 19),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mulai kebiasaan menabung',
                    style: AppTextStyles.billName.copyWith(fontSize: 10)),
                Text('Check-in belum dilakukan',
                    style: AppTextStyles.billMeta.copyWith(fontSize: 8)),
                Text('Target: $interval',
                    style: AppTextStyles.billMeta.copyWith(
                      color: AppColors.deepGreen,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.secondary, size: 19),
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
        child: Text(weekday,
            style: AppTextStyles.billMeta.copyWith(fontSize: 7)),
      ));
    }
    for (var i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final isToday = day == now.day;
      cells.add(Center(
        child: Container(
          width: 19,
          height: 19,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isToday ? AppColors.softSurface : Colors.transparent,
            shape: BoxShape.circle,
            border: isToday ? Border.all(color: AppColors.primary) : null,
          ),
          child: Text('$day',
              style: AppTextStyles.billMeta.copyWith(
                color: AppColors.deepGreen,
                fontSize: 7,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
              )),
        ),
      ));
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('Aktivitas Bulan Ini',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 10)),
              const Spacer(),
              Text(month,
                  style: AppTextStyles.billMeta.copyWith(fontSize: 8)),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 2,
            childAspectRatio: 1.65,
            children: cells,
          ),
          const SizedBox(height: 3),
          Text('Belum ada check-in bulan ini',
              style: AppTextStyles.billMeta.copyWith(fontSize: 8)),
        ],
      ),
    );
  }
}