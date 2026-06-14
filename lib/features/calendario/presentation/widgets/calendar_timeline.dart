import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/calendar_event_entity.dart';
import 'calendar_event_card.dart';

class CalendarTimeline extends StatefulWidget {
  const CalendarTimeline({
    super.key,
    required this.events,
    required this.selectedDate,
    required this.currentTime,
    required this.selectedHour,
    required this.onHourSelected,
    required this.onEventSelected,
  });

  final List<CalendarEventEntity> events;
  final DateTime selectedDate;
  final DateTime currentTime;
  final int? selectedHour;
  final ValueChanged<int> onHourSelected;
  final ValueChanged<CalendarEventEntity> onEventSelected;

  static const startHour = 8;
  static const endHour = 20;
  static const leftGutter = 70.0;
  static const hourHeight = 104.0;

  @override
  State<CalendarTimeline> createState() => _CalendarTimelineState();
}

class _CalendarTimelineState extends State<CalendarTimeline> {
  late final ScrollController _scrollController;
  int? _lastFocusedHour;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scheduleFocusScroll();
  }

  @override
  void didUpdateWidget(covariant CalendarTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);

    final dateChanged = !_isSameDay(
      oldWidget.selectedDate,
      widget.selectedDate,
    );
    final hourChanged = oldWidget.selectedHour != widget.selectedHour;
    final currentHourChanged =
        oldWidget.currentTime.hour != widget.currentTime.hour;

    if (dateChanged || hourChanged || currentHourChanged) {
      _scheduleFocusScroll();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isToday = _isSameDay(widget.selectedDate, widget.currentTime);
    final focusedHour = _focusedHour(isToday);
    final sortedEvents = [...widget.events]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    final eventLayouts = _buildEventLayouts(sortedEvents);
    final totalHours =
        CalendarTimeline.endHour - CalendarTimeline.startHour + 1;
    final timelineHeight = totalHours * CalendarTimeline.hourHeight;

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 46),
      child: SizedBox(
        height: timelineHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ...List.generate(totalHours, (index) {
              final hour = CalendarTimeline.startHour + index;
              final isCurrentHour = isToday && widget.currentTime.hour == hour;
              final isFocusedHour = focusedHour == hour;

              return _TimelineHourBlock(
                hour: hour,
                currentTime: widget.currentTime,
                isCurrentHour: isCurrentHour,
                isFocusedHour: isFocusedHour,
                onTap: () => widget.onHourSelected(hour),
              );
            }),
            ...eventLayouts.map(
              (layout) => _PositionedCalendarEvent(
                layout: layout,
                onTap: widget.onEventSelected,
              ),
            ),
            if (focusedHour != null &&
                !_hasEventsIntersectingHour(sortedEvents, focusedHour))
              _TimelineEmptyHourCard(hour: focusedHour),
          ],
        ),
      ),
    );
  }

  void _scheduleFocusScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      final isToday = _isSameDay(widget.selectedDate, widget.currentTime);
      final focusedHour = _focusedHour(isToday);
      if (focusedHour == null || focusedHour == _lastFocusedHour) return;

      _lastFocusedHour = focusedHour;
      final targetOffset = _hourTop(focusedHour) - 78;
      final maxOffset = _scrollController.position.maxScrollExtent;
      final safeOffset = targetOffset.clamp(0.0, maxOffset);

      _scrollController.animateTo(
        safeOffset,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    });
  }

  int? _focusedHour(bool isToday) {
    if (widget.selectedHour != null) return _visibleHour(widget.selectedHour!);
    if (!isToday) return null;
    return _visibleHour(widget.currentTime.hour);
  }

  bool _hasEventsIntersectingHour(List<CalendarEventEntity> events, int hour) {
    final hourStart = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      hour,
    );
    final hourEnd = hourStart.add(const Duration(hours: 1));

    return events.any((event) {
      final startsBeforeHourEnds = event.startDate.isBefore(hourEnd);
      final endsAfterHourStarts = event.endDate.isAfter(hourStart);
      return startsBeforeHourEnds && endsAfterHourStarts;
    });
  }
}

class _CalendarEventLayout {
  const _CalendarEventLayout({
    required this.event,
    required this.lane,
    required this.laneCount,
  });

  final CalendarEventEntity event;
  final int lane;
  final int laneCount;
}

List<_CalendarEventLayout> _buildEventLayouts(
  List<CalendarEventEntity> sortedEvents,
) {
  final activeEvents = <_ActiveCalendarEvent>[];
  final pendingLayouts = <_MutableCalendarEventLayout>[];

  for (final event in sortedEvents) {
    activeEvents.removeWhere(
      (active) => !active.event.endDate.isAfter(event.startDate),
    );

    var lane = 0;
    while (activeEvents.any((active) => active.lane == lane)) {
      lane++;
    }

    activeEvents.add(_ActiveCalendarEvent(event: event, lane: lane));
    final laneCount = math.max(1, activeEvents.length);

    for (final active in activeEvents) {
      final layout = pendingLayouts.lastWhere(
        (item) => item.event == active.event,
        orElse: () {
          final item = _MutableCalendarEventLayout(
            event: active.event,
            lane: active.lane,
          );
          pendingLayouts.add(item);
          return item;
        },
      );
      layout.laneCount = math.max(layout.laneCount, laneCount);
    }
  }

  return pendingLayouts
      .map(
        (layout) => _CalendarEventLayout(
          event: layout.event,
          lane: layout.lane,
          laneCount: layout.laneCount,
        ),
      )
      .toList(growable: false);
}

class _MutableCalendarEventLayout {
  _MutableCalendarEventLayout({required this.event, required this.lane});

  final CalendarEventEntity event;
  final int lane;
  int laneCount = 1;
}

class _ActiveCalendarEvent {
  const _ActiveCalendarEvent({required this.event, required this.lane});

  final CalendarEventEntity event;
  final int lane;
}

class _TimelineHourBlock extends StatelessWidget {
  const _TimelineHourBlock({
    required this.hour,
    required this.currentTime,
    required this.isCurrentHour,
    required this.isFocusedHour,
    required this.onTap,
  });

  final int hour;
  final DateTime currentTime;
  final bool isCurrentHour;
  final bool isFocusedHour;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final top = _hourTop(hour);

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      height: CalendarTimeline.hourHeight,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: CalendarTimeline.leftGutter,
              child: _TimelineHourLabel(
                hour: hour,
                currentTime: currentTime,
                isCurrentHour: isCurrentHour,
                isFocusedHour: isFocusedHour,
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 22),
                child: SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PositionedCalendarEvent extends StatelessWidget {
  const _PositionedCalendarEvent({required this.layout, required this.onTap});

  final _CalendarEventLayout layout;
  final ValueChanged<CalendarEventEntity> onTap;

  @override
  Widget build(BuildContext context) {
    final event = layout.event;
    final top = _eventTop(event);
    final height = _eventHeight(event);

    return Positioned(
      top: top,
      left: CalendarTimeline.leftGutter,
      right: 22,
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final laneGap = layout.laneCount > 1 ? 8.0 : 0.0;
          final availableWidth =
              constraints.maxWidth - (laneGap * (layout.laneCount - 1));
          final laneWidth = availableWidth / layout.laneCount;
          final laneLeft = layout.lane * (laneWidth + laneGap);

          return Stack(
            children: [
              Positioned(
                left: laneLeft,
                width: laneWidth,
                top: 0,
                bottom: 0,
                child: CalendarEventCard(
                  event: event,
                  compact: height < 72,
                  onTap: () => onTap(event),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TimelineHourLabel extends StatelessWidget {
  const _TimelineHourLabel({
    required this.hour,
    required this.currentTime,
    required this.isCurrentHour,
    required this.isFocusedHour,
  });

  final int hour;
  final DateTime currentTime;
  final bool isCurrentHour;
  final bool isFocusedHour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final color = isFocusedHour
        ? AppColors.textPrimary
        : AppColors.textPrimary.withValues(alpha: 0.34);

    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            period,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '$displayHour',
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              height: 0.95,
            ),
          ),
          if (isCurrentHour) ...[
            const SizedBox(height: 5),
            Text(
              _formatTime(currentTime),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.colorPrimaryDark,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
          if (isFocusedHour) ...[
            const SizedBox(height: 9),
            Container(
              width: 22,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.colorPrimaryDark,
                borderRadius: BorderRadius.circular(AppColors.radiusFull),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineEmptyHourCard extends StatelessWidget {
  const _TimelineEmptyHourCard({required this.hour});

  final int hour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      top: _hourTop(hour) + 22,
      left: CalendarTimeline.leftGutter,
      right: 22,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.colorNeutral100.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.colorNeutral200),
        ),
        child: Text(
          'Nessun evento in questa fascia oraria',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.48),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

double _hourTop(int hour) {
  return (hour - CalendarTimeline.startHour) * CalendarTimeline.hourHeight;
}

double _timeTop(DateTime date) {
  final visibleHour = _visibleHour(date.hour);
  final minutes = visibleHour == date.hour ? date.minute : 0;
  return _hourTop(visibleHour) + (minutes / 60) * CalendarTimeline.hourHeight;
}

double _eventTop(CalendarEventEntity event) {
  return _timeTop(event.startDate) + 8;
}

double _eventHeight(CalendarEventEntity event) {
  final durationMinutes = event.endDate.difference(event.startDate).inMinutes;
  final proportionalHeight =
      (durationMinutes / 60) * CalendarTimeline.hourHeight;

  return math.max(62, proportionalHeight - 14);
}

int _visibleHour(int hour) {
  if (hour < CalendarTimeline.startHour) return CalendarTimeline.startHour;
  if (hour > CalendarTimeline.endHour) return CalendarTimeline.endHour;
  return hour;
}

String _formatTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
