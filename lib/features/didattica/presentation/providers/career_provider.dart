import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/didattica_course_type.dart';
import '../../domain/entities/didattica_exam_course_entity.dart';
import '../../domain/entities/didattica_statistics_entity.dart';
import '../../domain/services/didattica_statistics_calculator.dart';
import 'exam_courses_provider.dart';

enum CareerExamFilter { all, passed, pending }

class CareerState {
  const CareerState({
    required this.courses,
    this.examFilter = CareerExamFilter.all,
    this.yearFilter = 'all',
    this.simulatedGrades = const {},
  });

  final List<DidatticaExamCourseEntity> courses;
  final CareerExamFilter examFilter;
  final String yearFilter;
  final Map<String, String> simulatedGrades;

  bool get hasSimulation => simulatedGrades.isNotEmpty;

  List<int> get availableYears {
    final years =
        courses
            .where(
              (course) => course.courseType == DidatticaCourseType.mandatory,
            )
            .map((course) => course.year)
            .toSet()
            .toList()
          ..sort();
    return years;
  }

  List<DidatticaExamCourseEntity> get visibleCourses {
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
            'elective' => course.courseType == DidatticaCourseType.elective,
            _ =>
              course.courseType == DidatticaCourseType.mandatory &&
                  course.year == int.tryParse(yearFilter),
          };
        })
        .toList(growable: false);
  }

  CareerState copyWith({
    CareerExamFilter? examFilter,
    String? yearFilter,
    Map<String, String>? simulatedGrades,
  }) {
    return CareerState(
      courses: courses,
      examFilter: examFilter ?? this.examFilter,
      yearFilter: yearFilter ?? this.yearFilter,
      simulatedGrades: simulatedGrades ?? this.simulatedGrades,
    );
  }
}

final careerProvider = NotifierProvider<CareerController, CareerState>(
  CareerController.new,
);

final careerStatisticsProvider = Provider<DidatticaStatisticsEntity>((ref) {
  final state = ref.watch(careerProvider);
  return const DidatticaStatisticsCalculator().calculate(
    state.courses,
    simulatedGrades: state.simulatedGrades,
  );
});

class CareerController extends Notifier<CareerState> {
  @override
  CareerState build() {
    return CareerState(courses: ref.watch(didatticaExamCoursesProvider));
  }

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
