import 'dart:convert';

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
    if (session == null ||
        session.accessToken.isEmpty ||
        session.refreshToken.isEmpty) {
      await _localDataSource.clearSession();
      return false;
    }
    final claims = _accessTokenClaims(session.accessToken);
    if (claims == null ||
        _isAccessTokenExpired(claims) ||
        !_hasCareerClaims(claims)) {
      await _localDataSource.clearSession();
      return false;
    }

    try {
      final isSessionValid =
          await _remoteDataSource.refreshAccessToken(session) != null;
      if (!isSessionValid) {
        await _localDataSource.clearSession();
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Map<String, dynamic>? _accessTokenClaims(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      return jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  bool _isAccessTokenExpired(Map<String, dynamic> claims) {
    final expiration = claims['exp'] as num?;
    if (expiration == null) return true;
    final expirationDate = DateTime.fromMillisecondsSinceEpoch(
      expiration.toInt() * 1000,
    );
    return DateTime.now()
        .add(const Duration(seconds: 30))
        .isAfter(expirationDate);
  }

  bool _hasCareerClaims(Map<String, dynamic> claims) {
    return claims['stuId'] != null && claims['matId'] != null;
  }
}
