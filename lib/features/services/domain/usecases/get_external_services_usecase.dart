import '../entities/external_services_entity.dart';
import '../repositories/external_services_repository.dart';

class GetExternalServicesUseCase {
  const GetExternalServicesUseCase(this._repository);

  final ExternalServicesRepository _repository;

  Future<ExternalServicesEntity> call() {
    return _repository.getExternalServices();
  }
}
