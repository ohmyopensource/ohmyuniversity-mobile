import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/calendar_event_entity.dart';
import 'calendar_date_labels.dart';
import 'calendar_event_type_ui.dart';

class CalendarMonthView extends StatelessWidget {
  const CalendarMonthView({
    super.key,
    required this.focusedDate,
    required this.events,
    required this.onDaySelected,
    required this.onMonthChanged,
  });

  final DateTime focusedDate;
  final List<CalendarEventEntity> events;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onMonthChanged;

  static const _weekdays = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];

  @override
  Widget build(BuildContext context) {
    final days = _monthGridDays(focusedDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 100),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _NavigationHeader(
            label: CalendarDateLabels.fullMonthYear(focusedDate),
            previousLabel: 'Mese precedente',
            nextLabel: 'Mese successivo',
            onPrevious: () => onMonthChanged(
              DateTime(focusedDate.year, focusedDate.month - 1),
            ),
            onNext: () => onMonthChanged(
              DateTime(focusedDate.year, focusedDate.month + 1),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _weekdays
                .map(
                  (label) => Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.colorNeutral500,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 7),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.55,
            ),
            itemBuilder: (context, index) {
              final date = days[index];
              return _MonthDayCell(
                date: date,
                inFocusedMonth: date.month == focusedDate.month,
                events: _eventsForDay(date),
                onTap: () => onDaySelected(date),
              );
            },
          ),
        ],
      ),
    );
  }

  List<DateTime> _monthGridDays(DateTime date) {
    final firstDay = DateTime(date.year, date.month);
    final gridStart = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    return List.generate(42, (index) => gridStart.add(Duration(days: index)));
  }

  List<CalendarEventEntity> _eventsForDay(DateTime date) {
    final matches = events.where((event) => _isSameDay(event.startDate, date));
    return matches.toList(growable: false)
      ..sort((first, second) => first.startDate.compareTo(second.startDate));
  }
}

class _MonthDayCell extends StatelessWidget {
  const _MonthDayCell({
    required this.date,
    required this.inFocusedMonth,
    required this.events,
    required this.onTap,
  });

  final DateTime date;
  final bool inFocusedMonth;
  final List<CalendarEventEntity> events;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final today = _isSameDay(date, DateTime.now());
    final visibleEvents = events.take(2).toList(growable: false);

    return Opacity(
      opacity: inFocusedMonth ? 1 : 0.42,
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: CustomCardWidget(
          variant: today ? CardVariant.info : CardVariant.defaultVariant,
          padding: CardPadding.none,
          shadow: CardShadow.none,
          radius: CardRadius.sm,
          bordered: true,
          clickable: true,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(3, 5, 3, 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date.day.toString(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: today
                        ? AppColors.colorInfoText
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                ...visibleEvents.map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: CustomBadgeWidget(
                        label: _shortLabel(event.title),
                        variant: event.type.badgeVariant,
                        size: BadgeSize.xs,
                        shape: BadgeShape.rounded,
                      ),
                    ),
                  ),
                ),
                if (events.length > 2)
                  Text(
                    '+${events.length - 2}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.colorNeutral500,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _shortLabel(String value) {
    final trimmed = value.trim();
    return trimmed.length <= 6 ? trimmed : '${trimmed.substring(0, 5)}…';
  }
}

class _NavigationHeader extends StatelessWidget {
  const _NavigationHeader({
    required this.label,
    required this.previousLabel,
    required this.nextLabel,
    required this.onPrevious,
    required this.onNext,
  });

  final String label;
  final String previousLabel;
  final String nextLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: previousLabel,
          onPressed: onPrevious,
          icon: const Icon(LucideIcons.chevronLeft),
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        IconButton(
          tooltip: nextLabel,
          onPressed: onNext,
          icon: const Icon(LucideIcons.chevronRight),
        ),
      ],
    );
  }
}

bool _isSameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
