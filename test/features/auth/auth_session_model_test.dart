import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/auth/data/models/auth_session_model.dart';

void main() {
  test('maps and serializes the backend login response', () {
    final session = AuthSessionModel.fromJson({
      'accessToken': 'access-token',
      'refreshToken': 'refresh-token',
      'profili': [
        {
          'universityId': 'UNIMOL',
          'universityName': 'Università degli Studi del Molise',
          'stuId': 12,
          'matId': 34,
          'matricola': '178034',
          'corsoNome': 'Informatica',
          'corsoCodice': 'INF',
          'cdsId': 56,
          'tipoCorsoCod': 'L',
          'statusStudente': 'A',
          'statusDescrizione': 'Attivo',
          'annoCorso': 3,
          'durataAnni': 3,
          'annoAccademico': 2025,
          'attivo': true,
        },
      ],
    }, username: 'mario@studenti.unimol.it');

    expect(session.activeProfile?.degreeCourseId, 56);
    expect(session.activeProfile?.enrollmentId, 34);
    expect(session.activeProfile?.courseName, 'Informatica');

    final restored = AuthSessionModel.fromStoredJson(session.toJson());
    expect(restored.accessToken, 'access-token');
    expect(restored.username, 'mario@studenti.unimol.it');
    expect(restored.activeProfile?.studentNumber, '178034');
  });
}
