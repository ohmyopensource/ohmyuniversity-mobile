import '../entities/career_snapshot_entity.dart';
import '../entities/exam_booking_entity.dart';
import '../entities/exam_booking_history_entity.dart';

abstract interface class DidatticaRepository {
  Future<CareerSnapshotEntity> getCareerSnapshot();
  Future<List<ExamBookingEntity>> getAvailableExamBookings({
    required int degreeCourseId,
    required List<ExamBookingHistoryEntity> bookingHistory,
  });
  Future<List<ExamBookingHistoryEntity>> getExamBookingHistory(
    String password,
  );
  Future<List<ExamBookingHistoryEntity>?> getCachedExamBookingHistory();
}
