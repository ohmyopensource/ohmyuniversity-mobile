import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_type.dart';
import 'package:ohmyuniversity/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:ohmyuniversity/features/calendar/domain/usecases/create_calendar_event_usecase.dart';
import 'package:ohmyuniversity/features/calendar/domain/usecases/delete_calendar_event_usecase.dart';
import 'package:ohmyuniversity/features/calendar/domain/usecases/get_calendar_events_usecase.dart';
import 'package:ohmyuniversity/features/calendar/domain/usecases/update_calendar_event_usecase.dart';

void main() {
  test('calendar use cases delegate to the repository', () async {
    final repository = _CalendarRepositoryFake();
    final created = await CreateCalendarEventUseCase(repository).call(_event);
    final updated = await UpdateCalendarEventUseCase(repository).call(
      CalendarEventEntity(
        id: _event.id,
        title: 'Aggiornato',
        description: _event.description,
        startDate: _event.startDate,
        endDate: _event.endDate,
        type: _event.type,
        location: _event.location,
      ),
    );
    final events = await GetCalendarEventsUseCase(repository).call(
      GetCalendarEventsParams(
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 30),
      ),
    );
    await DeleteCalendarEventUseCase(repository).call(_event.id);

    expect(created.id, _event.id);
    expect(updated.title, 'Aggiornato');
    expect(events, hasLength(1));
    expect(repository.deletedId, _event.id);
    expect(repository.lastStartDate, DateTime(2026, 6, 1));
  });
}

final _event = CalendarEventEntity(
  id: 'event-1',
  title: 'Esame',
  description: 'Prova scritta',
  startDate: DateTime(2026, 6, 25, 9),
  endDate: DateTime(2026, 6, 25, 11),
  type: CalendarEventType.exam,
  location: 'Aula 1',
);

class _CalendarRepositoryFake implements CalendarRepository {
  DateTime? lastStartDate;
  String? deletedId;

  @override
  Future<CalendarEventEntity> createEvent(CalendarEventEntity event) async {
    return event;
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    deletedId = eventId;
  }

  @override
  Future<List<CalendarEventEntity>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    lastStartDate = startDate;
    return [_event];
  }

  @override
  Future<CalendarEventEntity> updateEvent(CalendarEventEntity event) async {
    return event;
  }
}
