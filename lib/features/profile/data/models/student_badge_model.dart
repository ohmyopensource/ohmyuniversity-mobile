import '../../domain/entities/student_badge_entity.dart';

class StudentBadgeModel extends StudentBadgeEntity {
  const StudentBadgeModel({
    required super.badgeId,
    required super.studentNumber,
    required super.firstName,
    required super.lastName,
    required super.taxCode,
    required super.courseCode,
    required super.courseName,
    required super.facultyCode,
    required super.facultyName,
    required super.enrollmentYear,
    required super.rfid,
    required super.universityName,
    required super.statusCode,
    required super.validFrom,
    required super.validUntil,
    required super.frontImagePresent,
    required super.rearImagePresent,
    required super.photoUrl,
  });

  factory StudentBadgeModel.fromJson(Map<String, dynamic> json) {
    return StudentBadgeModel(
      badgeId: (json['bdgId'] as num?)?.toInt(),
      studentNumber: json['matricola'] as String? ?? '',
      firstName: json['nome'] as String? ?? '',
      lastName: json['cognome'] as String? ?? '',
      taxCode: json['codFis'] as String? ?? '',
      courseCode: json['codCds'] as String? ?? '',
      courseName: json['desCds'] as String? ?? '',
      facultyCode: json['codFac'] as String? ?? '',
      facultyName: json['desFac'] as String? ?? '',
      enrollmentYear: (json['aaIscrAnn'] as num?)?.toInt(),
      rfid: json['rfid'] as String? ?? '',
      universityName: json['universita'] as String? ?? '',
      statusCode: json['staStuCod'] as String? ?? '',
      validFrom: _parseDate(json['dataIni'] as String?),
      validUntil: _parseDate(json['dataFin'] as String?),
      frontImagePresent: json['frontImagePresent'] as bool? ?? false,
      rearImagePresent: json['rearImagePresent'] as bool? ?? false,
      photoUrl:
          json['foto'] as String? ??
          json['photoUrl'] as String? ??
          json['imageUrl'] as String? ??
          '',
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.trim();
    final isoDate = DateTime.tryParse(normalized);
    if (isoDate != null) return isoDate;

    final match = RegExp(
      r'^(\d{1,2})/(\d{1,2})/(\d{4})',
    ).firstMatch(normalized);
    if (match == null) return null;
    return DateTime(
      int.parse(match.group(3)!),
      int.parse(match.group(2)!),
      int.parse(match.group(1)!),
    );
  }
}
