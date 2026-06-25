import '../entities/orientation_answer_entity.dart';
import '../entities/orientation_result_entity.dart';

class OrientationScoringService {
  const OrientationScoringService();

  static const areaLabels = {
    'umanistica': 'Umanistica',
    'scientifica': 'Scientifica',
    'ingegneria': 'Ingegneria & Informatica',
    'economica': 'Economica & Giuridica',
    'sanitaria': 'Sanitaria',
    'artistica': 'Artistica & del Design',
  };

  static const areaWeights = <String, Map<String, int>>{
    'corso-area:umanistica': {'umanistica': 10},
    'corso-area:scientifica': {'scientifica': 10},
    'corso-area:ingegneria': {'ingegneria': 10},
    'corso-area:economica': {'economica': 10},
    'corso-area:sanitaria': {'sanitaria': 10},
    'corso-area:artistica': {'artistica': 10},
    'quiz-tolc-type:tolc-med': {'sanitaria': 4},
    'quiz-tolc-type:tolc-i': {'ingegneria': 4},
    'quiz-tolc-type:tolc-e': {'economica': 4},
    'quiz-tolc-type:tolc-s': {'scientifica': 4},
    'quiz-tolc-type:tolc-su': {'umanistica': 4},
    'quiz-tolc-type:tolc-f': {'sanitaria': 3},
    'come-funziona-esami:oral': {'umanistica': 2, 'economica': 1},
    'come-funziona-esami:written': {
      'ingegneria': 2,
      'scientifica': 2,
      'economica': 1,
    },
    'sbocchi-career-priority:stability': {
      'sanitaria': 2,
      'ingegneria': 1,
      'economica': 1,
    },
    'sbocchi-career-priority:growth': {'economica': 2, 'ingegneria': 2},
    'sbocchi-career-priority:passion': {'umanistica': 2, 'artistica': 2},
    'sbocchi-career-priority:impact': {'sanitaria': 2, 'umanistica': 1},
    'sbocchi-work-context:big-company': {'ingegneria': 1, 'economica': 1},
    'sbocchi-work-context:startup': {'ingegneria': 1, 'economica': 1},
    'sbocchi-work-context:public': {'umanistica': 1, 'sanitaria': 1},
    'sbocchi-work-context:freelance': {'artistica': 2, 'umanistica': 1},
  };

  static const awarenessPoints = <String, int>{
    'errori-confidence:very-sure': 2,
    'errori-confidence:fairly-sure': 1,
    'errori-confidence:unsure': 0,
    'errori-confidence:confused': -1,
    'errori-talked-to-students:yes': 2,
    'errori-talked-to-students:no': -1,
    'errori-study-plan-check:thoroughly': 2,
    'errori-study-plan-check:briefly': 0,
    'errori-study-plan-check:no': -1,
  };

  OrientationResultEntity calculate(Iterable<OrientationAnswerEntity> answers) {
    final answerList = answers.toList(growable: false);
    final scores = {for (final area in areaLabels.keys) area: 0};
    for (final answer in answerList) {
      final weights = areaWeights['${answer.questionId}:${answer.value}'];
      if (weights == null) continue;
      for (final entry in weights.entries) {
        scores[entry.key] = (scores[entry.key] ?? 0) + entry.value;
      }
    }

    final totalScore = scores.values.fold<int>(0, (sum, score) => sum + score);
    final areas =
        scores.entries
            .map(
              (entry) => OrientationAreaScoreEntity(
                id: entry.key,
                label: areaLabels[entry.key]!,
                score: entry.value,
                percentage: totalScore == 0
                    ? 0
                    : ((entry.value / totalScore) * 100).round(),
              ),
            )
            .toList(growable: false)
          ..sort((first, second) => second.score.compareTo(first.score));

    final awarenessScore = answerList.fold<int>(0, (score, answer) {
      return score +
          (awarenessPoints['${answer.questionId}:${answer.value}'] ?? 0);
    });
    final dominant = areas.first;

    return OrientationResultEntity(
      dominantArea: dominant,
      topAreas: areas.take(3).toList(growable: false),
      awarenessScore: awarenessScore,
      awarenessTips: _awarenessTips(answerList, awarenessScore),
      personalizedTips: _areaTips(dominant.id),
      budgetTips: _budgetTips(answerList),
      estimatedMonthlyBudget: _estimatedBudget(answerList),
    );
  }

  List<String> _awarenessTips(
    List<OrientationAnswerEntity> answers,
    int score,
  ) {
    final values = {
      for (final answer in answers) answer.questionId: answer.value,
    };
    return [
      if (score <= 1)
        'Confronta la tua scelta con fonti ufficiali e persone che conoscono già il corso.',
      if (values['errori-talked-to-students'] == 'no')
        'Parla con almeno uno studente del corso che ti interessa.',
      if (values['errori-study-plan-check'] != 'thoroughly')
        'Leggi nel dettaglio il piano di studi, inclusi esami e insegnamenti opzionali.',
      if (score > 1)
        'Hai già raccolto buone informazioni: verifica ora scadenze e requisiti pratici.',
    ];
  }

  List<String> _areaTips(String area) {
    return switch (area) {
      'umanistica' => [
        'Confronta programmi, lingue richieste e opportunità di tirocinio.',
        'Valuta come integrare competenze comunicative e digitali.',
      ],
      'scientifica' => [
        'Controlla il peso di laboratori, matematica e attività sperimentali.',
        'Cerca corsi con esperienze pratiche e collegamenti con la ricerca.',
      ],
      'ingegneria' => [
        'Confronta i diversi indirizzi e le materie dei primi due anni.',
        'Verifica TOLC, prerequisiti matematici e laboratori disponibili.',
      ],
      'economica' => [
        'Distingui tra percorsi economici, aziendali, finanziari e giuridici.',
        'Valuta stage, lingue e rapporti con aziende del territorio.',
      ],
      'sanitaria' => [
        'Controlla accesso programmato, tirocini obbligatori e sedi formative.',
        'Considera l’impegno pratico e il contatto diretto con le persone.',
      ],
      'artistica' => [
        'Verifica laboratori, portfolio richiesto e qualità degli spazi creativi.',
        'Confronta percorsi accademici e opportunità professionali concrete.',
      ],
      _ => const ['Approfondisci i corsi più coerenti con le tue risposte.'],
    };
  }

  List<String> _budgetTips(List<OrientationAnswerEntity> answers) {
    final values = {
      for (final answer in answers) answer.questionId: answer.value,
    };
    return [
      if (values['budget-availability'] == 'limited' ||
          values['budget-availability'] == 'support')
        'Controlla subito borse regionali, no tax area, alloggi e servizio mensa.',
      'Prepara un budget che includa affitto, trasporti, materiali e spese quotidiane.',
      if (values['budget-monthly'] == 'less-400')
        'Valuta sedi vicine a casa o città con un costo della vita più contenuto.',
    ];
  }

  String? _estimatedBudget(List<OrientationAnswerEntity> answers) {
    String? area;
    for (final answer in answers) {
      if (answer.questionId == 'geo-area-preference') area = answer.value;
    }
    return switch (area) {
      'nord' => '750–1.050 €/mese',
      'centro' => '600–900 €/mese',
      'sud' => '450–700 €/mese',
      _ => null,
    };
  }
}
