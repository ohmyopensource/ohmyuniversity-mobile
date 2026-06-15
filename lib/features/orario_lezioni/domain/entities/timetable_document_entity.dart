import 'timetable_document_format.dart';

class TimetableDocumentEntity {
  const TimetableDocumentEntity({
    required this.id,
    required this.title,
    required this.universityName,
    required this.department,
    required this.degreeClass,
    required this.academicYear,
    required this.semester,
    required this.updatedAt,
    required this.format,
    required this.sourceUrl,
    this.fileUrl,
  });

  final String id;
  final String title;
  final String universityName;
  final String department;
  final String degreeClass;
  final String academicYear;
  final int semester;
  final DateTime updatedAt;
  final TimetableDocumentFormat format;
  final String sourceUrl;
  final String? fileUrl;

  bool get hasPdf => format == TimetableDocumentFormat.pdf && fileUrl != null;
}
