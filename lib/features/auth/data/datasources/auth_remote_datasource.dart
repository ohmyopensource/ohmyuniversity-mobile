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
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/auth/login',
        data: {
          'universityId': universityId,
          'username': username,
          'password': password,
        },
      );
      final data = response.data;
      if (data == null) {
        throw const AuthException('Risposta di autenticazione non valida.');
      }
      final session = AuthSessionModel.fromJson(data, username: username);
      if (session.accessToken.isEmpty || session.refreshToken.isEmpty) {
        throw const AuthException('Token di autenticazione mancanti.');
      }
      return session;
    } on DioException catch (error) {
      throw AuthException(_messageFor(error));
    }
  }

  Future<void> logout(AuthSessionModel session) async {
    try {
      await _dio.post<void>(
        '/v1/auth/logout',
        queryParameters: {
          'refreshToken': session.refreshToken,
          'universityId': session.activeProfile?.universityId ?? 'UNIMOL',
        },
      );
    } on DioException {
      // Local logout must still complete if the backend is unreachable.
    }
  }

  Future<String?> refreshAccessToken(AuthSessionModel session) async {
    try {
      final response = await _dio.post<String>(
        '/v1/auth/refresh',
        queryParameters: {
          'refreshToken': session.refreshToken,
          'universityId': session.activeProfile?.universityId ?? 'UNIMOL',
        },
      );
      final token = response.data?.trim();
      return token == null || token.isEmpty ? null : token;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) return null;
      throw AuthException(_messageFor(error));
    }
  }

  String _messageFor(DioException error) {
    return switch (error.response?.statusCode) {
      401 => 'Credenziali non valide.',
      404 => 'Ateneo non supportato dal servizio.',
      503 => 'Il servizio universitario non è disponibile.',
      _
          when error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout =>
        'Tempo di connessione scaduto.',
      _ => 'Impossibile contattare il servizio. Riprova.',
    };
  }
}
