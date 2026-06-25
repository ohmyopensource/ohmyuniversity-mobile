import '../entities/academic_exam_course_entity.dart';
import '../entities/exam_appeal_entity.dart';
import '../entities/recommended_exam_appeal_entity.dart';

class GetRecommendedExamAppealsUseCase {
  const GetRecommendedExamAppealsUseCase();

  List<RecommendedExamAppealEntity> call({
    required List<AcademicExamCourseEntity> courses,
    required List<ExamAppealEntity> appeals,
  }) {
    final appealsByExam = <String, List<ExamAppealEntity>>{};

    for (final appeal in appeals) {
      final key = _normalize(appeal.examName);
      appealsByExam.putIfAbsent(key, () => []).add(appeal);
    }

    final pendingCourses = courses.where((course) => !course.passed).toList()
      ..sort(_compareCourses);

    return pendingCourses
        .map((course) {
          final matchingAppeals = appealsByExam[_normalize(course.name)] ?? [];
          return RecommendedExamAppealEntity(
            course: course,
            appeal: _bestAppealFor(matchingAppeals),
          );
        })
        .toList(growable: false);
  }

  int _compareCourses(
    AcademicExamCourseEntity first,
    AcademicExamCourseEntity second,
  ) {
    final creditsComparison = first.credits.compareTo(second.credits);
    if (creditsComparison != 0) return creditsComparison;

    final yearComparison = first.year.compareTo(second.year);
    if (yearComparison != 0) return yearComparison;

    final semesterComparison = first.semester.compareTo(second.semester);
    if (semesterComparison != 0) return semesterComparison;

    return first.name.compareTo(second.name);
  }

  ExamAppealEntity? _bestAppealFor(List<ExamAppealEntity> appeals) {
    if (appeals.isEmpty) return null;

    final sortedAppeals = [...appeals]..sort(_compareAppeals);
    return sortedAppeals.first;
  }

  int _compareAppeals(ExamAppealEntity first, ExamAppealEntity second) {
    final priorityComparison = _appealPriority(
      first,
    ).compareTo(_appealPriority(second));
    if (priorityComparison != 0) return priorityComparison;

    return first.date.compareTo(second.date);
  }

  int _appealPriority(ExamAppealEntity appeal) {
    if (appeal.isBookable) return 0;
    if (appeal.isBooked) return 1;
    return 2;
  }

  String _normalize(String value) => value.trim().toLowerCase();
}
