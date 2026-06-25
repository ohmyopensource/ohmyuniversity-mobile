import 'academic_exam_course_entity.dart';
import 'exam_appeal_entity.dart';

class RecommendedExamAppealEntity {
  const RecommendedExamAppealEntity({
    required this.course,
    required this.appeal,
  });

  final AcademicExamCourseEntity course;
  final ExamAppealEntity? appeal;

  bool get hasAppeal => appeal != null;

  bool get isBookable => appeal?.isBookable ?? false;

  bool get isBooked => appeal?.isBooked ?? false;
}
