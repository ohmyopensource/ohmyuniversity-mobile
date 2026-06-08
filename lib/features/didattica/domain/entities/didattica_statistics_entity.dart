import 'average_trend_point_entity.dart';

class DidatticaStatisticsEntity {
  const DidatticaStatisticsEntity({
    required this.arithmeticAverage,
    required this.weightedAverage,
    required this.acquiredCredits,
    required this.totalCredits,
    required this.projectedGraduationBase,
    required this.maxGraduationBase,
    required this.averageTrend,
  });

  final double arithmeticAverage;
  final double weightedAverage;
  final int acquiredCredits;
  final int totalCredits;
  final double projectedGraduationBase;
  final double maxGraduationBase;
  final List<AverageTrendPointEntity> averageTrend;
}
