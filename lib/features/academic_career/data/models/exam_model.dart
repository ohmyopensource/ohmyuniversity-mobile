import '../../domain/entities/exam_entity.dart';

class ExamModel extends ExamEntity {
  const ExamModel({
    required super.id,
    required super.name,
    required super.grade,
    required super.credits,
    required super.date,
    super.hasHonors,
  });
}
