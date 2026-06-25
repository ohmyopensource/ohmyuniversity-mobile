class TuitionFeeEntity {
  const TuitionFeeEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.isPaid,
    required this.isOverdue,
    required this.receiptAvailable,
    this.academicYear,
    this.referenceDate,
  });

  final String id;
  final String title;
  final double amount;
  final bool isPaid;
  final bool isOverdue;
  final bool receiptAvailable;
  final String? academicYear;
  final DateTime? referenceDate;
}
