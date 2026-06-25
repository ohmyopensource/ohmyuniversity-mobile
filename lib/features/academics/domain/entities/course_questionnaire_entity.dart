enum CourseQuestionnaireStatus { pending, completed }

class CourseQuestionnaireEntity {
  const CourseQuestionnaireEntity({
    required this.id,
    required this.courseName,
    required this.professor,
    required this.type,
    required this.status,
    this.deadline,
    this.completedAt,
  });

  final String id;
  final String courseName;
  final String professor;
  final String type;
  final CourseQuestionnaireStatus status;
  final DateTime? deadline;
  final DateTime? completedAt;
}
