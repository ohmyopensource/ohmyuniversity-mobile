import 'package:dio/dio.dart';

import '../../domain/exceptions/calendar_exception.dart';
import '../models/calendar_event_model.dart';

class CalendarRemoteDataSource {
  const CalendarRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<CalendarEventModel>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/v1/calendar/events',
        queryParameters: {
          if (startDate != null) 'from': startDate.toUtc().toIso8601String(),
          if (endDate != null) 'to': endDate.toUtc().toIso8601String(),
        },
      );
      return (response.data ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(CalendarEventModel.fromJson)
          .toList(growable: false);
    } on FormatException {
      throw const CalendarException(
        'Il servizio ha restituito un evento non valido.',
      );
    } on DioException catch (error) {
      throw CalendarException(_messageFor(error));
    }
  }

  Future<CalendarEventModel> createEvent(CalendarEventModel event) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/calendar/events',
        data: event.toRequestJson(),
      );
      return _eventFrom(response.data);
    } on DioException catch (error) {
      throw CalendarException(_messageFor(error));
    }
  }

  Future<CalendarEventModel> updateEvent(CalendarEventModel event) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/v1/calendar/events/${event.id}',
        data: event.toRequestJson(),
      );
      return _eventFrom(response.data);
    } on DioException catch (error) {
      throw CalendarException(_messageFor(error));
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _dio.delete<void>('/v1/calendar/events/$eventId');
    } on DioException catch (error) {
      throw CalendarException(_messageFor(error));
    }
  }

  CalendarEventModel _eventFrom(Map<String, dynamic>? data) {
    if (data == null) {
      throw const CalendarException(
        'Il servizio ha restituito dati incompleti.',
      );
    }
    try {
      return CalendarEventModel.fromJson(data);
    } on FormatException {
      throw const CalendarException(
        'Il servizio ha restituito un evento non valido.',
      );
    }
  }

  String _messageFor(DioException error) {
    return switch (error.response?.statusCode) {
      400 => 'Controlla i dati inseriti e riprova.',
      401 => 'Sessione scaduta. Effettua nuovamente l\'accesso.',
      404 => 'Evento non trovato.',
      503 => 'Il calendario non è momentaneamente disponibile.',
      _
          when error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout =>
        'Tempo di connessione scaduto.',
      _ => 'Impossibile completare l\'operazione sul calendario.',
    };
  }
}
