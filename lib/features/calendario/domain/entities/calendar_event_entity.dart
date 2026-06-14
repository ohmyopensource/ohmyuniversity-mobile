import 'calendar_event_type.dart';

class CalendarEventEntity {
  const CalendarEventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.location,
    this.isAllDay = false,
  });

  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final CalendarEventType type;
  final String location;
  final bool isAllDay;
}
