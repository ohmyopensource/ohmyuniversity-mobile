import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<UserEntity> login({required String university});
  Future<void> logout();
  Future<bool> isAuthenticated();
}
