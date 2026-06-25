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
    super.academicYear,
    super.semester,
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

  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    final pdfUrl = _optionalString(json['pdfUrl']);
    final sourceUrl = _optionalString(json['timetablePageUrl']) ?? pdfUrl;

    if (sourceUrl == null) {
      throw const FormatException('Missing timetable URL');
    }

    return TimetableModel(
      id: json['id']?.toString() ?? sourceUrl,
      title: _optionalString(json['label']) ?? 'Orario lezioni',
      universityName:
          _optionalString(json['universityId']) ?? 'Ateneo universitario',
      department: _optionalString(json['departmentName']) ?? 'Dipartimento',
      degreeClass: _optionalString(json['degreeType']) ?? 'Corso di laurea',
      updatedAt:
          DateTime.tryParse(json['fetchedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      format: pdfUrl == null
          ? TimetableDocumentFormat.web
          : TimetableDocumentFormat.pdf,
      sourceUrl: sourceUrl,
      fileUrl: pdfUrl,
    );
  }

  static String? _optionalString(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}
