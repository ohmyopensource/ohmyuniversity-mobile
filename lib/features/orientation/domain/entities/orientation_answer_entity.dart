class OrientationAnswerEntity {
  const OrientationAnswerEntity({
    required this.questionId,
    required this.topicId,
    required this.value,
    required this.label,
  });

  final String questionId;
  final String topicId;
  final String value;
  final String label;
}
