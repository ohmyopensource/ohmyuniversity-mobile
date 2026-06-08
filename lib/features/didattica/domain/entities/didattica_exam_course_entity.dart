class DidatticaExamCourseEntity {
  const DidatticaExamCourseEntity({
    required this.id,
    required this.year,
    required this.semester,
    required this.name,
    required this.code,
    required this.credits,
    required this.passed,
    this.grade,
    this.completedAt,
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
}
