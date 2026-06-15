import '../entities/timetable_document_entity.dart';

abstract interface class TimetableRepository {
  List<TimetableDocumentEntity> getStudentTimetables();
}
