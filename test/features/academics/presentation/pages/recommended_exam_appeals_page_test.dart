import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/academic_exam_course_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/exam_appeal_entity.dart';
import 'package:ohmyuniversity/features/academics/presentation/pages/recommended_exam_appeals_page.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/exam_appeals_provider.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/exam_courses_provider.dart';

void main() {
  testWidgets(
    'recommended exam appeals page renders pending and passed exams',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            academicExamCoursesProvider.overrideWithValue([
              AcademicExamCourseEntity(
                id: 'pending',
                year: 1,
                semester: 1,
                name: 'Programmazione',
                code: 'INF01',
                credits: 9,
                passed: false,
              ),
              AcademicExamCourseEntity(
                id: 'passed',
                year: 1,
                semester: 1,
                name: 'Basi di dati',
                code: 'INF02',
                credits: 6,
                passed: true,
                grade: '28',
                completedAt: DateTime(2026, 6, 1),
              ),
            ]),
            examAppealsProvider.overrideWithValue([
              ExamAppealEntity(
                id: 'appeal-1',
                examName: 'Programmazione',
                month: 7,
                date: DateTime(2026, 7, 10),
                time: '09:00',
                isBooked: false,
                isBookable: true,
              ),
            ]),
          ],
          child: const MaterialApp(home: RecommendedExamAppealsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Appelli consigliati'), findsOneWidget);
      expect(find.text('Da valutare'), findsOneWidget);
      expect(find.text('Programmazione'), findsOneWidget);
      expect(find.text('Esami superati'), findsOneWidget);
      expect(find.text('Basi di dati'), findsOneWidget);
    },
  );
}
