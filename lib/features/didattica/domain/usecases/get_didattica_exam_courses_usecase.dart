import '../entities/didattica_exam_course_entity.dart';
import '../repositories/didattica_repository.dart';

class GetDidatticaExamCoursesUseCase {
  const GetDidatticaExamCoursesUseCase(this._repository);

  final DidatticaRepository _repository;

  List<DidatticaExamCourseEntity> call() {
    return _repository.getExamCourses();
  }
}
