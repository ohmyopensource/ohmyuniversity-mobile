import 'package:dio/dio.dart';

import '../../domain/exceptions/services_exception.dart';
import '../models/external_services_model.dart';

class ExternalServicesRemoteDataSource {
  const ExternalServicesRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ExternalServicesModel> getExternalServices() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/university/external-services',
      );
      final data = response.data;
      if (data == null) {
        throw const ServicesException(
          'Il servizio ha restituito dati incompleti.',
        );
      }
      return ExternalServicesModel.fromJson(data);
    } on DioException catch (error) {
      throw ServicesException(switch (error.response?.statusCode) {
        401 => 'Sessione scaduta. Effettua nuovamente l’accesso.',
        404 => 'Servizi non configurati per il tuo ateneo.',
        503 => 'I servizi universitari non sono momentaneamente disponibili.',
        _
            when error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout =>
          'Tempo di connessione scaduto.',
        _ => 'Impossibile caricare i servizi universitari.',
      });
    }
  }
}
