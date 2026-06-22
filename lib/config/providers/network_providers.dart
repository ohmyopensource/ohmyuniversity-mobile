import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/network/api_client.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(ref.watch(secureStorageProvider));
});

final apiDioProvider = Provider<Dio>((ref) {
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return ApiClient(
    () async => (await localDataSource.readSession())?.accessToken,
  ).dio;
});
