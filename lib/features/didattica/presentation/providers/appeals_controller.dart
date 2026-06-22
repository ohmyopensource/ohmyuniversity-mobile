import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/exam_booking_entity.dart';
import '../../domain/entities/exam_booking_history_entity.dart';
import 'career_data_providers.dart';

enum AppealsFilter { all, available, booked }

class AppealsState {
  const AppealsState({
    this.searchQuery = '',
    this.filter = AppealsFilter.all,
    this.bookedIds = const {},
    this.examBookings = const [],
    this.isLoading = false,
    this.loaded = false,
    this.error,
    this.bookingHistory = const [],
    this.isHistoryLoading = false,
    this.historyLoaded = false,
    this.historyError,
  });

  final String searchQuery;
  final AppealsFilter filter;
  final Set<String> bookedIds;
  final List<ExamBookingEntity> examBookings;
  final bool isLoading;
  final bool loaded;
  final String? error;
  final List<ExamBookingHistoryEntity> bookingHistory;
  final bool isHistoryLoading;
  final bool historyLoaded;
  final String? historyError;

  AppealsState copyWith({
    String? searchQuery,
    AppealsFilter? filter,
    Set<String>? bookedIds,
    List<ExamBookingEntity>? examBookings,
    bool? isLoading,
    bool? loaded,
    String? error,
    bool clearError = false,
    List<ExamBookingHistoryEntity>? bookingHistory,
    bool? isHistoryLoading,
    bool? historyLoaded,
    String? historyError,
    bool clearHistoryError = false,
  }) {
    return AppealsState(
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
      bookedIds: bookedIds ?? this.bookedIds,
      examBookings: examBookings ?? this.examBookings,
      isLoading: isLoading ?? this.isLoading,
      loaded: loaded ?? this.loaded,
      error: clearError ? null : error ?? this.error,
      bookingHistory: bookingHistory ?? this.bookingHistory,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      historyLoaded: historyLoaded ?? this.historyLoaded,
      historyError: clearHistoryError
          ? null
          : historyError ?? this.historyError,
    );
  }
}

class AppealsController extends Notifier<AppealsState> {
  @override
  AppealsState build() => const AppealsState();

  void search(String value) => state = state.copyWith(searchQuery: value);

  void setFilter(AppealsFilter value) => state = state.copyWith(filter: value);

  void book(String examId) {
    state = state.copyWith(bookedIds: {...state.bookedIds, examId});
  }

  Future<void> loadAvailableAppeals() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final session = await ref.read(authRepositoryProvider).currentSession();
      final degreeCourseId = session?.activeProfile?.degreeCourseId;
      if (degreeCourseId == null) {
        state = state.copyWith(
          isLoading: false,
          loaded: true,
          error: 'Profilo carriera non disponibile.',
        );
        return;
      }

      final bookingHistory =
          await ref.read(getExamBookingHistoryUseCaseProvider).cached();
      if (bookingHistory == null) {
        state = state.copyWith(
          isLoading: false,
          loaded: true,
          error:
              'Appelli non disponibili. Effettua nuovamente l’accesso per aggiornare lo storico.',
        );
        return;
      }

      final exams = await ref
          .read(getAvailableExamBookingsUseCaseProvider)
          .call(
            degreeCourseId: degreeCourseId,
            bookingHistory: bookingHistory,
          );
      state = state.copyWith(
        examBookings: exams,
        bookingHistory: bookingHistory,
        isLoading: false,
        loaded: true,
        historyLoaded: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        loaded: true,
        error: error.toString(),
      );
    }
  }

  Future<void> loadBookingHistory() async {
    state = state.copyWith(isHistoryLoading: true, clearHistoryError: true);
    try {
      final bookings = await ref
          .read(getExamBookingHistoryUseCaseProvider)
          .cached();
      if (bookings == null) {
        state = state.copyWith(
          isHistoryLoading: false,
          historyLoaded: false,
          historyError:
              'Storico non disponibile. Effettua nuovamente l’accesso.',
        );
        return;
      }
      state = state.copyWith(
        bookingHistory: bookings,
        isHistoryLoading: false,
        historyLoaded: true,
      );
    } catch (error) {
      state = state.copyWith(
        isHistoryLoading: false,
        historyLoaded: false,
        historyError: error.toString(),
      );
    }
  }
}

final appealsControllerProvider =
    NotifierProvider<AppealsController, AppealsState>(AppealsController.new);

final allExamBookingsProvider = Provider<List<ExamBookingEntity>>((ref) {
  final state = ref.watch(appealsControllerProvider);
  return state.examBookings
      .map(
        (exam) => state.bookedIds.contains(exam.id)
            ? exam.copyWith(status: ExamBookingStatus.booked)
            : exam,
      )
      .toList(growable: false);
});

final visibleExamBookingsProvider = Provider<List<ExamBookingEntity>>((ref) {
  final state = ref.watch(appealsControllerProvider);
  final query = state.searchQuery.trim().toLowerCase();

  return ref
      .watch(allExamBookingsProvider)
      .where((exam) {
        final matchesFilter = switch (state.filter) {
          AppealsFilter.all => true,
          AppealsFilter.available =>
            exam.status == ExamBookingStatus.open ||
                exam.status == ExamBookingStatus.closing,
          AppealsFilter.booked => exam.status == ExamBookingStatus.booked,
        };
        final matchesSearch =
            query.isEmpty ||
            exam.courseName.toLowerCase().contains(query) ||
            exam.professor.toLowerCase().contains(query) ||
            exam.location.toLowerCase().contains(query);
        return matchesFilter && matchesSearch;
      })
      .toList(growable: false);
});
