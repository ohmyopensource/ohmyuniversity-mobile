enum ExamBookingStatus { open, closing, closed, booked }

class ExamBookingEntity {
  const ExamBookingEntity({
    required this.id,
    required this.courseName,
    required this.courseAcronym,
    required this.professor,
    required this.date,
    required this.time,
    required this.location,
    required this.building,
    required this.enrollDeadline,
    required this.spotsTotal,
    required this.spotsLeft,
    required this.status,
    required this.credits,
    required this.year,
  });

  final String id;
  final String courseName;
  final String courseAcronym;
  final String professor;
  final DateTime date;
  final String time;
  final String location;
  final String building;
  final DateTime enrollDeadline;
  final int spotsTotal;
  final int spotsLeft;
  final ExamBookingStatus status;
  final int credits;
  final int year;

  ExamBookingEntity copyWith({ExamBookingStatus? status}) {
    return ExamBookingEntity(
      id: id,
      courseName: courseName,
      courseAcronym: courseAcronym,
      professor: professor,
      date: date,
      time: time,
      location: location,
      building: building,
      enrollDeadline: enrollDeadline,
      spotsTotal: spotsTotal,
      spotsLeft: spotsLeft,
      status: status ?? this.status,
      credits: credits,
      year: year,
    );
  }
}
