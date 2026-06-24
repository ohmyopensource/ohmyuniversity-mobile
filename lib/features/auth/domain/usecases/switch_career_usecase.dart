import '../entities/auth_session_entity.dart';
import '../entities/career_profile_entity.dart';
import '../repositories/auth_repository.dart';

class SwitchCareerUseCase {
  const SwitchCareerUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSessionEntity> call(CareerProfileEntity profile) {
    return _repository.switchCareer(profile);
  }
}
