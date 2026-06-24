import 'package:dio/dio.dart';

import '../../domain/exceptions/career_data_exception.dart';
import '../models/tuition_snapshot_model.dart';

class TuitionRemoteDataSource {
  const TuitionRemoteDataSource(this._dio);

  final Dio _dio;

  Future<TuitionSnapshotModel> getTuitionSnapshot() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/carriera/tasse',
      );

      final data = response.data;
      if (data == null || data.isEmpty) {
        throw const CareerDataException(
          'Il servizio ha restituito dati incompleti.',
        );
      }

      return TuitionSnapshotModel.fromJson(data);
    } on DioException catch (error) {
      throw CareerDataException(switch (error.response?.statusCode) {
        401 => "Sessione scaduta. Effettua nuovamente l'accesso.",
        503 => 'Lo stato delle tasse non è momentaneamente disponibile.',
        _ => 'Impossibile caricare lo stato delle tasse.',
      });
    } on FormatException {
      throw const CareerDataException(
        'Il servizio ha restituito dati tasse non validi.',
      );
    }
  }
}
