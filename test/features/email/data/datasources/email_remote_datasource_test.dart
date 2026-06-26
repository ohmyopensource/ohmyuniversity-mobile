import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/email/data/datasources/email_remote_datasource.dart';
import 'package:ohmyuniversity/features/email/domain/exceptions/email_exception.dart';

void main() {
  test('email remote datasource parses authorization URL and inbox', () async {
    final authDataSource = EmailRemoteDataSource(
      _dioWithResponse('https://mail.unimol.it/oauth'),
    );
    final inboxDataSource = EmailRemoteDataSource(
      _dioWithResponse({
        'totalCount': 1,
        'messages': [
          {
            'id': 'mail-1',
            'subject': 'Benvenuto',
            'fromName': 'Segreteria',
            'fromAddress': 'segreteria@unimol.it',
            'receivedAt': '2026-06-25T10:00:00Z',
            'isRead': false,
            'hasAttachments': true,
            'preview': 'Messaggio di prova',
          },
        ],
      }),
    );

    final url = await authDataSource.getAuthorizationUrl();
    final inbox = await inboxDataSource.getInbox();

    expect(url.host, 'mail.unimol.it');
    expect(inbox.totalCount, 1);
    expect(inbox.messages.single.subject, 'Benvenuto');
    expect(inbox.messages.single.hasAttachments, isTrue);
  });

  test('email remote datasource maps disconnected account errors', () async {
    final dataSource = EmailRemoteDataSource(_dioWithError(409));

    expect(
      dataSource.getInbox,
      throwsA(isA<EmailAccountNotConnectedException>()),
    );
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
