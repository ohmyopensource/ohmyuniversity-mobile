import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/auth/data/constants/login_universities.dart';

void main() {
  test('UNIMOL uses the institutional email local part as ESSE3 username', () {
    final unimol = loginUniversities.singleWhere(
      (university) => university.id == 'unimol',
    );

    expect(
      unimol.authenticationUsername(' a.delmuto@studenti.unimol.it '),
      'a.delmuto',
    );
  });
}
