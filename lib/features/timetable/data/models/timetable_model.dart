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
    final pdfUrl = _optionalString(
      json['pdfUrl'] ?? json['fileUrl'] ?? json['urlPdf'],
    );

    final pageUrl = _optionalString(
      json['timetablePageUrl'] ?? json['sourceUrl'] ?? json['pageUrl'],
    );

    final sourceUrl = pageUrl ?? pdfUrl;

    if (sourceUrl == null) {
      throw const FormatException('Missing timetable URL');
    }

    return TimetableModel(
      id: _optionalString(json['id']) ?? sourceUrl,
      title: _optionalString(json['label'] ?? json['title']) ??
          'Orario lezioni',
      universityName: _optionalString(
        json['universityName'] ?? json['universityId'],
      ) ??
          'Ateneo universitario',
      department: _optionalString(
        json['departmentName'] ?? json['department'],
      ) ??
          'Dipartimento',
      degreeClass: _optionalString(
        json['degreeType'] ?? json['courseName'] ?? json['degreeClass'],
      ) ??
          'Corso di laurea',
      academicYear: _optionalString(json['academicYear'] ?? json['aa']),
      semester: _parseSemester(json['semester'] ?? json['semestre']),
      updatedAt: _parseDate(json['fetchedAt'] ?? json['updatedAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      format: pdfUrl == null
          ? TimetableDocumentFormat.web
          : TimetableDocumentFormat.pdf,
      sourceUrl: sourceUrl,
      fileUrl: pdfUrl,
    );
  }

  static int? _parseSemester(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toInt();

    final text = value.toString().toLowerCase();
    if (text.contains('1') || text.contains('primo')) return 1;
    if (text.contains('2') || text.contains('secondo')) return 2;

    return null;
  }

  static DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static String? _optionalString(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}