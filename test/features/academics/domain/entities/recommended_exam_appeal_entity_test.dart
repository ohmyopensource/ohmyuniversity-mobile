import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/academic_exam_course_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/exam_appeal_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/recommended_exam_appeal_entity.dart';

void main() {
  test('recommended exam appeal exposes appeal state flags', () {
    final booked = RecommendedExamAppealEntity(
      course: _course,
      appeal: _appeal(isBooked: true, isBookable: true),
    );
    final missing = RecommendedExamAppealEntity(course: _course, appeal: null);

    expect(booked.hasAppeal, isTrue);
    expect(booked.isBookable, isTrue);
    expect(booked.isBooked, isTrue);
    expect(missing.hasAppeal, isFalse);
    expect(missing.isBookable, isFalse);
    expect(missing.isBooked, isFalse);
  });
}

const _course = AcademicExamCourseEntity(
  id: 'course-1',
  year: 1,
  semester: 1,
  name: 'Programmazione',
  code: 'INF01',
  credits: 9,
  passed: false,
);

ExamAppealEntity _appeal({required bool isBooked, required bool isBookable}) {
  return ExamAppealEntity(
    id: 'appeal-1',
    examName: 'Programmazione',
    month: 6,
    date: DateTime(2026, 6, 18),
    time: '09:00',
    isBooked: isBooked,
    isBookable: isBookable,
  );
}
