import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/data/datasources/tuition_remote_datasource.dart';
import 'package:ohmyuniversity/features/academics/domain/exceptions/career_data_exception.dart';

void main() {
  test('tuition remote datasource parses snapshot charges', () async {
    final dataSource = TuitionRemoteDataSource(
      _dioWithResponse({
        'semaforo': 'GREEN',
        'importoDovuto': '1.234,50',
        'addebiti': [
          {
            'fattId': 42,
            'rataDes': 'Prima rata',
            'importoVoce': '234,50',
            'pagatoFlg': 1,
            'aaId': 2025,
            'dataPagamento': '25/06/2026',
          },
          {
            'fattId': 43,
            'rataDes': 'Seconda rata',
            'importoVoce': 1000,
            'pagatoFlg': 0,
            'scadutoFlg': 1,
            'aaId': 2025,
            'scadFattura': '30/09/2026',
          },
        ],
      }),
    );

    final snapshot = await dataSource.getTuitionSnapshot();

    expect(snapshot.status, 'GREEN');
    expect(snapshot.totalDue, 1234.50);
    expect(snapshot.fees, hasLength(2));
    expect(snapshot.fees.first.isPaid, isTrue);
    expect(snapshot.fees.last.isOverdue, isTrue);
  });

  test('tuition remote datasource maps backend errors', () async {
    final dataSource = TuitionRemoteDataSource(_dioWithError(503));

    expect(dataSource.getTuitionSnapshot, throwsA(isA<CareerDataException>()));
  });
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
