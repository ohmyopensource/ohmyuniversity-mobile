import '../entities/exam_appeal_entity.dart';

abstract class ExamAppealsRepository {
  List<ExamAppealEntity> getExamAppeals();
}
