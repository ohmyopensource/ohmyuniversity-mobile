import 'academic_exam_course_entity.dart';
import 'academic_statistics_entity.dart';

class CareerSnapshotEntity {
  const CareerSnapshotEntity({required this.courses, required this.statistics});

  final List<AcademicExamCourseEntity> courses;
  final AcademicStatisticsEntity statistics;
}
