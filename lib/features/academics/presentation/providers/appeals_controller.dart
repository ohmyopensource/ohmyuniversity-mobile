import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/academic_exam_course_entity.dart';
import '../../domain/entities/exam_booking_entity.dart';
import '../../domain/entities/exam_booking_history_entity.dart';
import 'career_data_providers.dart';
import 'career_provider.dart';

enum AppealsFilter { all, booked, available, recommended }

class RecommendedExamBooking {
  const RecommendedExamBooking({required this.course, required this.appeal});

  final AcademicExamCourseEntity course;
  final ExamBookingEntity? appeal;
}

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

      final bookingHistory = await ref
          .read(getExamBookingHistoryUseCaseProvider)
          .cached();
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
          .call(degreeCourseId: degreeCourseId, bookingHistory: bookingHistory);
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
  final exams = ref.watch(allExamBookingsProvider);

  final filteredExams = switch (state.filter) {
    AppealsFilter.all => exams,
    AppealsFilter.booked =>
      exams
          .where((exam) => exam.status == ExamBookingStatus.booked)
          .toList(growable: false),
    AppealsFilter.available =>
      exams
          .where(
            (exam) =>
                exam.status == ExamBookingStatus.open ||
                exam.status == ExamBookingStatus.closing,
          )
          .toList(growable: false),
    AppealsFilter.recommended => const <ExamBookingEntity>[],
  };

  return filteredExams
      .where((exam) {
        final matchesSearch =
            query.isEmpty ||
            exam.courseName.toLowerCase().contains(query) ||
            exam.professor.toLowerCase().contains(query) ||
            exam.location.toLowerCase().contains(query);
        return matchesSearch;
      })
      .toList(growable: false);
});

final suggestedExamsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) {
  return ref.watch(academicRepositoryProvider).getSuggestedExams();
});

final recommendedExamBookingsProvider = Provider<List<RecommendedExamBooking>>((
  ref,
) {
  final state = ref.watch(appealsControllerProvider);
  final career = ref.watch(careerProvider);
  final exams = ref.watch(allExamBookingsProvider);
  final suggested = ref
      .watch(suggestedExamsProvider)
      .maybeWhen(
        data: (items) => items,
        orElse: () => const <Map<String, dynamic>>[],
      );

  final query = state.searchQuery.trim().toLowerCase();

  final examsByCode = <String, List<ExamBookingEntity>>{};
  final examsByName = <String, List<ExamBookingEntity>>{};

  for (final exam in exams) {
    if (exam.courseAcronym.trim().isNotEmpty) {
      examsByCode
          .putIfAbsent(_normalize(exam.courseAcronym), () => [])
          .add(exam);
    }
    examsByName.putIfAbsent(_normalize(exam.courseName), () => []).add(exam);
  }

  final suggestedKeys = suggested
      .map((item) {
        final code = item['adCod'] ?? item['codice'] ?? item['code'];
        final name = item['adDes'] ?? item['nome'] ?? item['name'];
        return _normalize((code ?? name ?? '').toString());
      })
      .where((value) => value.isNotEmpty)
      .toList(growable: false);

  final pendingCourses = career.courses.where((course) {
    if (course.passed) return false;

    return query.isEmpty ||
        course.name.toLowerCase().contains(query) ||
        course.code.toLowerCase().contains(query);
  }).toList();

  if (suggestedKeys.isNotEmpty) {
    pendingCourses.sort((first, second) {
      final firstIndex = _suggestedIndex(first, suggestedKeys);
      final secondIndex = _suggestedIndex(second, suggestedKeys);

      if (firstIndex != secondIndex) return firstIndex.compareTo(secondIndex);
      return _comparePendingCourses(first, second);
    });
  } else {
    pendingCourses.sort(_comparePendingCourses);
  }

  return pendingCourses
      .map((course) {
        final matchingExams =
            examsByCode[_normalize(course.code)] ??
            examsByName[_normalize(course.name)] ??
            const <ExamBookingEntity>[];

        return RecommendedExamBooking(
          course: course,
          appeal: _bestExamBooking(matchingExams),
        );
      })
      .toList(growable: false);
});

int _suggestedIndex(
  AcademicExamCourseEntity course,
  List<String> suggestedKeys,
) {
  final code = _normalize(course.code);
  final name = _normalize(course.name);

  final index = suggestedKeys.indexWhere((key) => key == code || key == name);

  return index == -1 ? 9999 : index;
}

int _comparePendingCourses(
  AcademicExamCourseEntity first,
  AcademicExamCourseEntity second,
) {
  final creditsComparison = first.credits.compareTo(second.credits);
  if (creditsComparison != 0) return creditsComparison;
  final yearComparison = first.year.compareTo(second.year);
  if (yearComparison != 0) return yearComparison;
  final semesterComparison = first.semester.compareTo(second.semester);
  if (semesterComparison != 0) return semesterComparison;
  return first.name.compareTo(second.name);
}

ExamBookingEntity? _bestExamBooking(List<ExamBookingEntity> exams) {
  if (exams.isEmpty) return null;
  final sorted = [...exams]
    ..sort((first, second) {
      final priorityComparison = _examPriority(
        first,
      ).compareTo(_examPriority(second));
      if (priorityComparison != 0) return priorityComparison;
      return first.date.compareTo(second.date);
    });
  return sorted.first;
}

int _examPriority(ExamBookingEntity exam) {
  return switch (exam.status) {
    ExamBookingStatus.open || ExamBookingStatus.closing => 0,
    ExamBookingStatus.booked => 1,
    ExamBookingStatus.closed => 2,
  };
}

String _normalize(String value) {
  return value.trim().toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
}
