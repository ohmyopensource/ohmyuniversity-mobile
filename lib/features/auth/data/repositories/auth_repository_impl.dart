import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<AuthSessionEntity> login({
    required String universityId,
    required String username,
    required String password,
  }) async {
    final session = await _remoteDataSource.login(
      universityId: universityId,
      username: username,
      password: password,
    );
    await _localDataSource.saveSession(session);
    return session;
  }

  @override
  Future<void> logout() async {
    final session = await _localDataSource.readSession();
    try {
      if (session != null) await _remoteDataSource.logout(session);
    } finally {
      await _localDataSource.clearSession();
    }
  }

  @override
  Future<AuthSessionEntity?> currentSession() => _localDataSource.readSession();

  @override
  Future<bool> isAuthenticated() async {
    final session = await _localDataSource.readSession();
    return session != null &&
        session.accessToken.isNotEmpty &&
        session.refreshToken.isNotEmpty;
  }
}
