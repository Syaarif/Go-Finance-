import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/features/bills/providers/bill_provider.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

/// Kalender kustom (Min–Sab) dengan indikator hari ini, tagihan aktif, dan seleksi tanggal.
class BillCalendar extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime today;
  final DateTime? selectedDate;
  final bool Function(DateTime date) hasBillOnDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const BillCalendar({
    super.key,
    required this.focusedMonth,
    required this.today,
    required this.selectedDate,
    required this.hasBillOnDate,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final monthTitle = _formatMonthYear(focusedMonth, locale);
    final activeHeaderDate = selectedDate ?? today;
    final shortSelectedText = _formatShortDate(activeHeaderDate, locale);

    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    // Minggu = 0, Senin = 1, ..., Sabtu = 6
    final leadingEmpty = firstDayOfMonth.weekday % 7;
    final totalCells = leadingEmpty + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
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
            blurRadius: AppSpacing.md,
            offset: const Offset(0, AppSpacing.xs),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: "<Bulan> <Tahun> · <Tanggal terpilih>" + panah ‹ dan ›
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: monthTitle,
                      style: AppTextStyles.calendarHeader.copyWith(
                        color: context.colors.textPrimary,
                      ),
                      children: [
                        TextSpan(
                          text: ' · $shortSelectedText',
                          style:
                              AppTextStyles.calendarSelectedSubtitle.copyWith(
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _MonthNavButton(
                  icon: Icons.chevron_left_rounded,
                  tooltip: l10n.previousMonth,
                  onTap: onPreviousMonth,
                ),
                const SizedBox(width: AppSpacing.xs),
                _MonthNavButton(
                  icon: Icons.chevron_right_rounded,
                  tooltip: l10n.nextMonth,
                  onTap: onNextMonth,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Baris nama hari: Min..Sab
          Row(
            children: List.generate(7, (index) {
              final weekday =
                  DateFormat('E', locale).format(DateTime(2023, 1, index + 1));
              return Expanded(
                child: Center(
                  child: Text(
                    weekday,
                    style: AppTextStyles.weekdayLabel.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Grid tanggal
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(rowCount, (rowIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                child: Row(
                  children: List.generate(7, (colIndex) {
                    final cellIndex = rowIndex * 7 + colIndex;
                    final dayNumber = cellIndex - leadingEmpty + 1;
                    if (dayNumber < 1 || dayNumber > daysInMonth) {
                      return const Expanded(
                        child: SizedBox(height: AppSpacing.calendarCellHeight),
                      );
                    }

                    final date = DateTime(
                      focusedMonth.year,
                      focusedMonth.month,
                      dayNumber,
                    );
                    final isToday = BillProvider.isSameDay(date, today);
                    final isSelected = selectedDate != null &&
                        BillProvider.isSameDay(date, selectedDate!);
                    final hasBill = hasBillOnDate(date);

                    return Expanded(
                      child: _CalendarDayCell(
                        dayNumber: dayNumber,
                        isToday: isToday,
                        isSelected: isSelected,
                        hasBill: hasBill,
                        onTap: () => onDateSelected(date),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  static String _formatMonthYear(DateTime date, String locale) =>
      DateFormat('MMMM yyyy', locale).format(date);

  static String _formatShortDate(DateTime date, String locale) =>
      DateFormat('d MMM', locale).format(date);
}

class _MonthNavButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _MonthNavButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedSquareIcon(
      icon: icon,
      backgroundColor: context.colors.softSurface,
      iconColor: context.colors.primaryText,
      size: 32,
      iconSize: 18,
      borderRadius: AppSpacing.radiusXs,
      tooltip: tooltip,
      onTap: onTap,
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final int dayNumber;
  final bool isToday;
  final bool isSelected;
  final bool hasBill;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.dayNumber,
    required this.isToday,
    required this.isSelected,
    required this.hasBill,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color circleColor = context.colors.canvas.withValues(alpha: 0);
    Border? border;
    TextStyle textStyle = AppTextStyles.calendarDay;
    Color? dotColor;

    if (isSelected) {
      circleColor = context.colors.primary;
      textStyle = AppTextStyles.calendarDaySelected;
      if (hasBill) {
        dotColor = context.colors.textPrimary;
      } else if (isToday) {
        dotColor = context.colors.todayRing;
      }
    } else if (isToday && hasBill) {
      circleColor = context.colors.billHighlight;
      border = Border.all(
        color: context.colors.todayRing,
        width: AppSpacing.borderRing,
      );
      textStyle = AppTextStyles.calendarDayBold;
      dotColor = context.colors.primaryText;
    } else if (isToday) {
      circleColor = context.colors.todayFill;
      border = Border.all(
        color: context.colors.todayRing,
        width: AppSpacing.borderRing,
      );
      textStyle = AppTextStyles.calendarDayBold;
      dotColor = context.colors.todayRing;
    } else if (hasBill) {
      circleColor = context.colors.billHighlight;
      textStyle = AppTextStyles.calendarDayBold;
      dotColor = context.colors.primaryText;
    }

    return SizedBox(
      height: AppSpacing.calendarCellHeight,
      child: Center(
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: AppSpacing.calendarDaySize,
            height: AppSpacing.calendarCellHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: AppSpacing.calendarDaySize,
                  height: AppSpacing.calendarDaySize,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                    border: border,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$dayNumber',
                    style: textStyle.copyWith(
                      color: isSelected
                          ? Colors.white
                          : context.colors.textPrimary,
                    ),
                  ),
                ),
                if (dotColor != null)
                  Positioned(
                    bottom: AppSpacing.xxs,
                    child: Container(
                      width: AppSpacing.calendarDotSize,
                      height: AppSpacing.calendarDotSize,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
