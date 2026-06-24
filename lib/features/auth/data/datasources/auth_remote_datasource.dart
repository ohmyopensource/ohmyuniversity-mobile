import 'package:dio/dio.dart';

import '../../domain/exceptions/auth_exception.dart';
import '../models/auth_session_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthSessionModel> login({
    required String universityId,
    required String username,
    required String password,
  }) async {
    final normalizedUniversityId = universityId.trim().toUpperCase();

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/auth/login',
        data: {
          'universityId': normalizedUniversityId,
          'username': username.trim(),
          'password': password,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const AuthException('Risposta di autenticazione non valida.');
      }

      final session = AuthSessionModel.fromJson(
        data,
        universityId: normalizedUniversityId,
        username: username.trim(),
      );

      if (session.accessToken.isEmpty || session.refreshToken.isEmpty) {
        throw const AuthException('Token di autenticazione mancanti.');
      }

      return session;
    } on DioException catch (error) {
      throw AuthException(_messageFor(error));
    }
  }

  Future<String?> refreshAccessToken(AuthSessionModel session) async {
    final refreshToken = session.refreshToken.trim();
    final universityId = _sessionUniversityId(session);

    if (refreshToken.isEmpty || universityId.isEmpty) return null;

    try {
      final response = await _dio.post<String>(
        '/v1/auth/refresh',
        queryParameters: {
          'refreshToken': refreshToken,
          'universityId': universityId,
        },
        options: Options(responseType: ResponseType.plain),
      );

      final token = response.data?.trim();
      return token == null || token.isEmpty ? null : token;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) return null;
      throw AuthException(_messageFor(error));
    }
  }

  Future<String> switchCareer({
    required AuthSessionModel session,
    required CareerProfileModel profile,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/auth/switch-carriera',
        queryParameters: {
          'stuId': profile.studentId?.toString() ?? '',
          'matId': profile.enrollmentId?.toString() ?? '',
          'matricola': profile.studentNumber,
        },
      );

      final token = response.data?['accessToken'] as String? ?? '';
      if (token.trim().isEmpty) {
        throw const AuthException('Token di cambio carriera mancante.');
      }
      return token.trim();
    } on DioException catch (error) {
      throw AuthException(_messageFor(error));
    }
  }

  Future<void> logout(AuthSessionModel session) async {
    final refreshToken = session.refreshToken.trim();
    final universityId = _sessionUniversityId(session);

    if (refreshToken.isEmpty || universityId.isEmpty) return;

    try {
      await _dio.post<void>(
        '/v1/auth/logout',
        queryParameters: {
          'refreshToken': refreshToken,
          'universityId': universityId,
        },
      );
    } on DioException {
      // Il logout locale deve comunque completarsi anche se il backend non risponde.
    }
  }

  String _sessionUniversityId(AuthSessionModel session) {
    final storedUniversityId = session.universityId.trim();
    if (storedUniversityId.isNotEmpty) return storedUniversityId.toUpperCase();

    final profileUniversityId =
        session.activeProfile?.universityId.trim() ?? '';
    return profileUniversityId.toUpperCase();
  }

  String _messageFor(DioException error) {
    return switch (error.response?.statusCode) {
      400 => 'Richiesta di autenticazione non valida.',
      401 => 'Credenziali non valide.',
      404 => 'Ateneo non supportato dal servizio.',
      503 => 'Il servizio universitario non è disponibile.',
      _
          when error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout =>
        'Tempo di connessione scaduto.',
      _ => 'Impossibile contattare il servizio. Riprova.',
    };
  }
}
