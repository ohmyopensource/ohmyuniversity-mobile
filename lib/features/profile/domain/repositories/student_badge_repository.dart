import '../entities/student_badge_entity.dart';

abstract interface class StudentBadgeRepository {
  Future<StudentBadgeEntity?> getBadge();
}
