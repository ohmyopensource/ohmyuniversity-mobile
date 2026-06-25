import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/academic_exam_course_entity.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/exam_courses_provider.dart';
import 'package:ohmyuniversity/features/academics/presentation/widgets/exams_section.dart';

void main() {
  testWidgets('exams section maps courses into the shared exams panel', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          academicExamCoursesProvider.overrideWithValue([
            const AcademicExamCourseEntity(
              id: 'course-1',
              year: 1,
              semester: 1,
              name: 'Programmazione',
              code: 'INF01',
              credits: 9,
              passed: false,
            ),
          ]),
        ],
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: ExamsSection())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Programmazione'), findsWidgets);
    expect(find.text('INF01'), findsWidgets);
  });
}
