import '../entities/timetable_document_entity.dart';

abstract interface class TimetableRepository {
  Future<List<TimetableDocumentEntity>> getStudentTimetables({
    required String universityId,
    required String courseName,
  });
}
