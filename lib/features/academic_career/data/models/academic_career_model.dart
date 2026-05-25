import '../../domain/entities/academic_career_entity.dart';
import '../../domain/entities/exam_entity.dart';

class AcademicCareerModel extends AcademicCareerEntity {
  const AcademicCareerModel({
    required super.studentName,
    required super.exams,
    required super.arithmeticAverage,
    required super.weightedAverage,
    required super.acquiredCredits,
    required super.totalCredits,
  });

  factory AcademicCareerModel.fromExams({
    required String studentName,
    required List<ExamEntity> exams,
    required int totalCredits,
  }) {
    final acquiredCredits = exams.fold<int>(
      0,
      (total, exam) => total + exam.credits,
    );
    final gradeSum = exams.fold<int>(0, (total, exam) => total + exam.grade);
    final weightedSum = exams.fold<int>(
      0,
      (total, exam) => total + (exam.grade * exam.credits),
    );

    return AcademicCareerModel(
      studentName: studentName,
      exams: exams,
      arithmeticAverage: exams.isEmpty ? 0 : gradeSum / exams.length,
      weightedAverage: acquiredCredits == 0 ? 0 : weightedSum / acquiredCredits,
      acquiredCredits: acquiredCredits,
      totalCredits: totalCredits,
    );
  }
}
