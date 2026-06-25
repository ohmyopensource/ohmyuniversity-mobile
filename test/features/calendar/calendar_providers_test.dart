import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_type.dart';
import 'package:ohmyuniversity/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:ohmyuniversity/features/calendar/presentation/providers/calendar_providers.dart';

void main() {
  ProviderContainer container() {
    final container = ProviderContainer(
      overrides: [
        calendarRepositoryProvider.overrideWithValue(_CalendarRepositoryFake()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('calendar selection controllers normalize date, hour and view', () {
    final ref = container();

    ref
        .read(selectedCalendarDateProvider.notifier)
        .selectDate(DateTime(2026, 6, 25, 14, 30));
    ref.read(selectedCalendarHourProvider.notifier).selectHour(9);
    ref.read(selectedCalendarViewProvider.notifier).setView(CalendarView.year);

    expect(ref.read(selectedCalendarDateProvider), DateTime(2026, 6, 25));
    expect(ref.read(selectedCalendarHourProvider), 9);
    expect(ref.read(selectedCalendarViewProvider), CalendarView.year);

    ref.read(selectedCalendarHourProvider.notifier).clearSelection();
    ref.read(selectedCalendarViewProvider.notifier).goBack();

    expect(ref.read(selectedCalendarHourProvider), isNull);
    expect(ref.read(selectedCalendarViewProvider), CalendarView.year);
  });

  test('calendar events provider requests the selected day range', () async {
    final ref = container();
    final repository = ref.read(calendarRepositoryProvider) as _CalendarRepositoryFake;

    ref
        .read(selectedCalendarDateProvider.notifier)
        .selectDate(DateTime(2026, 6, 25, 18));
    ref.read(selectedCalendarViewProvider.notifier).setView(CalendarView.day);

    final events = await ref.read(calendarEventsProvider.future);

    expect(events.single.id, 'event-1');
    expect(repository.lastStartDate, DateTime(2026, 6, 25));
    expect(repository.lastEndDate, DateTime(2026, 6, 26));
  });

  test('calendar events provider requests month and year ranges', () async {
    final ref = container();
    final repository = ref.read(calendarRepositoryProvider) as _CalendarRepositoryFake;

    ref
        .read(selectedCalendarDateProvider.notifier)
        .selectDate(DateTime(2026, 6, 15));
    ref.read(selectedCalendarViewProvider.notifier).setView(CalendarView.month);
    await ref.read(calendarEventsProvider.future);

    expect(repository.lastStartDate, DateTime(2026, 6));
    expect(repository.lastEndDate, DateTime(2026, 7));

    ref.invalidate(calendarEventsProvider);
    ref.read(selectedCalendarViewProvider.notifier).setView(CalendarView.year);
    await ref.read(calendarEventsProvider.future);

    expect(repository.lastStartDate, DateTime(2026));
    expect(repository.lastEndDate, DateTime(2027));
  });
}

class _CalendarRepositoryFake implements CalendarRepository {
  DateTime? lastStartDate;
  DateTime? lastEndDate;

  @override
  Future<CalendarEventEntity> createEvent(CalendarEventEntity event) async {
    return event;
  }

  @override
  Future<void> deleteEvent(String eventId) async {}

  @override
  Future<List<CalendarEventEntity>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    lastStartDate = startDate;
    lastEndDate = endDate;
    return [_event];
  }

  @override
  Future<CalendarEventEntity> updateEvent(CalendarEventEntity event) async {
    return event;
  }
}

final _event = CalendarEventEntity(
  id: 'event-1',
  title: 'Lezione',
  description: 'Aula A',
  startDate: DateTime(2026, 6, 25, 9),
  endDate: DateTime(2026, 6, 25, 11),
  type: CalendarEventType.event,
  location: 'Aula A',
);
