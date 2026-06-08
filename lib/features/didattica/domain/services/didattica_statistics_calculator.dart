import '../entities/average_trend_point_entity.dart';
import '../entities/didattica_exam_course_entity.dart';
import '../entities/didattica_statistics_entity.dart';

class DidatticaStatisticsCalculator {
  const DidatticaStatisticsCalculator();

  static const _defaultTotalCredits = 180;
  static const _defaultMaxGraduationBase = 110.0;

  DidatticaStatisticsEntity calculate(List<DidatticaExamCourseEntity> courses) {
    final passedCourses = courses.where((course) => course.passed).toList();
    final gradedCourses = passedCourses.where(_hasValidGrade).toList();
    final acquiredCredits = passedCourses.fold<int>(
      0,
      (total, course) => total + course.credits,
    );
    final arithmeticAverage = _calculateArithmeticAverage(gradedCourses);
    final weightedAverage = _calculateWeightedAverage(gradedCourses);

    return DidatticaStatisticsEntity(
      arithmeticAverage: arithmeticAverage,
      weightedAverage: weightedAverage,
      acquiredCredits: acquiredCredits,
      totalCredits: _defaultTotalCredits,
      projectedGraduationBase: _calculateGraduationProjection(weightedAverage),
      maxGraduationBase: _defaultMaxGraduationBase,
      averageTrend: _calculateAverageTrend(gradedCourses),
    );
  }

  bool _hasValidGrade(DidatticaExamCourseEntity course) {
    final grade = _parseGrade(course.grade);
    return grade != null && grade >= 18 && grade <= 30;
  }

  double _calculateArithmeticAverage(List<DidatticaExamCourseEntity> courses) {
    if (courses.isEmpty) return 0;

    final total = courses.fold<double>(
      0,
      (sum, course) => sum + _parseGrade(course.grade)!,
    );

    return _roundToTwoDecimals(total / courses.length);
  }

  double _calculateWeightedAverage(List<DidatticaExamCourseEntity> courses) {
    if (courses.isEmpty) return 0;

    final totalCredits = courses.fold<int>(
      0,
      (sum, course) => sum + course.credits,
    );
    if (totalCredits == 0) return 0;

    final weightedTotal = courses.fold<double>(
      0,
      (sum, course) => sum + (_parseGrade(course.grade)! * course.credits),
    );

    return _roundToTwoDecimals(weightedTotal / totalCredits);
  }

  double _calculateGraduationProjection(double weightedAverage) {
    if (weightedAverage == 0) return 0;

    final projected = (weightedAverage / 30) * _defaultMaxGraduationBase;
    return _roundToTwoDecimals(projected);
  }

  List<AverageTrendPointEntity> _calculateAverageTrend(
    List<DidatticaExamCourseEntity> courses,
  ) {
    final sortedCourses = [...courses]
      ..sort((first, second) {
        final firstDate = first.completedAt ?? DateTime(1900);
        final secondDate = second.completedAt ?? DateTime(1900);
        return firstDate.compareTo(secondDate);
      });

    final points = <AverageTrendPointEntity>[];

    for (var index = 0; index < sortedCourses.length; index++) {
      final currentCourses = sortedCourses.take(index + 1).toList();
      final currentAverage = _calculateWeightedAverage(currentCourses);
      final course = sortedCourses[index];

      points.add(
        AverageTrendPointEntity(
          date: course.completedAt ?? DateTime(1900, 1, index + 1),
          value: currentAverage,
        ),
      );
    }

    return points;
  }

  double? _parseGrade(String? grade) {
    if (grade == null) return null;

    final normalized = grade.trim().toUpperCase();
    if (normalized.isEmpty) return null;
    if (normalized == '30L') return 30;

    final numericGrade = int.tryParse(normalized.replaceAll('L', ''));
    if (numericGrade == null) return null;

    return numericGrade.toDouble();
  }

  double _roundToTwoDecimals(double value) {
    return double.parse(value.toStringAsFixed(2));
  }
}
