import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/providers/network_providers.dart';
import '../../data/datasources/tuition_remote_datasource.dart';
import '../../data/repositories/tuition_repository_impl.dart';
import '../../domain/entities/tuition_snapshot_entity.dart';
import '../../domain/repositories/tuition_repository.dart';
import '../../domain/usecases/get_tuition_snapshot_usecase.dart';

final tuitionRemoteDataSourceProvider = Provider<TuitionRemoteDataSource>((
  ref,
) {
  return TuitionRemoteDataSource(ref.watch(apiDioProvider));
});

final tuitionRepositoryProvider = Provider<TuitionRepository>((ref) {
  return TuitionRepositoryImpl(ref.watch(tuitionRemoteDataSourceProvider));
});

final getTuitionSnapshotUseCaseProvider = Provider<GetTuitionSnapshotUseCase>((
  ref,
) {
  return GetTuitionSnapshotUseCase(ref.watch(tuitionRepositoryProvider));
});

final tuitionSnapshotProvider = FutureProvider<TuitionSnapshotEntity>((ref) {
  return ref.watch(getTuitionSnapshotUseCaseProvider).call();
});
