import 'package:dio/dio.dart';

import '../../domain/exceptions/timetable_exception.dart';
import '../models/timetable_model.dart';

class TimetableRemoteDataSource {
  const TimetableRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<TimetableModel>> getStudentTimetables({
    required String universityId,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/v1/fetcher/timetables',
        queryParameters: {'universityId': universityId},
      );

      return (response.data ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .where((item) => item['active'] != false)
          .map(TimetableModel.fromJson)
          .toList(growable: false);
    } on FormatException {
      throw const TimetableException(
        'Il servizio ha restituito un orario non valido.',
      );
    } on DioException catch (error) {
      throw TimetableException(switch (error.response?.statusCode) {
        401 => 'Sessione scaduta. Effettua nuovamente l\'accesso.',
        404 => 'Nessun orario configurato per il tuo ateneo.',
        503 => 'Il servizio orari non è momentaneamente disponibile.',
        _
            when error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout =>
          'Tempo di connessione scaduto.',
        _ => 'Impossibile caricare gli orari delle lezioni.',
      });
    }
  }
}
