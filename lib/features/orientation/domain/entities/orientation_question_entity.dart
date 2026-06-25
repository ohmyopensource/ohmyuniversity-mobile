class OrientationOptionEntity {
  const OrientationOptionEntity({required this.value, required this.label});

  final String value;
  final String label;
}

class OrientationQuestionEntity {
  const OrientationQuestionEntity({
    required this.id,
    required this.topicId,
    required this.text,
    required this.options,
    this.required = false,
  });

  final String id;
  final String topicId;
  final String text;
  final List<OrientationOptionEntity> options;
  final bool required;
}
