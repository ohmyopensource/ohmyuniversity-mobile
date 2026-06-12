import '../../../../shared/mocks/app_mock_data.dart';
import '../models/academic_career_model.dart';
import '../models/exam_model.dart';

class AcademicCareerMockDataSource {
  Future<AcademicCareerModel> getAcademicCareer() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final exams = AppMockData.academicCareerExams.map(_toExamModel).toList();

    return AcademicCareerModel.fromExams(
      studentName: AppMockData.student.fullName,
      exams: exams,
      totalCredits: AppMockData.academicCareerTotalCredits,
    );
  }

  ExamModel _toExamModel(MockAcademicCareerExamData exam) {
    return ExamModel(
      id: exam.id,
      name: exam.name,
      grade: exam.grade,
      credits: exam.credits,
      date: exam.date,
      hasHonors: exam.hasHonors,
    );
  }
}
