import '../entities/student_badge_entity.dart';
import '../repositories/student_badge_repository.dart';

class GetStudentBadgeUseCase {
  const GetStudentBadgeUseCase(this._repository);

  final StudentBadgeRepository _repository;

  Future<StudentBadgeEntity?> call() => _repository.getBadge();
}
