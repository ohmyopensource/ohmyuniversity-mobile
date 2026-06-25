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
  String? badgePhotoUrl;

  try {
    final badge = await ref.watch(studentBadgeProvider.future);
    badgePhotoUrl = _normalizePhotoSource(badge?.photoUrl);

    final response = await ref
        .watch(apiDioProvider)
        .get<List<int>>(
          '/v1/carriera/foto',
          options: Options(responseType: ResponseType.bytes),
        );

    final photo = _photoDataUriFromBytes(response.data);
    if (photo != null) return photo;
  } on DioException {
    return badgePhotoUrl;
  }

  return badgePhotoUrl;
});

String? _photoDataUriFromBytes(List<int>? bytes) {
  if (bytes == null || bytes.isEmpty) return null;

  final mimeType = _imageMimeType(bytes);
  if (mimeType == null) return null;

  return 'data:$mimeType;base64,${base64Encode(bytes)}';
}

String? _normalizePhotoSource(String? value) {
  final source = value?.trim();
  if (source == null || source.isEmpty) return null;
  if (source.startsWith('data:image/') ||
      source.startsWith('http://') ||
      source.startsWith('https://')) {
    return source;
  }

  return 'data:image/jpeg;base64,$source';
}

String? _imageMimeType(List<int> bytes) {
  if (_startsWith(bytes, const [0xFF, 0xD8, 0xFF])) {
    return 'image/jpeg';
  }
  if (_startsWith(bytes, const [0x89, 0x50, 0x4E, 0x47])) {
    return 'image/png';
  }
  if (_startsWith(bytes, const [0x47, 0x49, 0x46, 0x38])) {
    return 'image/gif';
  }
  if (bytes.length >= 12 &&
      _startsWith(bytes, const [0x52, 0x49, 0x46, 0x46]) &&
      bytes[8] == 0x57 &&
      bytes[9] == 0x45 &&
      bytes[10] == 0x42 &&
      bytes[11] == 0x50) {
    return 'image/webp';
  }
  return null;
}

bool _startsWith(List<int> bytes, List<int> signature) {
  if (bytes.length < signature.length) return false;
  for (var i = 0; i < signature.length; i++) {
    if (bytes[i] != signature[i]) return false;
  }
  return true;
}
