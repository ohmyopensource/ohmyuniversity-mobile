import 'package:dio/dio.dart';

import '../../domain/exceptions/profile_data_exception.dart';
import '../models/student_badge_model.dart';

class StudentBadgeRemoteDataSource {
  const StudentBadgeRemoteDataSource(this._dio);

  final Dio _dio;

  Future<StudentBadgeModel?> getBadge() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/profile/badge',
      );

      final data = response.data;
      if (data == null || data.isEmpty) return null;

      return StudentBadgeModel.fromJson(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;

      throw ProfileDataException(switch (error.response?.statusCode) {
        401 => "Sessione scaduta. Effettua nuovamente l'accesso.",
        503 => 'Il profilo universitario non è momentaneamente disponibile.',
        _ => 'Impossibile caricare il profilo universitario.',
      });
    } on FormatException {
      throw const ProfileDataException(
        'Il servizio ha restituito un profilo non valido.',
      );
    }
  }
}
