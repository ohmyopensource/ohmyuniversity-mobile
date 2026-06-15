import '../../../../shared/mocks/app_mock_data.dart';
import '../../domain/entities/didattica_course_type.dart';
import '../models/didattica_exam_course_model.dart';

class DidatticaMockDataSource {
  const DidatticaMockDataSource();

  List<DidatticaExamCourseModel> getExamCourses() {
    return AppMockData.didatticaExamCourses.map(_toExamCourseModel).toList();
  }

  DidatticaExamCourseModel _toExamCourseModel(MockExamCourseData course) {
    return DidatticaExamCourseModel(
      id: course.id,
      year: course.year,
      semester: course.semester,
      name: course.name,
      code: course.code,
      credits: course.credits,
      grade: course.grade,
      passed: course.passed,
      completedAt: course.completedAt,
      courseType: DidatticaCourseType.values.byName(course.courseType),
    );
  }
}
