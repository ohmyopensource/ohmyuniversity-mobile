import '../entities/career_profile_entity.dart';
import '../entities/auth_session_entity.dart';

abstract interface class AuthRepository {
  Future<AuthSessionEntity> login({
    required String universityId,
    required String username,
    required String password,
  });

  Future<AuthSessionEntity> switchCareer(CareerProfileEntity profile);

  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<AuthSessionEntity?> currentSession();
}
