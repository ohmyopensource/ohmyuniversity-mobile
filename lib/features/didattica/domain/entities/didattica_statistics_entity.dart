import 'average_trend_point_entity.dart';

class DidatticaStatisticsEntity {
  const DidatticaStatisticsEntity({
    required this.projectedGraduationBase,
    required this.maxGraduationBase,
    required this.averageTrend,
  });

  final double projectedGraduationBase;
  final double maxGraduationBase;
  final List<AverageTrendPointEntity> averageTrend;
}
