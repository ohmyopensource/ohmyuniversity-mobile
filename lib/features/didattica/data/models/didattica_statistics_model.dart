import '../../domain/entities/average_trend_point_entity.dart';
import '../../domain/entities/didattica_statistics_entity.dart';

class DidatticaStatisticsModel extends DidatticaStatisticsEntity {
  const DidatticaStatisticsModel({
    required super.projectedGraduationBase,
    required super.maxGraduationBase,
    required super.averageTrend,
  });

  DidatticaStatisticsModel copyWith({
    double? projectedGraduationBase,
    double? maxGraduationBase,
    List<AverageTrendPointEntity>? averageTrend,
  }) {
    return DidatticaStatisticsModel(
      projectedGraduationBase:
          projectedGraduationBase ?? this.projectedGraduationBase,
      maxGraduationBase: maxGraduationBase ?? this.maxGraduationBase,
      averageTrend: averageTrend ?? this.averageTrend,
    );
  }
}
