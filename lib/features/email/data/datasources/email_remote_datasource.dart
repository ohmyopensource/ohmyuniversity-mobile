import 'package:dio/dio.dart';

import '../../domain/exceptions/email_exception.dart';
import '../models/email_inbox_model.dart';

class EmailRemoteDataSource {
  const EmailRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Uri> getAuthorizationUrl() async {
    try {
      final response = await _dio.get<String>('/v1/email/auth/url');
      final value = response.data?.trim() ?? '';
      final uri = Uri.tryParse(value);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
        throw const EmailException(
          'Il servizio email ha restituito un collegamento non valido.',
        );
      }
      return uri;
    } on DioException catch (error) {
      throw EmailException(_messageFor(error));
    }
  }

  Future<EmailInboxModel> getInbox() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/email/inbox');
      final data = response.data;
      if (data == null) {
        throw const EmailException(
          'Il servizio email ha restituito dati incompleti.',
        );
      }
      return EmailInboxModel.fromJson(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 409) {
        throw const EmailAccountNotConnectedException();
      }
      throw EmailException(_messageFor(error));
    }
  }

  String _messageFor(DioException error) {
    return switch (error.response?.statusCode) {
      401 => 'Sessione scaduta. Effettua nuovamente l’accesso.',
      502 => 'Il provider email non è momentaneamente disponibile.',
      _
          when error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout =>
        'Tempo di connessione scaduto.',
      _ => 'Impossibile contattare il servizio email.',
    };
  }
}
