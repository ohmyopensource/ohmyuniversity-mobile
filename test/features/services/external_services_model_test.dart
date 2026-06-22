import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/services/data/models/external_services_model.dart';

void main() {
  test('maps configured external service URLs', () {
    final model = ExternalServicesModel.fromJson({
      'universityId': 'UNIMOL',
      'name': 'Università degli Studi del Molise',
      'moodleUrl': 'https://moodle.unimol.it',
      'libraryUrl': 'https://biblioteche.unimol.it',
    });

    expect(model.universityId, 'UNIMOL');
    expect(model.moodleUrl?.host, 'moodle.unimol.it');
    expect(model.libraryUrl?.host, 'biblioteche.unimol.it');
  });

  test('ignores malformed or empty URLs', () {
    final model = ExternalServicesModel.fromJson({
      'moodleUrl': 'not-a-url',
      'libraryUrl': '',
    });

    expect(model.moodleUrl, isNull);
    expect(model.libraryUrl, isNull);
  });
}
