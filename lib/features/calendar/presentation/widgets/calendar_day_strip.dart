import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import 'calendar_date_labels.dart';

class CalendarDayStrip extends StatelessWidget {
  const CalendarDayStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final weekDays = _weekDaysFor(selectedDate);

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 16),
      child: Row(
        children: weekDays
            .map((date) {
              final isSelected = _isSameDay(date, selectedDate);
              final isSunday = date.weekday == DateTime.sunday;

              return Expanded(
                child: _CalendarWeekTab(
                  date: date,
                  isSelected: isSelected,
                  isSunday: isSunday,
                  onTap: () => onDateSelected(date),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _CalendarWeekTab extends StatelessWidget {
  const _CalendarWeekTab({
    required this.date,
    required this.isSelected,
    required this.isSunday,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isSunday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = isSunday
        ? AppColors.colorErrorText.withValues(alpha: 0.68)
        : AppColors.textPrimary.withValues(alpha: 0.46);
    final selectedTextColor = AppColors.colorPrimaryText;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${CalendarDateLabels.weekday(date)} ${date.day}',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppColors.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            height: 58,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.colorPrimaryLight
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppColors.radiusMd),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.colorPrimaryDark.withValues(
                          alpha: 0.12,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : const [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  CalendarDateLabels.weekday(date),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? selectedTextColor : mutedColor,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${date.day}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isSelected
                        ? selectedTextColor
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    height: 1,
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

List<DateTime> _weekDaysFor(DateTime selectedDate) {
  final monday = selectedDate.subtract(
    Duration(days: selectedDate.weekday - 1),
  );

  return List.generate(
    DateTime.daysPerWeek,
    (index) => DateTime(monday.year, monday.month, monday.day + index),
  );
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
