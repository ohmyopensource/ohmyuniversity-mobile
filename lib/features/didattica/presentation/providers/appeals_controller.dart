import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mocks/exam_bookings_mock_data.dart';
import '../../domain/entities/exam_booking_entity.dart';

enum AppealsFilter { all, available, booked }

class AppealsState {
  const AppealsState({
    this.searchQuery = '',
    this.filter = AppealsFilter.all,
    this.bookedIds = const {},
  });

  final String searchQuery;
  final AppealsFilter filter;
  final Set<String> bookedIds;

  AppealsState copyWith({
    String? searchQuery,
    AppealsFilter? filter,
    Set<String>? bookedIds,
  }) {
    return AppealsState(
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
      bookedIds: bookedIds ?? this.bookedIds,
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
}

final appealsControllerProvider =
    NotifierProvider<AppealsController, AppealsState>(AppealsController.new);

final allExamBookingsProvider = Provider<List<ExamBookingEntity>>((ref) {
  final state = ref.watch(appealsControllerProvider);
  return examBookingsMockData
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
