import 'didattica_exam_course_entity.dart';
import 'didattica_statistics_entity.dart';

class CareerSnapshotEntity {
  const CareerSnapshotEntity({required this.courses, required this.statistics});

  final List<DidatticaExamCourseEntity> courses;
  final DidatticaStatisticsEntity statistics;
}
