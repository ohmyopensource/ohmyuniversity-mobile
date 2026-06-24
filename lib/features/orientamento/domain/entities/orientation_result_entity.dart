class OrientationAreaScoreEntity {
  const OrientationAreaScoreEntity({
    required this.id,
    required this.label,
    required this.score,
    required this.percentage,
  });

  final String id;
  final String label;
  final int score;
  final int percentage;
}

class OrientationResultEntity {
  const OrientationResultEntity({
    required this.dominantArea,
    required this.topAreas,
    required this.awarenessScore,
    required this.awarenessTips,
    required this.personalizedTips,
    required this.budgetTips,
    this.estimatedMonthlyBudget,
  });

  final OrientationAreaScoreEntity dominantArea;
  final List<OrientationAreaScoreEntity> topAreas;
  final int awarenessScore;
  final List<String> awarenessTips;
  final List<String> personalizedTips;
  final List<String> budgetTips;
  final String? estimatedMonthlyBudget;
}
