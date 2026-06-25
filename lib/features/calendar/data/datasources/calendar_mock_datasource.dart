import '../../../../shared/mocks/app_mock_data.dart';
import '../../domain/entities/calendar_event_type.dart';
import '../models/calendar_event_model.dart';

class CalendarMockDataSource {
  CalendarMockDataSource()
    : _events = AppMockData.calendarEvents.map(_toCalendarEventModel).toList();

  final List<CalendarEventModel> _events;

  Future<List<CalendarEventModel>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _events
        .where((event) {
          final startsBeforeEnd =
              endDate == null || event.startDate.isBefore(endDate);
          final endsAfterStart =
              startDate == null || event.endDate.isAfter(startDate);

          return startsBeforeEnd && endsAfterStart;
        })
        .toList(growable: false);
  }

  Future<CalendarEventModel> createEvent(CalendarEventModel event) async {
    _events.add(event);
    return event;
  }

  Future<CalendarEventModel> updateEvent(CalendarEventModel event) async {
    final index = _events.indexWhere((item) => item.id == event.id);
    if (index == -1) {
      _events.add(event);
      return event;
    }

    _events[index] = event;
    return event;
  }

  Future<void> deleteEvent(String eventId) async {
    _events.removeWhere((event) => event.id == eventId);
  }
}

CalendarEventModel _toCalendarEventModel(MockCalendarEventData event) {
  return CalendarEventModel(
    id: event.id,
    title: event.title,
    description: event.description,
    startDate: event.startDate,
    endDate: event.endDate,
    type: CalendarEventType.values.byName(event.type),
    location: event.location,
    isAllDay: event.isAllDay,
  );
}
