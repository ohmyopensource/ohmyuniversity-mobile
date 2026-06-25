class ExamAppealMonthEntity {
  const ExamAppealMonthEntity({required this.month, required this.year});

  final int month;
  final int year;

  String get id => '$year-$month';

  @override
  bool operator ==(Object other) {
    return other is ExamAppealMonthEntity &&
        other.month == month &&
        other.year == year;
  }

  @override
  int get hashCode => Object.hash(month, year);
}
