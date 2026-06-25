import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/services/data/repositories/external_services_repository_impl.dart';

void main() {
  test(
    'external services mock repository returns the UNIMOL portal links',
    () async {
      const repository = ExternalServicesMockRepository();

    final services = await repository.getExternalServices();

    expect(services.universityId, 'UNIMOL');
    expect(services.moodleUrl?.scheme, 'https');
    expect(services.libraryUrl?.host, contains('unimol'));
      expect(services.studentPortalUrl.toString(), contains('esse3'));
    },
  );
}
