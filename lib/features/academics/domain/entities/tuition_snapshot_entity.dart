import 'tuition_fee_entity.dart';

class TuitionSnapshotEntity {
  const TuitionSnapshotEntity({
    required this.status,
    required this.totalDue,
    required this.fees,
  });

  final String status;
  final double totalDue;
  final List<TuitionFeeEntity> fees;

  double get paidTotal => fees
      .where((fee) => fee.isPaid)
      .fold(0, (total, fee) => total + fee.amount);

  double get academicYearTotal =>
      fees.fold(0, (total, fee) => total + fee.amount);
}
