import '../entities/didattica_exam_course_entity.dart';

abstract class DidatticaRepository {
  List<DidatticaExamCourseEntity> getExamCourses();
}
