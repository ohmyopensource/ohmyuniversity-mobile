import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/providers/network_providers.dart';
import '../../data/datasources/didattica_remote_datasource.dart';
import '../../data/repositories/didattica_repository_impl.dart';
import '../../domain/entities/career_snapshot_entity.dart';
import '../../domain/repositories/didattica_repository.dart';
import '../../domain/usecases/get_available_exam_bookings_usecase.dart';
import '../../domain/usecases/get_career_snapshot_usecase.dart';
import '../../domain/usecases/get_exam_booking_history_usecase.dart';

final didatticaRemoteDataSourceProvider = Provider<DidatticaRemoteDataSource>((
  ref,
) {
  return DidatticaRemoteDataSource(ref.watch(apiDioProvider));
});

final didatticaRepositoryProvider = Provider<DidatticaRepository>((ref) {
  return DidatticaRepositoryImpl(
    ref.watch(didatticaRemoteDataSourceProvider),
    ref.watch(secureStorageProvider),
  );
});

final getCareerSnapshotUseCaseProvider = Provider<GetCareerSnapshotUseCase>((
  ref,
) {
  return GetCareerSnapshotUseCase(ref.watch(didatticaRepositoryProvider));
});

final getExamBookingHistoryUseCaseProvider =
    Provider<GetExamBookingHistoryUseCase>((ref) {
      return GetExamBookingHistoryUseCase(
        ref.watch(didatticaRepositoryProvider),
      );
    });

final getAvailableExamBookingsUseCaseProvider =
    Provider<GetAvailableExamBookingsUseCase>((ref) {
      return GetAvailableExamBookingsUseCase(
        ref.watch(didatticaRepositoryProvider),
      );
    });

final careerSnapshotProvider = FutureProvider<CareerSnapshotEntity>((ref) {
  return ref.watch(getCareerSnapshotUseCaseProvider).call();
});
