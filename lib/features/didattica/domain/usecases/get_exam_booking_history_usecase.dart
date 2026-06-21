import '../entities/exam_booking_history_entity.dart';
import '../repositories/didattica_repository.dart';

class GetExamBookingHistoryUseCase {
  const GetExamBookingHistoryUseCase(this._repository);

  final DidatticaRepository _repository;

  Future<List<ExamBookingHistoryEntity>> call(String password) {
    return _repository.getExamBookingHistory(password);
  }

  Future<List<ExamBookingHistoryEntity>?> cached() {
    return _repository.getCachedExamBookingHistory();
  }
}
