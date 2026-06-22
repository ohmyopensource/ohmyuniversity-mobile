import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/providers/network_providers.dart';
import '../../data/datasources/external_services_remote_datasource.dart';
import '../../data/repositories/external_services_repository_impl.dart';
import '../../domain/entities/external_services_entity.dart';
import '../../domain/repositories/external_services_repository.dart';
import '../../domain/usecases/get_external_services_usecase.dart';

const _useMockServices = bool.fromEnvironment('USE_MOCK_SERVICES');

final externalServicesRemoteDataSourceProvider =
    Provider<ExternalServicesRemoteDataSource>((ref) {
      return ExternalServicesRemoteDataSource(ref.watch(apiDioProvider));
    });

final externalServicesRepositoryProvider = Provider<ExternalServicesRepository>(
  (ref) {
    if (_useMockServices) return const ExternalServicesMockRepository();
    return ExternalServicesRepositoryImpl(
      ref.watch(externalServicesRemoteDataSourceProvider),
    );
  },
);

final getExternalServicesUseCaseProvider = Provider<GetExternalServicesUseCase>(
  (ref) {
    return GetExternalServicesUseCase(
      ref.watch(externalServicesRepositoryProvider),
    );
  },
);

final externalServicesProvider = FutureProvider<ExternalServicesEntity>((ref) {
  return ref.watch(getExternalServicesUseCaseProvider).call();
});
