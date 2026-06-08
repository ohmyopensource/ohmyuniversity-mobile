import '../../domain/entities/didattica_exam_course_entity.dart';

class DidatticaExamCourseModel extends DidatticaExamCourseEntity {
  const DidatticaExamCourseModel({
    required super.id,
    required super.year,
    required super.semester,
    required super.name,
    required super.code,
    required super.credits,
    required super.passed,
    super.grade,
    super.completedAt,
  });
}
