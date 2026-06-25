import 'academic_course_type.dart';
import 'academic_cfu_breakdown_entity.dart';

class AcademicExamCourseEntity {
  const AcademicExamCourseEntity({
    required this.id,
    required this.year,
    required this.semester,
    required this.name,
    required this.code,
    required this.credits,
    required this.passed,
    this.grade,
    this.courseType = AcademicCourseType.mandatory,
    this.completedAt,
    this.language = 'Italiano',
    this.durationHours = 0,
    this.attendanceMandatory = false,
    this.scientificSector = '',
    this.location = '',
    this.prerequisites = const [],
    this.cfuBreakdown = const [],
  });

  final String id;
  final int year;
  final int semester;
  final String name;
  final String code;
  final int credits;
  final bool passed;
  final String? grade;
  final DateTime? completedAt;
  final AcademicCourseType courseType;
  final String language;
  final int durationHours;
  final bool attendanceMandatory;
  final String scientificSector;
  final String location;
  final List<String> prerequisites;
  final List<AcademicCfuBreakdownEntity> cfuBreakdown;

  bool get isPropaedeutic => prerequisites.isNotEmpty;
}
