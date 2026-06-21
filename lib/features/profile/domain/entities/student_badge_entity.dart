class StudentBadgeEntity {
  const StudentBadgeEntity({
    required this.badgeId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.taxCode,
    required this.courseCode,
    required this.courseName,
    required this.facultyCode,
    required this.facultyName,
    required this.enrollmentYear,
    required this.rfid,
    required this.universityName,
    required this.statusCode,
    required this.validFrom,
    required this.validUntil,
    required this.frontImagePresent,
    required this.rearImagePresent,
  });

  final int? badgeId;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String taxCode;
  final String courseCode;
  final String courseName;
  final String facultyCode;
  final String facultyName;
  final int? enrollmentYear;
  final String rfid;
  final String universityName;
  final String statusCode;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final bool frontImagePresent;
  final bool rearImagePresent;

  String get fullName => '$firstName $lastName'.trim();

  String get academicYear => enrollmentYear == null
      ? ''
      : 'A.A. $enrollmentYear/${enrollmentYear! + 1}';
}
