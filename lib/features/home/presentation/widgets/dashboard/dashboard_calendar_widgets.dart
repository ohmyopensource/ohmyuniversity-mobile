import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../../shared/widgets/custom_text/custom_text_widget.dart';
import '../../../../calendario/domain/entities/calendar_event_entity.dart';
import '../../../../calendario/presentation/widgets/calendar_date_labels.dart';
import '../../../../calendario/presentation/widgets/calendar_event_type_ui.dart';

class DashboardCalendarAgendaWidget extends StatelessWidget {
  const DashboardCalendarAgendaWidget({
    super.key,
    required this.date,
    required this.events,
  });

  final DateTime date;
  final List<CalendarEventEntity> events;

  @override
  Widget build(BuildContext context) {
    final today = DateTime(date.year, date.month, date.day);
    final tomorrow = today.add(const Duration(days: 1));
    final visibleEvents = [
      ..._eventsForDay(events, today).map(
        (event) => _DashboardCalendarEventPreview(event: event, label: 'Oggi'),
      ),
      ..._eventsForDay(events, tomorrow).map(
        (event) =>
            _DashboardCalendarEventPreview(event: event, label: 'Domani'),
      ),
    ];

    return CustomCardWidget(
      variant: CardVariant.defaultVariant,
      shadow: CardShadow.md,
      radius: CardRadius.lg,
      padding: CardPadding.none,
      bordered: true,
      stretchHeight: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimaryLight.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(AppColors.radiusLg),
                  ),
                  child: const Icon(
                    LucideIcons.calendarDays,
                    color: AppColors.colorPrimaryDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomTextWidget(
                        text: 'Agenda',
                        variant: TextVariant.body,
                        weight: TextWeight.extraBold,
                        color: TextColor.primary,
                        noWrap: true,
                      ),
                      const SizedBox(height: 2),
                      CustomTextWidget(
                        text:
                            '${_weekdayShort(today)} ${today.day} '
                            '${_monthShort(today)}',
                        variant: TextVariant.caption,
                        weight: TextWeight.bold,
                        color: TextColor.muted,
                        noWrap: true,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.colorNeutral100,
                    borderRadius: BorderRadius.circular(AppColors.radiusLg),
                    border: Border.all(color: AppColors.colorNeutral200),
                  ),
                  child: CustomTextWidget(
                    text: today.day.toString(),
                    variant: TextVariant.h4,
                    weight: TextWeight.extraBold,
                    color: TextColor.primary,
                    noWrap: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: visibleEvents.isEmpty
                  ? const _DashboardCalendarEmptyState()
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: visibleEvents.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        return _DashboardCalendarEventRow(
                          preview: visibleEvents[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCalendarEventRow extends StatelessWidget {
  const _DashboardCalendarEventRow({required this.preview});

  final _DashboardCalendarEventPreview preview;

  @override
  Widget build(BuildContext context) {
    final event = preview.event;

    return CustomCardWidget(
      variant: event.type.cardVariant,
      shadow: CardShadow.none,
      radius: CardRadius.md,
      padding: CardPadding.none,
      bordered: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.68),
                borderRadius: BorderRadius.circular(AppColors.radiusMd),
              ),
              child: Icon(
                event.type.icon,
                color: event.type.foregroundColor,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: event.title,
                    variant: TextVariant.caption,
                    weight: TextWeight.extraBold,
                    color: TextColor.primary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    noWrap: true,
                  ),
                  const SizedBox(height: 2),
                  CustomTextWidget(
                    text: preview.label,
                    variant: TextVariant.overline,
                    weight: TextWeight.bold,
                    color: TextColor.muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    noWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CustomTextWidget(
              text: CalendarDateLabels.time(event.startDate),
              variant: TextVariant.overline,
              weight: TextWeight.extraBold,
              color: TextColor.primary,
              noWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCalendarEmptyState extends StatelessWidget {
  const _DashboardCalendarEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.colorNeutral100,
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
          border: Border.all(color: AppColors.colorNeutral200),
        ),
        child: const CustomTextWidget(
          text: 'Nessun evento in agenda',
          variant: TextVariant.caption,
          weight: TextWeight.bold,
          color: TextColor.muted,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          noWrap: true,
        ),
      ),
    );
  }
}

class _DashboardCalendarEventPreview {
  const _DashboardCalendarEventPreview({
    required this.event,
    required this.label,
  });

  final CalendarEventEntity event;
  final String label;
}

List<CalendarEventEntity> _eventsForDay(
  List<CalendarEventEntity> events,
  DateTime date,
) {
  final start = DateTime(date.year, date.month, date.day);
  final end = start.add(const Duration(days: 1));

  return events.where((event) {
    return event.startDate.isBefore(end) && event.endDate.isAfter(start);
  }).toList()..sort((a, b) => a.startDate.compareTo(b.startDate));
}

String _weekdayShort(DateTime date) {
  const weekdays = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];

  return weekdays[date.weekday - 1];
}

String _monthShort(DateTime date) {
  const months = [
    'Gen',
    'Feb',
    'Mar',
    'Apr',
    'Mag',
    'Giu',
    'Lug',
    'Ago',
    'Set',
    'Ott',
    'Nov',
    'Dic',
  ];

  return months[date.month - 1];
}
