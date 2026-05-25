import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/datasources/academic_career_mock_datasource.dart';
import '../../data/repositories/academic_career_repository_impl.dart';
import '../../domain/entities/academic_career_entity.dart';
import '../../domain/repositories/academic_career_repository.dart';
import '../../domain/usecases/get_academic_career_usecase.dart';

final academicCareerMockDataSourceProvider =
    Provider<AcademicCareerMockDataSource>((ref) {
      return AcademicCareerMockDataSource();
    });

final academicCareerRepositoryProvider = Provider<AcademicCareerRepository>((
  ref,
) {
  return AcademicCareerRepositoryImpl(
    ref.watch(academicCareerMockDataSourceProvider),
  );
});

final getAcademicCareerUseCaseProvider = Provider<GetAcademicCareerUseCase>((
  ref,
) {
  return GetAcademicCareerUseCase(ref.watch(academicCareerRepositoryProvider));
});

final academicCareerProvider = FutureProvider<AcademicCareerEntity>((ref) {
  return ref.watch(getAcademicCareerUseCaseProvider).call(const NoParams());
});
