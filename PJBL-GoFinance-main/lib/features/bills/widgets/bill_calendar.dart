import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/features/bills/providers/bill_provider.dart';

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

  static const List<String> _weekdays = [
    'Min',
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
  ];

  @override
  Widget build(BuildContext context) {
    final monthTitle = _formatMonthYear(focusedMonth);
    final activeHeaderDate = selectedDate ?? today;
    final shortSelectedText = _formatShortDate(activeHeaderDate);

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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.border,
          width: AppSpacing.borderThin,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: AppSpacing.md,
            offset: Offset(0, AppSpacing.xs),
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
                      style: AppTextStyles.calendarHeader,
                      children: [
                        TextSpan(
                          text: ' · $shortSelectedText',
                          style: AppTextStyles.calendarSelectedSubtitle,
                        ),
                      ],
                    ),
                  ),
                ),
                _MonthNavButton(
                  icon: Icons.chevron_left_rounded,
                  tooltip: 'Bulan sebelumnya',
                  onTap: onPreviousMonth,
                ),
                const SizedBox(width: AppSpacing.xs),
                _MonthNavButton(
                  icon: Icons.chevron_right_rounded,
                  tooltip: 'Bulan berikutnya',
                  onTap: onNextMonth,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Baris nama hari: Min..Sab
          Row(
            children: _weekdays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(day, style: AppTextStyles.weekdayLabel),
                    ),
                  ),
                )
                .toList(growable: false),
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

  static String _formatMonthYear(DateTime date) {
    try {
      return DateFormat('MMMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('MMMM yyyy').format(date);
    }
  }

  static String _formatShortDate(DateTime date) {
    try {
      return DateFormat('d MMM', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('d MMM').format(date);
    }
  }
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
      backgroundColor: AppColors.softSurface,
      iconColor: AppColors.deepGreen,
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
    Color circleColor = AppColors.transparent;
    Border? border;
    TextStyle textStyle = AppTextStyles.calendarDay;
    Color? dotColor;

    if (isSelected) {
      circleColor = AppColors.primary;
      textStyle = AppTextStyles.calendarDaySelected;
      if (hasBill) {
        dotColor = AppColors.deepGreen;
      } else if (isToday) {
        dotColor = AppColors.todayRing;
      }
    } else if (isToday && hasBill) {
      circleColor = AppColors.billHighlight;
      border = Border.all(
        color: AppColors.todayRing,
        width: AppSpacing.borderRing,
      );
      textStyle = AppTextStyles.calendarDayBold;
      dotColor = AppColors.primary;
    } else if (isToday) {
      circleColor = AppColors.todayFill;
      border = Border.all(
        color: AppColors.todayRing,
        width: AppSpacing.borderRing,
      );
      textStyle = AppTextStyles.calendarDayBold;
      dotColor = AppColors.todayRing;
    } else if (hasBill) {
      circleColor = AppColors.billHighlight;
      textStyle = AppTextStyles.calendarDayBold;
      dotColor = AppColors.primary;
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
                  child: Text('$dayNumber', style: textStyle),
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

