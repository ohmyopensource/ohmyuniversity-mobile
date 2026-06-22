import '../entities/external_services_entity.dart';

abstract interface class ExternalServicesRepository {
  Future<ExternalServicesEntity> getExternalServices();
}
