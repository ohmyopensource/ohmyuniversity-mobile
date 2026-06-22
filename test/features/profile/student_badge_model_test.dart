import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/profile/data/models/student_badge_model.dart';

void main() {
  test('maps the university badge response', () {
    final badge = StudentBadgeModel.fromJson({
      'bdgId': 42,
      'matricola': '123456',
      'cognome': 'Del Muto',
      'nome': 'Alessio',
      'codFis': 'DLM...',
      'codCds': 'INF',
      'desCds': 'Informatica',
      'codFac': 'DIB',
      'desFac': 'Bioscienze e territorio',
      'aaIscrAnn': 2025,
      'rfid': 'RFID-001',
      'universita': 'Università degli Studi del Molise',
      'staStuCod': 'A',
      'dataIni': '01/09/2025',
      'dataFin': '2026-08-31',
      'frontImagePresent': true,
      'rearImagePresent': false,
    });

    expect(badge.badgeId, 42);
    expect(badge.fullName, 'Alessio Del Muto');
    expect(badge.studentNumber, '123456');
    expect(badge.academicYear, 'A.A. 2025/2026');
    expect(badge.validFrom, DateTime(2025, 9, 1));
    expect(badge.validUntil, DateTime(2026, 8, 31));
    expect(badge.frontImagePresent, isTrue);
    expect(badge.rearImagePresent, isFalse);
  });
}
