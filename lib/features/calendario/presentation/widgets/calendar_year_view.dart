import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/calendar_event_entity.dart';
import 'calendar_date_labels.dart';
import 'calendar_event_type_ui.dart';

class CalendarYearView extends StatelessWidget {
  const CalendarYearView({
    super.key,
    required this.focusedDate,
    required this.events,
    required this.onMonthSelected,
    required this.onYearChanged,
  });

  final DateTime focusedDate;
  final List<CalendarEventEntity> events;
  final ValueChanged<DateTime> onMonthSelected;
  final ValueChanged<DateTime> onYearChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Anno precedente',
                onPressed: () => onYearChanged(
                  DateTime(focusedDate.year - 1, focusedDate.month),
                ),
                icon: const Icon(LucideIcons.chevronLeft),
              ),
              Expanded(
                child: Text(
                  focusedDate.year.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Anno successivo',
                onPressed: () => onYearChanged(
                  DateTime(focusedDate.year + 1, focusedDate.month),
                ),
                icon: const Icon(LucideIcons.chevronRight),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 100),
            physics: const BouncingScrollPhysics(),
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.96,
            ),
            itemBuilder: (context, index) {
              final month = DateTime(focusedDate.year, index + 1);
              return _YearMonthCard(
                month: month,
                events: events,
                onTap: () => onMonthSelected(month),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _YearMonthCard extends StatelessWidget {
  const _YearMonthCard({
    required this.month,
    required this.events,
    required this.onTap,
  });

  final DateTime month;
  final List<CalendarEventEntity> events;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final days = _monthGridDays(month);

    return CustomCardWidget(
      variant: CardVariant.defaultVariant,
      padding: CardPadding.none,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      clickable: true,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CalendarDateLabels.shortMonth(month).toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.colorPrimaryDark,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: days.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final date = days[index];
                  if (date.month != month.month) return const SizedBox.shrink();
                  final event = _firstEventForDay(date);
                  final today = _isSameDay(date, DateTime.now());
                  final weekend = date.weekday >= DateTime.saturday;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 17,
                        height: 17,
                        alignment: Alignment.center,
                        decoration: today
                            ? const BoxDecoration(
                                color: AppColors.colorPrimaryLight,
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: today
                                ? AppColors.colorPrimaryText
                                : weekend
                                ? AppColors.colorNeutral400
                                : AppColors.colorNeutral600,
                            fontSize: 8.5,
                            fontWeight: today
                                ? FontWeight.w900
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color:
                              event?.type.foregroundColor ?? Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  CalendarEventEntity? _firstEventForDay(DateTime date) {
    for (final event in events) {
      if (_isSameDay(event.startDate, date)) return event;
    }
    return null;
  }

  List<DateTime> _monthGridDays(DateTime date) {
    final firstDay = DateTime(date.year, date.month);
    final gridStart = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    return List.generate(42, (index) => gridStart.add(Duration(days: index)));
  }
}

bool _isSameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
