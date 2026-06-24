import 'orientation_question_entity.dart';

class OrientationTopicEntity {
  const OrientationTopicEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
    required this.description,
    required this.questions,
  });

  final String id;
  final String title;
  final String subtitle;
  final String badgeLabel;
  final String description;
  final List<OrientationQuestionEntity> questions;
}
