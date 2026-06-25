import 'package:dio/dio.dart';

import '../../domain/exceptions/career_data_exception.dart';
import '../../domain/entities/exam_booking_entity.dart';
import '../../domain/entities/exam_booking_history_entity.dart';
import '../models/career_api_models.dart';

class AcademicRemoteDataSource {
  const AcademicRemoteDataSource(this._dio);

  final Dio _dio;

  Future<CareerApiDataModel> getCareerData() async {
    try {
      final responses = await Future.wait([
        _dio.get<Map<String, dynamic>>('/v1/carriera/libretto'),
        _dio.get<Map<String, dynamic>>('/v1/carriera/medie'),
        _dio.get<Map<String, dynamic>>('/v1/carriera/piano'),
      ]);
      final transcriptJson = responses[0].data;
      final metricsJson = responses[1].data;
      final studyPlanJson = responses[2].data;
      if (transcriptJson == null ||
          metricsJson == null ||
          studyPlanJson == null) {
        throw const CareerDataException(
          'Il servizio ha restituito dati incompleti.',
        );
      }
      return CareerApiDataModel(
        transcript: TranscriptResponseModel.fromJson(transcriptJson),
        metrics: CareerMetricsModel.fromJson(metricsJson),
        studyPlan: StudyPlanResponseModel.fromJson(studyPlanJson),
      );
    } on DioException catch (error) {
      throw CareerDataException(_messageFor(error));
    }
  }

  Future<List<ExamBookingHistoryEntity>> getExamBookingHistory(
    String password,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/carriera/prenotazioni',
        data: {'password': password},
      );
      final bookings = response.data?['prenotazioni'] as List<dynamic>? ?? [];
      return bookings
          .whereType<Map<String, dynamic>>()
          .map(_mapBooking)
          .toList(growable: false);
    } on DioException catch (error) {
      throw CareerDataException(switch (error.response?.statusCode) {
        400 => 'Inserisci la password ESSE3.',
        401 => 'Password ESSE3 non valida.',
        503 => 'Lo storico prenotazioni non è momentaneamente disponibile.',
        _ => 'Impossibile caricare lo storico prenotazioni.',
      });
    }
  }

  Future<List<ExamBookingEntity>> getAvailableExamBookings({
    required int degreeCourseId,
    required ExamBookingHistoryEntity booking,
  }) async {
    final activityId = booking.activityId;
    if (activityId == null) return const [];

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/carriera/appelli',
        queryParameters: {'cdsId': degreeCourseId, 'adId': activityId},
      );
      final appeals = response.data?['appelli'] as List<dynamic>? ?? [];
      return appeals
          .whereType<Map<String, dynamic>>()
          .map((json) => _mapAppeal(json, booking))
          .toList(growable: false);
    } on DioException catch (error) {
      throw CareerDataException(switch (error.response?.statusCode) {
        401 => 'Appelli non recuperabili per questo insegnamento.',
        503 => 'Gli appelli non sono momentaneamente disponibili.',
        _ => 'Impossibile caricare gli appelli.',
      });
    }
  }

  ExamBookingHistoryEntity _mapBooking(Map<String, dynamic> json) {
    final result = json['esito'] as Map<String, dynamic>?;
    return ExamBookingHistoryEntity(
      id: (json['applistaId'] as num).toInt(),
      activityId: (json['adId'] as num?)?.toInt(),
      enrollmentActivityId: (json['adsceId'] as num?)?.toInt(),
      courseCode: json['adStuCod'] as String? ?? '',
      courseName: json['adStuDes'] as String? ?? '',
      bookingDate: _parseDate(json['dataIns'] as String?),
      examDate: _parseDate(json['dataEsa'] as String?),
      credits: (json['pesoAd'] as num?)?.toDouble() ?? 0,
      grade: (result?['votoEsa'] as num?)?.toInt(),
      passed: result?['superato'] as bool? ?? false,
      absent: result?['assente'] as bool? ?? false,
      withdrawn: result?['ritirato'] as bool? ?? false,
    );
  }

  ExamBookingEntity _mapAppeal(
    Map<String, dynamic> json,
    ExamBookingHistoryEntity booking,
  ) {
    final start =
        _parseDateTime(json['dataInizio'] as String?) ?? DateTime.now();
    final deadline =
        _parseDateTime(json['dataScadPrenotazione'] as String?) ?? start;
    final booked = json['prenotato'] as bool? ?? false;
    final bookable = json['prenotabile'] as bool? ?? false;

    return ExamBookingEntity(
      id: (json['appId'] ?? '${booking.activityId}-${start.toIso8601String()}')
          .toString(),
      courseName: _textOrFallback(json['adDes'], booking.courseName),
      courseAcronym: _textOrFallback(json['adCod'], booking.courseCode),
      professor: _textOrFallback(json['docente'], 'Docente non disponibile'),
      date: start,
      time:
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
      location: _textOrFallback(json['aula'], 'Aula non disponibile'),
      building: 'Edificio non disponibile',
      enrollDeadline: deadline,
      spotsTotal: 0,
      spotsLeft: 0,
      status: booked
          ? ExamBookingStatus.booked
          : bookable
          ? _statusForDeadline(deadline)
          : ExamBookingStatus.closed,
      credits: booking.credits.round(),
      year: 0,
    );
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final date = value.split(' ').first.split('/');
    if (date.length != 3) return DateTime.tryParse(value);
    return DateTime.tryParse('${date[2]}-${date[1]}-${date[0]}');
  }

  DateTime? _parseDateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    final normalized = value.trim();
    final parts = normalized.split(' ');
    final date = parts.first.split('/');
    if (date.length != 3) return DateTime.tryParse(normalized);
    final time = parts.length > 1 ? parts[1].split(':') : const <String>[];
    final year = int.tryParse(date[2]);
    final month = int.tryParse(date[1]);
    final day = int.tryParse(date[0]);
    if (year == null || month == null || day == null) {
      return DateTime.tryParse(normalized);
    }
    return DateTime(
      year,
      month,
      day,
      time.isNotEmpty ? int.tryParse(time[0]) ?? 0 : 0,
      time.length > 1 ? int.tryParse(time[1]) ?? 0 : 0,
    );
  }

  String _textOrFallback(Object? value, String fallback) {
    final text = value as String?;
    if (text == null || text.trim().isEmpty) return fallback;
    return text.trim();
  }

  ExamBookingStatus _statusForDeadline(DateTime deadline) {
    final remaining = deadline.difference(DateTime.now());
    if (remaining.isNegative) return ExamBookingStatus.closed;
    return remaining.inDays <= 3
        ? ExamBookingStatus.closing
        : ExamBookingStatus.open;
  }

  String _messageFor(DioException error) {
    return switch (error.response?.statusCode) {
      401 => 'Sessione scaduta. Effettua nuovamente l’accesso.',
      503 => 'I dati ESSE3 non sono momentaneamente disponibili.',
      _
          when error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout =>
        'Tempo di connessione scaduto.',
      _ => 'Impossibile caricare i dati della carriera.',
    };
  }
}
