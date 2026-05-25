import '../models/academic_career_model.dart';
import '../models/exam_model.dart';

class AcademicCareerMockDataSource {
  Future<AcademicCareerModel> getAcademicCareer() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final exams = [
      ExamModel(
        id: 'exam-1',
        name: 'Programmazione I',
        grade: 28,
        credits: 9,
        date: DateTime(2025, 2, 12),
      ),
      ExamModel(
        id: 'exam-2',
        name: 'Analisi Matematica',
        grade: 26,
        credits: 12,
        date: DateTime(2025, 6, 18),
      ),
      ExamModel(
        id: 'exam-3',
        name: 'Basi di Dati',
        grade: 30,
        credits: 9,
        date: DateTime(2026, 1, 24),
        hasHonors: true,
      ),
    ];

    return AcademicCareerModel.fromExams(
      studentName: 'Mario Rossi',
      exams: exams,
      totalCredits: 180,
    );
  }
}
