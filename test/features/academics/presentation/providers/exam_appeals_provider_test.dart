import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/academic_exam_course_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/exam_appeal_entity.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/exam_appeals_provider.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/exam_courses_provider.dart';

void main() {
  test(
    'exam appeals provider exposes mock appeal data through the use case',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final appeals = container.read(examAppealsProvider);
      final useCaseAppeals = container
          .read(getExamAppealsUseCaseProvider)
          .call();

      expect(appeals, isNotEmpty);
      expect(
        useCaseAppeals.map((appeal) => appeal.id),
        appeals.map((appeal) => appeal.id),
      );
    },
  );

  test(
    'recommended exam appeals provider matches pending courses to appeals',
    () {
      final container = ProviderContainer(
        overrides: [
          academicExamCoursesProvider.overrideWithValue([
            _course(
              id: 'passed',
              name: 'Basi di dati',
              credits: 6,
              passed: true,
            ),
            _course(
              id: 'pending',
              name: 'Programmazione',
              credits: 9,
              passed: false,
            ),
          ]),
          examAppealsProvider.overrideWithValue([
            _appeal(
              id: 'late',
              examName: 'Programmazione',
              date: DateTime(2026, 7, 1),
              isBookable: false,
            ),
            _appeal(
              id: 'bookable',
              examName: 'Programmazione',
              date: DateTime(2026, 7, 10),
              isBookable: true,
            ),
          ]),
        ],
      );
      addTearDown(container.dispose);

      final recommended = container.read(recommendedExamAppealsProvider);

      expect(recommended, hasLength(1));
      expect(recommended.single.course.id, 'pending');
      expect(recommended.single.appeal?.id, 'bookable');
    },
  );
}

AcademicExamCourseEntity _course({
  required String id,
  required String name,
  required int credits,
  required bool passed,
}) {
  return AcademicExamCourseEntity(
    id: id,
    year: 1,
    semester: 1,
    name: name,
    code: id.toUpperCase(),
    credits: credits,
    passed: passed,
  );
}

ExamAppealEntity _appeal({
  required String id,
  required String examName,
  required DateTime date,
  required bool isBookable,
}) {
  return ExamAppealEntity(
    id: id,
    examName: examName,
    month: date.month,
    date: date,
    time: '09:00',
    isBooked: false,
    isBookable: isBookable,
  );
}
