import '../../domain/entities/external_services_entity.dart';
import '../../domain/repositories/external_services_repository.dart';
import '../datasources/external_services_remote_datasource.dart';

class ExternalServicesRepositoryImpl implements ExternalServicesRepository {
  const ExternalServicesRepositoryImpl(this._dataSource);

  final ExternalServicesRemoteDataSource _dataSource;

  @override
  Future<ExternalServicesEntity> getExternalServices() {
    return _dataSource.getExternalServices();
  }
}

class ExternalServicesMockRepository implements ExternalServicesRepository {
  const ExternalServicesMockRepository();

  @override
  Future<ExternalServicesEntity> getExternalServices() async {
    return ExternalServicesEntity(
      universityId: 'UNIMOL',
      universityName: 'Università degli Studi del Molise',
      moodleUrl: Uri.parse('https://learn.unimol.it/'),
      libraryUrl: Uri.parse('https://www3.unimol.it/biblioteche/home'),
      studentPortalUrl: Uri.parse('https://unimol.esse3.cineca.it/Home.do'),
    );
  }
}
