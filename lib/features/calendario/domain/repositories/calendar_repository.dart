import '../entities/calendar_event_entity.dart';

abstract class CalendarRepository {
  Future<List<CalendarEventEntity>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<CalendarEventEntity> createEvent(CalendarEventEntity event);

  Future<CalendarEventEntity> updateEvent(CalendarEventEntity event);

  Future<void> deleteEvent(String eventId);
}
