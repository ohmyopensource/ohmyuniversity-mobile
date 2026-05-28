import '../../domain/entities/exam_appeal_entity.dart';

class ExamAppealModel extends ExamAppealEntity {
  const ExamAppealModel({
    required super.id,
    required super.examName,
    required super.month,
    required super.date,
    required super.time,
    required super.isBooked,
    super.isBookable,
    super.room,
  });
}
