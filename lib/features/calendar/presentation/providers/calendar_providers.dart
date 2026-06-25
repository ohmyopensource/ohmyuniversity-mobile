import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/providers/network_providers.dart';
import '../../data/datasources/calendar_mock_datasource.dart';
import '../../data/datasources/calendar_remote_datasource.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../domain/entities/calendar_event_entity.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/usecases/create_calendar_event_usecase.dart';
import '../../domain/usecases/delete_calendar_event_usecase.dart';
import '../../domain/usecases/get_calendar_events_usecase.dart';
import '../../domain/usecases/update_calendar_event_usecase.dart';

enum CalendarView { day, month, year }

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

final selectedCalendarViewProvider =
    NotifierProvider<CalendarViewController, CalendarView>(
      CalendarViewController.new,
    );

class CalendarViewController extends Notifier<CalendarView> {
  @override
  CalendarView build() => CalendarView.day;

  void setView(CalendarView view) => state = view;

  void goBack() {
    state = switch (state) {
      CalendarView.day => CalendarView.month,
      CalendarView.month => CalendarView.year,
      CalendarView.year => CalendarView.year,
    };
  }
}

final calendarMockDataSourceProvider = Provider<CalendarMockDataSource>((ref) {
  return CalendarMockDataSource();
});

final calendarRemoteDataSourceProvider = Provider<CalendarRemoteDataSource>((
  ref,
) {
  return CalendarRemoteDataSource(ref.watch(apiDioProvider));
});

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepositoryImpl(
    ref.watch(calendarRemoteDataSourceProvider),
    ref.watch(calendarMockDataSourceProvider),
    useMock: const bool.fromEnvironment('USE_MOCK_CALENDAR'),
  );
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
  final selectedView = ref.watch(selectedCalendarViewProvider);
  final (startDate, endDate) = switch (selectedView) {
    CalendarView.day => (
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1),
    ),
    CalendarView.month => (
      DateTime(selectedDate.year, selectedDate.month),
      DateTime(selectedDate.year, selectedDate.month + 1),
    ),
    CalendarView.year => (
      DateTime(selectedDate.year),
      DateTime(selectedDate.year + 1),
    ),
  };

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
