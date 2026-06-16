import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/calendar_mock_datasource.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../domain/entities/calendar_event_entity.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/usecases/create_calendar_event_usecase.dart';
import '../../domain/usecases/delete_calendar_event_usecase.dart';
import '../../domain/usecases/get_calendar_events_usecase.dart';
import '../../domain/usecases/update_calendar_event_usecase.dart';

enum CalendarView { day, week, month }

final selectedCalendarDateProvider =
    NotifierProvider<CalendarSelectionController, DateTime>(
      CalendarSelectionController.new,
    );

class CalendarSelectionController extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void selectDate(DateTime date) {
    state = DateTime(date.year, date.month, date.day);
  }
}

final selectedCalendarHourProvider =
    NotifierProvider<CalendarHourSelectionController, int?>(
      CalendarHourSelectionController.new,
    );

class CalendarHourSelectionController extends Notifier<int?> {
  @override
  int? build() => null;

  void selectHour(int hour) {
    state = hour;
  }

  void clearSelection() {
    state = null;
  }
}

final calendarClockProvider = StreamProvider.autoDispose<DateTime>((
  ref,
) async* {
  yield DateTime.now();

  while (true) {
    await Future<void>.delayed(const Duration(seconds: 30));
    yield DateTime.now();
  }
});

final selectedCalendarViewProvider = Provider<CalendarView>((ref) {
  return CalendarView.day;
});

final calendarMockDataSourceProvider = Provider<CalendarMockDataSource>((ref) {
  return CalendarMockDataSource();
});

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepositoryImpl(ref.watch(calendarMockDataSourceProvider));
});

final getCalendarEventsUseCaseProvider = Provider<GetCalendarEventsUseCase>((
  ref,
) {
  return GetCalendarEventsUseCase(ref.watch(calendarRepositoryProvider));
});

final createCalendarEventUseCaseProvider = Provider<CreateCalendarEventUseCase>(
  (ref) {
    return CreateCalendarEventUseCase(ref.watch(calendarRepositoryProvider));
  },
);

final updateCalendarEventUseCaseProvider = Provider<UpdateCalendarEventUseCase>(
  (ref) {
    return UpdateCalendarEventUseCase(ref.watch(calendarRepositoryProvider));
  },
);

final deleteCalendarEventUseCaseProvider = Provider<DeleteCalendarEventUseCase>(
  (ref) {
    return DeleteCalendarEventUseCase(ref.watch(calendarRepositoryProvider));
  },
);

final calendarEventsProvider = FutureProvider<List<CalendarEventEntity>>((ref) {
  final selectedDate = ref.watch(selectedCalendarDateProvider);
  final startDate = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
  );
  final endDate = startDate.add(const Duration(days: 1));

  return ref
      .watch(getCalendarEventsUseCaseProvider)
      .call(GetCalendarEventsParams(startDate: startDate, endDate: endDate));
});

final homeCalendarEventsProvider = FutureProvider<List<CalendarEventEntity>>((
  ref,
) {
  final now = ref.watch(calendarClockProvider).value ?? DateTime.now();
  final startDate = DateTime(now.year, now.month, now.day);
  final endDate = startDate.add(const Duration(days: 2));

  return ref
      .watch(getCalendarEventsUseCaseProvider)
      .call(GetCalendarEventsParams(startDate: startDate, endDate: endDate));
});
