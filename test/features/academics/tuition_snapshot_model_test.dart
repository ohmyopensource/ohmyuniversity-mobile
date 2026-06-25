import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/academics/data/models/tuition_snapshot_model.dart';

void main() {
  test('maps paid, due and overdue tuition charges', () {
    final snapshot = TuitionSnapshotModel.fromJson({
      'semaforo': 'GIALLO',
      'importoDovuto': '450,00',
      'addebiti': [
        {
          'fattId': 1,
          'aaId': 2025,
          'rataDes': 'Prima rata',
          'importoVoce': 450.0,
          'pagatoFlg': 1,
          'dataPagamento': '15/10/2025',
          'annullataFlg': 0,
        },
        {
          'fattId': 2,
          'aaId': 2025,
          'rataDes': 'Seconda rata',
          'importoVoce': 450.0,
          'pagatoFlg': 0,
          'scadutoFlg': 1,
          'scadenzaAddebito': '30/04/2026',
          'annullataFlg': 0,
        },
      ],
    });

    expect(snapshot.totalDue, 450);
    expect(snapshot.fees, hasLength(2));
    expect(snapshot.fees.first.isPaid, isTrue);
    expect(snapshot.fees.first.academicYear, 'A.A. 2025/2026');
    expect(snapshot.fees.last.isOverdue, isTrue);
    expect(snapshot.paidTotal, 450);
    expect(snapshot.academicYearTotal, 900);
  });

  test('uses due-list fallback when accounting charges are absent', () {
    final snapshot = TuitionSnapshotModel.fromJson({
      'importoDovuto': '1.234,50',
      'tasseScadute': [
        {
          'fattId': 7,
          'voceDes': 'Contributo annuale',
          'importoVoce': '1.234,50',
          'dataScadenza': '31/05/2026',
        },
      ],
    });

    expect(snapshot.totalDue, 1234.5);
    expect(snapshot.fees.single.amount, 1234.5);
    expect(snapshot.fees.single.isOverdue, isTrue);
  });
}
