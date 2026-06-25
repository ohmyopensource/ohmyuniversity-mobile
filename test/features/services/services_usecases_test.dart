import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/services/domain/entities/external_services_entity.dart';
import 'package:ohmyuniversity/features/services/domain/repositories/external_services_repository.dart';
import 'package:ohmyuniversity/features/services/domain/usecases/get_external_services_usecase.dart';

void main() {
  test('external services use case returns repository data', () async {
    final services = await GetExternalServicesUseCase(
      _ExternalServicesRepositoryFake(),
    ).call();

    expect(services.universityId, 'UNIMOL');
    expect(services.moodleUrl?.host, 'learn.unimol.it');
    expect(services.libraryUrl?.host, 'biblioteche.unimol.it');
  });
}

class _ExternalServicesRepositoryFake implements ExternalServicesRepository {
  @override
  Future<ExternalServicesEntity> getExternalServices() async {
    return ExternalServicesEntity(
      universityId: 'UNIMOL',
      universityName: 'Universita degli Studi del Molise',
      moodleUrl: Uri.parse('https://learn.unimol.it'),
      libraryUrl: Uri.parse('https://biblioteche.unimol.it'),
    );
  }
}
