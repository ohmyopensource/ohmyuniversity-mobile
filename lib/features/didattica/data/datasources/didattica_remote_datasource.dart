import 'package:dio/dio.dart';

import '../../domain/exceptions/career_data_exception.dart';
import '../models/career_api_models.dart';

class DidatticaRemoteDataSource {
  const DidatticaRemoteDataSource(this._dio);

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
