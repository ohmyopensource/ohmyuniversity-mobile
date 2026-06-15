import '../../../../shared/mocks/app_mock_data.dart';
import '../../domain/entities/timetable_document_entity.dart';
import '../../domain/entities/timetable_document_format.dart';

class TimetableModel extends TimetableDocumentEntity {
  const TimetableModel({
    required super.id,
    required super.title,
    required super.universityName,
    required super.department,
    required super.degreeClass,
    required super.academicYear,
    required super.semester,
    required super.updatedAt,
    required super.format,
    required super.sourceUrl,
    super.fileUrl,
  });

  factory TimetableModel.fromMock(MockTimetableDocumentData data) {
    return TimetableModel(
      id: data.id,
      title: data.title,
      universityName: data.universityName,
      department: data.department,
      degreeClass: data.degreeClass,
      academicYear: data.academicYear,
      semester: data.semester,
      updatedAt: data.updatedAt,
      format: TimetableDocumentFormat.values.byName(data.format),
      sourceUrl: data.sourceUrl,
      fileUrl: data.fileUrl,
    );
  }
}
