import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/academics/domain/entities/academic_exam_course_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/services/academic_statistics_calculator.dart';

void main() {
  const calculator = AcademicStatisticsCalculator();
  final courses = [
    AcademicExamCourseEntity(
      id: 'passed-laude',
      year: 1,
      semester: 1,
      name: 'Esame con lode',
      code: 'A',
      credits: 6,
      passed: true,
      grade: '30L',
      completedAt: DateTime(2025, 1, 10),
    ),
    AcademicExamCourseEntity(
      id: 'passed-weighted',
      year: 1,
      semester: 2,
      name: 'Esame pesato',
      code: 'B',
      credits: 12,
      passed: true,
      grade: '24',
      completedAt: DateTime(2025, 6, 10),
    ),
    const AcademicExamCourseEntity(
      id: 'pending',
      year: 2,
      semester: 1,
      name: 'Esame futuro',
      code: 'C',
      credits: 6,
      passed: false,
    ),
  ];

  test('computes real career statistics and keeps projection separate', () {
    final statistics = calculator.calculate(courses);

    expect(statistics.acquiredCredits, 18);
    expect(statistics.arithmeticAverage, 27);
    expect(statistics.weightedAverage, 26);
    expect(statistics.graduationBase, 95.33);
    expect(statistics.projectedGraduationScore, 95.33);
    expect(statistics.honorsCount, 1);
    expect(statistics.gradeHistory, hasLength(2));
    expect(statistics.averageTrend, hasLength(2));
    expect(statistics.hasSimulation, isFalse);
  });

  test('includes valid simulated grades without acquiring their CFU', () {
    final statistics = calculator.calculate(
      courses,
      simulatedGrades: const {'pending': '30'},
    );

    expect(statistics.acquiredCredits, 18);
    expect(statistics.arithmeticAverage, 28);
    expect(statistics.weightedAverage, 27);
    expect(statistics.gradeHistory, hasLength(3));
    expect(statistics.averageTrend, hasLength(3));
    expect(statistics.hasSimulation, isTrue);
  });

  test('ignores malformed simulated grades', () {
    final statistics = calculator.calculate(
      courses,
      simulatedGrades: const {'pending': '17'},
    );

    expect(statistics.weightedAverage, 26);
    expect(statistics.hasSimulation, isFalse);
  });
}
