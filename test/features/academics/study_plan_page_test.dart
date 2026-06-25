import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/academic_course_type.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/academic_exam_course_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/academic_statistics_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/career_snapshot_entity.dart';
import 'package:ohmyuniversity/features/academics/presentation/pages/study_plan_page.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/career_data_providers.dart';

void main() {
  testWidgets('study plan groups courses by year and filters pending courses', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          careerSnapshotProvider.overrideWith(
            (ref) async => const CareerSnapshotEntity(
              courses: _courses,
              statistics: AcademicStatisticsEntity.empty,
            ),
          ),
        ],
        child: const MaterialApp(home: StudyPlanPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Piano di studio'), findsOneWidget);
    expect(find.text('Anno 1'), findsOneWidget);
    expect(find.text('Anno 2'), findsOneWidget);
    expect(find.text('Analisi matematica'), findsOneWidget);
    expect(find.text('Fisica'), findsOneWidget);
    expect(find.text('Laboratorio mobile'), findsOneWidget);

    await tester.tap(find.text('Da sostenere'));
    await tester.pumpAndSettle();

    expect(find.text('Analisi matematica'), findsNothing);
    expect(find.text('Fisica'), findsOneWidget);
    expect(find.text('Laboratorio mobile'), findsOneWidget);
  });

  testWidgets('study plan elective filter shows empty state when needed', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          careerSnapshotProvider.overrideWith(
            (ref) async => const CareerSnapshotEntity(
              courses: [_mandatoryCourse],
              statistics: AcademicStatisticsEntity.empty,
            ),
          ),
        ],
        child: const MaterialApp(home: StudyPlanPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('A scelta'));
    await tester.pumpAndSettle();

    expect(find.text('Nessun esame trovato'), findsOneWidget);
    expect(find.textContaining('a scelta'), findsOneWidget);
  });
}

const _mandatoryCourse = AcademicExamCourseEntity(
  id: 'math',
  year: 1,
  semester: 1,
  name: 'Analisi matematica',
  code: 'MAT01',
  credits: 9,
  passed: true,
  grade: '28',
);

const _courses = [
  _mandatoryCourse,
  AcademicExamCourseEntity(
    id: 'physics',
    year: 1,
    semester: 2,
    name: 'Fisica',
    code: 'FIS01',
    credits: 6,
    passed: false,
  ),
  AcademicExamCourseEntity(
    id: 'mobile',
    year: 2,
    semester: 1,
    name: 'Laboratorio mobile',
    code: 'INF02',
    credits: 6,
    passed: false,
    courseType: AcademicCourseType.elective,
  ),
];
