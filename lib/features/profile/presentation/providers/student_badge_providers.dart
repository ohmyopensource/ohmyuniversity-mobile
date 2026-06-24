import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/providers/network_providers.dart';
import '../../data/datasources/student_badge_remote_datasource.dart';
import '../../data/repositories/student_badge_repository_impl.dart';
import '../../domain/entities/student_badge_entity.dart';
import '../../domain/repositories/student_badge_repository.dart';
import '../../domain/usecases/get_student_badge_usecase.dart';

final studentBadgeRemoteDataSourceProvider =
    Provider<StudentBadgeRemoteDataSource>((ref) {
      return StudentBadgeRemoteDataSource(ref.watch(apiDioProvider));
    });

final studentBadgeRepositoryProvider = Provider<StudentBadgeRepository>((ref) {
  return StudentBadgeRepositoryImpl(
    ref.watch(studentBadgeRemoteDataSourceProvider),
  );
});

final getStudentBadgeUseCaseProvider = Provider<GetStudentBadgeUseCase>((ref) {
  return GetStudentBadgeUseCase(ref.watch(studentBadgeRepositoryProvider));
});

final studentBadgeProvider = FutureProvider<StudentBadgeEntity?>((ref) {
  return ref.watch(getStudentBadgeUseCaseProvider).call();
});

final studentProfilePhotoProvider = FutureProvider<String?>((ref) async {
  try {
    final response = await ref
        .watch(apiDioProvider)
        .get<List<int>>(
          '/v1/carriera/foto',
          options: Options(responseType: ResponseType.bytes),
        );

    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) return null;

    return 'data:image/jpeg;base64,${base64Encode(bytes)}';
  } on DioException {
    return null;
  }
});
