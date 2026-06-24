import '../entities/timetable_document_entity.dart';
import '../repositories/timetable_repository.dart';

class GetStudentTimetablesUseCase {
  const GetStudentTimetablesUseCase(this._repository);

  final TimetableRepository _repository;

  Future<List<TimetableDocumentEntity>> call({
    required String universityId,
    required String courseName,
  }) {
    return _repository.getStudentTimetables(
      universityId: universityId,
      courseName: courseName,
    );
  }
}
