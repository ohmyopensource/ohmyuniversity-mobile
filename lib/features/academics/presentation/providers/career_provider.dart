import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/academic_course_type.dart';
import '../../domain/entities/academic_exam_course_entity.dart';
import '../../domain/entities/academic_statistics_entity.dart';
import '../../domain/services/academic_statistics_calculator.dart';
import 'career_data_providers.dart';

enum CareerExamFilter { all, passed, pending }

class CareerState {
  const CareerState({
    required this.courses,
    this.examFilter = CareerExamFilter.all,
    this.yearFilter = 'all',
    this.simulatedGrades = const {},
    this.officialStatistics = AcademicStatisticsEntity.empty,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<AcademicExamCourseEntity> courses;
  final CareerExamFilter examFilter;
  final String yearFilter;
  final Map<String, String> simulatedGrades;
  final AcademicStatisticsEntity officialStatistics;
  final bool isLoading;
  final String? errorMessage;

  bool get hasSimulation => simulatedGrades.isNotEmpty;

  List<int> get availableYears {
    final years =
        courses
            .where(
              (course) => course.courseType == AcademicCourseType.mandatory,
            )
            .map((course) => course.year)
            .toSet()
            .toList()
          ..sort();
    return years;
  }

  List<AcademicExamCourseEntity> get visibleCourses {
    return courses
        .where((course) {
          final matchesStatus = switch (examFilter) {
            CareerExamFilter.all => true,
            CareerExamFilter.passed => course.passed,
            CareerExamFilter.pending => !course.passed,
          };
          if (!matchesStatus) return false;

          return switch (yearFilter) {
            'all' => true,
            'elective' => course.courseType == AcademicCourseType.elective,
            _ =>
              course.courseType == AcademicCourseType.mandatory &&
                  course.year == int.tryParse(yearFilter),
          };
        })
        .toList(growable: false);
  }

  CareerState copyWith({
    CareerExamFilter? examFilter,
    String? yearFilter,
    Map<String, String>? simulatedGrades,
    AcademicStatisticsEntity? officialStatistics,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CareerState(
      courses: courses,
      examFilter: examFilter ?? this.examFilter,
      yearFilter: yearFilter ?? this.yearFilter,
      simulatedGrades: simulatedGrades ?? this.simulatedGrades,
      officialStatistics: officialStatistics ?? this.officialStatistics,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final careerProvider = NotifierProvider<CareerController, CareerState>(
  CareerController.new,
);

final careerStatisticsProvider = Provider<AcademicStatisticsEntity>((ref) {
  final state = ref.watch(careerProvider);
  return const AcademicStatisticsCalculator().calculate(
    state.courses,
    simulatedGrades: state.simulatedGrades,
    officialStatistics: state.officialStatistics,
  );
});

class CareerController extends Notifier<CareerState> {
  @override
  CareerState build() {
    final snapshot = ref.watch(careerSnapshotProvider);
    return snapshot.when(
      data: (data) => CareerState(
        courses: data.courses,
        officialStatistics: data.statistics,
      ),
      loading: () => const CareerState(courses: [], isLoading: true),
      error: (error, _) =>
          CareerState(courses: const [], errorMessage: error.toString()),
    );
  }

  void reload() => ref.invalidate(careerSnapshotProvider);

  void setExamFilter(CareerExamFilter filter) {
    if (filter == state.examFilter) return;
    state = state.copyWith(examFilter: filter);
  }

  void setYearFilter(String filter) {
    final isValid =
        filter == 'all' ||
        filter == 'elective' ||
        state.availableYears.contains(int.tryParse(filter));
    if (!isValid || filter == state.yearFilter) return;
    state = state.copyWith(yearFilter: filter);
  }

  void setSimulatedGrade(String courseId, String? grade) {
    final course = state.courses
        .where((candidate) => candidate.id == courseId)
        .firstOrNull;
    if (course == null || course.passed) return;

    final nextGrades = Map<String, String>.from(state.simulatedGrades);
    if (grade == null) {
      nextGrades.remove(courseId);
    } else {
      final numericGrade = int.tryParse(grade.replaceAll('L', ''));
      if (numericGrade == null || numericGrade < 18 || numericGrade > 30) {
        return;
      }
      nextGrades[courseId] = grade;
    }
    state = state.copyWith(simulatedGrades: nextGrades);
  }

  void clearSimulations() {
    if (!state.hasSimulation) return;
    state = state.copyWith(simulatedGrades: const {});
  }
}

extension CareerExamFilterLabel on CareerExamFilter {
  String get label => switch (this) {
    CareerExamFilter.all => 'Tutti',
    CareerExamFilter.passed => 'Superati',
    CareerExamFilter.pending => 'Da sostenere',
  };
}
