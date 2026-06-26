import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/data/datasources/tuition_remote_datasource.dart';
import 'package:ohmyuniversity/features/academics/data/repositories/tuition_repository_impl.dart';

void main() {
  test(
    'tuition repository delegates snapshot loading to the remote datasource',
    () async {
      final repository = TuitionRepositoryImpl(
        TuitionRemoteDataSource(
          Dio()
            ..interceptors.add(
              InterceptorsWrapper(
                onRequest: (options, handler) {
                  handler.resolve(
                    Response(
                      requestOptions: options,
                      statusCode: 200,
                      data: {
                        'semaforo': 'YELLOW',
                        'importoDovuto': 90,
                        'tasseDovute': [
                          {
                            'voceId': 1,
                            'voceDes': 'Contributo',
                            'importoVoce': 90,
                          },
                        ],
                      },
                    ),
                  );
                },
              ),
            ),
        ),
      );

      final snapshot = await repository.getTuitionSnapshot();

      expect(snapshot.status, 'YELLOW');
      expect(snapshot.fees.single.title, 'Contributo');
    },
  );
}
