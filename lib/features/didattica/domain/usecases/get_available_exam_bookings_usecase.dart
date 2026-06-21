import '../entities/exam_booking_entity.dart';
import '../entities/exam_booking_history_entity.dart';
import '../repositories/didattica_repository.dart';

class GetAvailableExamBookingsUseCase {
  const GetAvailableExamBookingsUseCase(this._repository);

  final DidatticaRepository _repository;

  Future<List<ExamBookingEntity>> call({
    required int degreeCourseId,
    required List<ExamBookingHistoryEntity> bookingHistory,
  }) {
    return _repository.getAvailableExamBookings(
      degreeCourseId: degreeCourseId,
      bookingHistory: bookingHistory,
    );
  }
}
