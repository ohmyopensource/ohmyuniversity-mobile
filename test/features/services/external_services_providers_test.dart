import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/services/domain/entities/external_services_entity.dart';
import 'package:ohmyuniversity/features/services/domain/repositories/external_services_repository.dart';
import 'package:ohmyuniversity/features/services/presentation/providers/external_services_providers.dart';

void main() {
  test('external services provider exposes repository data', () async {
    final container = ProviderContainer(
      overrides: [
        externalServicesRepositoryProvider.overrideWithValue(
          const _ExternalServicesRepositoryFake(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final services = await container.read(externalServicesProvider.future);

    expect(services.universityId, 'UNIMOL');
    expect(services.moodleUrl, Uri.parse('https://moodle.example.test'));
    expect(services.studentPortalUrl, Uri.parse('https://portal.example.test'));
  });
}

class _ExternalServicesRepositoryFake implements ExternalServicesRepository {
  const _ExternalServicesRepositoryFake();

  @override
  Future<ExternalServicesEntity> getExternalServices() async {
    return ExternalServicesEntity(
      universityId: 'UNIMOL',
      universityName: 'Universita del Molise',
      moodleUrl: Uri.parse('https://moodle.example.test'),
      libraryUrl: Uri.parse('https://library.example.test'),
      studentPortalUrl: Uri.parse('https://portal.example.test'),
    );
  }
}
