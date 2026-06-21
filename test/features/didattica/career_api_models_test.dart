import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/didattica/data/models/career_api_models.dart';

void main() {
  test('merges study plan rows with transcript grades and dates', () {
    final transcript = TranscriptResponseModel.fromJson({
      'righe': [
        {
          'adsceId': 10,
          'adCod': 'INF/01',
          'adDes': 'Programmazione',
          'annoCorso': 1,
          'peso': 9,
          'voto': 30,
          'lode': true,
          'dataEsame': '15/02/2026',
          'superata': true,
        },
      ],
    });
    final studyPlan = StudyPlanResponseModel.fromJson({
      'righe': [
        {
          'adsceId': 10,
          'adCod': 'INF/01',
          'adDes': 'Programmazione',
          'annoCorso': 1,
          'cfu': 9,
          'obbligatorio': true,
          'superata': true,
        },
        {
          'adsceId': 11,
          'adCod': 'INF/02',
          'adDes': 'Basi di dati',
          'annoCorso': 2,
          'cfu': 6,
          'obbligatorio': false,
          'superata': false,
        },
      ],
    });

    final courses = studyPlan.mergeTranscript(transcript.courses);

    expect(courses, hasLength(2));
    expect(courses.first.grade, '30L');
    expect(courses.first.completedAt, DateTime(2026, 2, 15));
    expect(courses.last.passed, isFalse);
    expect(courses.last.courseType.name, 'elective');
  });

  test('maps official career metrics', () {
    final metrics = CareerMetricsModel.fromJson({
      'mediaAritmetica': 27.4,
      'mediaPesata': 27.8,
      'baseMax110': 101.93,
      'cfu': 99.0,
      'cfuTotali': 180.0,
    });

    expect(metrics.weightedAverage, 27.8);
    expect(metrics.graduationBase, 101.93);
    expect(metrics.acquiredCredits, 99);
    expect(metrics.totalCredits, 180);
  });
}
