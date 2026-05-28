import '../entities/didattica_exam_course_entity.dart';
import '../entities/didattica_statistics_entity.dart';

abstract class DidatticaRepository {
  List<DidatticaExamCourseEntity> getExamCourses();

  DidatticaStatisticsEntity getStatistics();
}
