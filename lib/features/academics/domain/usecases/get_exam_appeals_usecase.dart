import '../entities/exam_appeal_entity.dart';
import '../repositories/exam_appeals_repository.dart';

class GetExamAppealsUseCase {
  const GetExamAppealsUseCase(this._repository);

  final ExamAppealsRepository _repository;

  List<ExamAppealEntity> call() {
    return _repository.getExamAppeals();
  }
}
