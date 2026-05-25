import 'exam_entity.dart';

class AcademicCareerEntity {
  const AcademicCareerEntity({
    required this.studentName,
    required this.exams,
    required this.arithmeticAverage,
    required this.weightedAverage,
    required this.acquiredCredits,
    required this.totalCredits,
  });

  final String studentName;
  final List<ExamEntity> exams;
  final double arithmeticAverage;
  final double weightedAverage;
  final int acquiredCredits;
  final int totalCredits;
}
