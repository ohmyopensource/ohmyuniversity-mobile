class ExamEntity {
  const ExamEntity({
    required this.id,
    required this.name,
    required this.grade,
    required this.credits,
    required this.date,
    this.hasHonors = false,
  });

  final String id;
  final String name;
  final int grade;
  final int credits;
  final DateTime date;
  final bool hasHonors;
}
