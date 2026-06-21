import 'package:dio/dio.dart';

import '../config/api_config.dart';

class ApiClient {
  ApiClient(Future<String?> Function() readAccessToken)
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: ApiConfig.timeout,
          receiveTimeout: ApiConfig.timeout,
          sendTimeout: ApiConfig.timeout,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path.startsWith('/v1/auth/')) {
            handler.next(options);
            return;
          }
          final accessToken = await readAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio dio;
}
