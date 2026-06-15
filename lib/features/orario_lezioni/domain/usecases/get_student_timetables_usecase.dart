import '../entities/timetable_document_entity.dart';
import '../repositories/timetable_repository.dart';

class GetStudentTimetablesUseCase {
  const GetStudentTimetablesUseCase(this._repository);

  final TimetableRepository _repository;

  List<TimetableDocumentEntity> call() {
    return _repository.getStudentTimetables();
  }
}
