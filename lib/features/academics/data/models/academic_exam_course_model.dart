import '../../domain/entities/academic_exam_course_entity.dart';

class AcademicExamCourseModel extends AcademicExamCourseEntity {
  const AcademicExamCourseModel({
    required super.id,
    required super.year,
    required super.semester,
    required super.name,
    required super.code,
    required super.credits,
    required super.passed,
    super.courseType,
    super.grade,
    super.completedAt,
    super.language,
    super.durationHours,
    super.attendanceMandatory,
    super.scientificSector,
    super.location,
    super.prerequisites,
    super.cfuBreakdown,
  });
}
