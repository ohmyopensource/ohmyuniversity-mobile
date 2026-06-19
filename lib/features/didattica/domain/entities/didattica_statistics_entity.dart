import 'average_trend_point_entity.dart';

class DidatticaStatisticsEntity {
  const DidatticaStatisticsEntity({
    required this.arithmeticAverage,
    required this.weightedAverage,
    required this.acquiredCredits,
    required this.totalCredits,
    required this.graduationBase,
    required this.projectedGraduationScore,
    required this.honorsCount,
    required this.gradeHistory,
    required this.averageTrend,
    required this.hasSimulation,
  });

  final double arithmeticAverage;
  final double weightedAverage;
  final int acquiredCredits;
  final int totalCredits;
  final double graduationBase;
  final double projectedGraduationScore;
  final int honorsCount;
  final List<AverageTrendPointEntity> gradeHistory;
  final List<AverageTrendPointEntity> averageTrend;
  final bool hasSimulation;

  double get projectedGraduationBase => projectedGraduationScore;
  double get maxGraduationBase => 110;

  double get completionProgress {
    if (totalCredits == 0) return 0;
    return (acquiredCredits / totalCredits).clamp(0, 1);
  }
}
