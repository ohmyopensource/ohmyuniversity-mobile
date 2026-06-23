import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/calendario/data/datasources/calendar_mock_datasource.dart';
import 'package:ohmyuniversity/features/calendario/data/datasources/calendar_remote_datasource.dart';
import 'package:ohmyuniversity/features/calendario/data/repositories/calendar_repository_impl.dart';
import 'package:ohmyuniversity/features/calendario/domain/entities/calendar_event_entity.dart';
import 'package:ohmyuniversity/features/calendario/domain/entities/calendar_event_type.dart';

void main() {
  test('performs calendar CRUD operations through the repository', () async {
    final repository = CalendarRepositoryImpl(
      CalendarRemoteDataSource(Dio()),
      CalendarMockDataSource(),
      useMock: true,
    );
    final event = CalendarEventEntity(
      id: 'manual-event',
      title: 'Studio individuale',
      description: 'Ripasso prima dell appello',
      startDate: DateTime(2026, 6, 28, 15),
      endDate: DateTime(2026, 6, 28, 17),
      type: CalendarEventType.event,
      location: 'Biblioteca',
    );

    await repository.createEvent(event);
    var events = await repository.getEvents(
      startDate: DateTime(2026, 6, 28),
      endDate: DateTime(2026, 6, 29),
    );
    expect(events.map((item) => item.id), contains('manual-event'));

    await repository.updateEvent(
      CalendarEventEntity(
        id: event.id,
        title: 'Studio con gruppo',
        description: event.description,
        startDate: event.startDate,
        endDate: event.endDate,
        type: event.type,
        location: event.location,
      ),
    );
    events = await repository.getEvents(
      startDate: DateTime(2026, 6, 28),
      endDate: DateTime(2026, 6, 29),
    );
    expect(
      events.firstWhere((item) => item.id == 'manual-event').title,
      'Studio con gruppo',
    );

    await repository.deleteEvent('manual-event');
    events = await repository.getEvents(
      startDate: DateTime(2026, 6, 28),
      endDate: DateTime(2026, 6, 29),
    );
    expect(events.map((item) => item.id), isNot(contains('manual-event')));
  });
}
