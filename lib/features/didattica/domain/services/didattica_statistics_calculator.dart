import '../entities/average_trend_point_entity.dart';
import '../entities/didattica_exam_course_entity.dart';
import '../entities/didattica_statistics_entity.dart';

class DidatticaStatisticsCalculator {
  const DidatticaStatisticsCalculator();

  static const _defaultTotalCredits = 180;
  static const _defaultMaxGraduationBase = 110.0;

  DidatticaStatisticsEntity calculate(
    List<DidatticaExamCourseEntity> courses, {
    Map<String, String> simulatedGrades = const {},
  }) {
    final passedCourses = courses.where((course) => course.passed).toList();
    final gradeRecords = _buildGradeRecords(courses, simulatedGrades);
    final acquiredCredits = passedCourses.fold<int>(
      0,
      (total, course) => total + course.credits,
    );
    final arithmeticAverage = _calculateArithmeticAverage(gradeRecords);
    final weightedAverage = _calculateWeightedAverage(gradeRecords);
    final graduationBase = _calculateGraduationBase(weightedAverage);

    return DidatticaStatisticsEntity(
      arithmeticAverage: arithmeticAverage,
      weightedAverage: weightedAverage,
      acquiredCredits: acquiredCredits,
      totalCredits: _defaultTotalCredits,
      graduationBase: graduationBase,
      projectedGraduationScore: graduationBase,
      honorsCount: passedCourses
          .where((course) => course.grade?.trim().toUpperCase() == '30L')
          .length,
      gradeHistory: _calculateGradeHistory(gradeRecords),
      averageTrend: _calculateAverageTrend(gradeRecords),
      hasSimulation: gradeRecords.any((record) => record.isSimulated),
    );
  }

  List<_GradeRecord> _buildGradeRecords(
    List<DidatticaExamCourseEntity> courses,
    Map<String, String> simulatedGrades,
  ) {
    final records = <_GradeRecord>[];
    var simulationIndex = 0;

    for (final course in courses) {
      final grade = course.passed
          ? _parseGrade(course.grade)
          : _parseGrade(simulatedGrades[course.id]);
      if (grade == null || grade < 18 || grade > 30) continue;

      final isSimulated = !course.passed;
      records.add(
        _GradeRecord(
          value: grade,
          credits: course.credits,
          date: isSimulated
              ? DateTime(2100, 1, ++simulationIndex)
              : course.completedAt ?? DateTime(1900),
          isSimulated: isSimulated,
        ),
      );
    }

    records.sort((first, second) => first.date.compareTo(second.date));
    return records;
  }

  double _calculateArithmeticAverage(List<_GradeRecord> grades) {
    if (grades.isEmpty) return 0;

    final total = grades.fold<double>(0, (sum, grade) => sum + grade.value);

    return _roundToTwoDecimals(total / grades.length);
  }

  double _calculateWeightedAverage(List<_GradeRecord> grades) {
    if (grades.isEmpty) return 0;

    final totalCredits = grades.fold<int>(
      0,
      (sum, grade) => sum + grade.credits,
    );
    if (totalCredits == 0) return 0;

    final weightedTotal = grades.fold<double>(
      0,
      (sum, grade) => sum + (grade.value * grade.credits),
    );

    return _roundToTwoDecimals(weightedTotal / totalCredits);
  }

  double _calculateGraduationBase(double weightedAverage) {
    if (weightedAverage == 0) return 0;

    return _roundToTwoDecimals(
      (weightedAverage / 30) * _defaultMaxGraduationBase,
    );
  }

  List<AverageTrendPointEntity> _calculateAverageTrend(
    List<_GradeRecord> grades,
  ) {
    final points = <AverageTrendPointEntity>[];

    for (var index = 0; index < grades.length; index++) {
      final currentGrades = grades.take(index + 1).toList();
      final currentAverage = _calculateWeightedAverage(currentGrades);
      final grade = grades[index];

      points.add(
        AverageTrendPointEntity(date: grade.date, value: currentAverage),
      );
    }

    return points;
  }

  List<AverageTrendPointEntity> _calculateGradeHistory(
    List<_GradeRecord> grades,
  ) {
    return [
      for (final grade in grades)
        AverageTrendPointEntity(date: grade.date, value: grade.value),
    ];
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

class _GradeRecord {
  const _GradeRecord({
    required this.value,
    required this.credits,
    required this.date,
    required this.isSimulated,
  });

  final double value;
  final int credits;
  final DateTime date;
  final bool isSimulated;
}
