class ExamAppealEntity {
  const ExamAppealEntity({
    required this.id,
    required this.examName,
    required this.month,
    required this.date,
    required this.time,
    required this.isBooked,
    this.isBookable = false,
    this.room,
  });

  final String id;
  final String examName;
  final int month;
  final DateTime date;
  final String time;
  final bool isBooked;
  final bool isBookable;
  final String? room;
}
