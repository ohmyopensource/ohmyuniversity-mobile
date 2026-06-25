import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/services/data/datasources/external_services_remote_datasource.dart';
import 'package:ohmyuniversity/features/services/domain/exceptions/services_exception.dart';

void main() {
  test(
    'external services remote datasource parses university services',
    () async {
      final dataSource = ExternalServicesRemoteDataSource(
        _dioWithResponse({
          'universityId': 'UNIMOL',
          'name': 'Universita degli Studi del Molise',
        }),
      );

      final services = await dataSource.getExternalServices();

      expect(services.universityId, 'UNIMOL');
      expect(services.moodleUrl?.host, 'learn.unimol.it');
      expect(services.studentPortalUrl.toString(), contains('esse3'));
    },
  );

  test(
    'external services remote datasource maps unavailable services',
    () async {
      final dataSource = ExternalServicesRemoteDataSource(_dioWithError(503));

      expect(dataSource.getExternalServices, throwsA(isA<ServicesException>()));
    },
  );
}

Dio _dioWithResponse(Object? data) {
  return Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(requestOptions: options, statusCode: 200, data: data),
          );
        },
      ),
    );
}

Dio _dioWithError(int statusCode) {
  return Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: statusCode,
              ),
            ),
          );
        },
      ),
    );
}
