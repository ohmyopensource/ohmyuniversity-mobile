class ExamBookingHistoryEntity {
  const ExamBookingHistoryEntity({
    required this.id,
    required this.activityId,
    this.enrollmentActivityId,
    required this.courseCode,
    required this.courseName,
    required this.bookingDate,
    required this.examDate,
    required this.credits,
    required this.grade,
    required this.passed,
    required this.absent,
    required this.withdrawn,
  });

  final int id;
  final int? activityId;
  final int? enrollmentActivityId;
  final String courseCode;
  final String courseName;
  final DateTime? bookingDate;
  final DateTime? examDate;
  final double credits;
  final int? grade;
  final bool passed;
  final bool absent;
  final bool withdrawn;

  ExamBookingHistoryEntity copyWith({String? courseName, double? credits}) {
    return ExamBookingHistoryEntity(
      id: id,
      activityId: activityId,
      enrollmentActivityId: enrollmentActivityId,
      courseCode: courseCode,
      courseName: courseName ?? this.courseName,
      bookingDate: bookingDate,
      examDate: examDate,
      credits: credits ?? this.credits,
      grade: grade,
      passed: passed,
      absent: absent,
      withdrawn: withdrawn,
    );
  }
}
