import '../domain/entities/orientation_question_entity.dart';
import '../domain/entities/orientation_topic_entity.dart';

abstract final class OrientationStaticData {
  static const topics = <OrientationTopicEntity>[
    OrientationTopicEntity(
      id: 'corso',
      title: 'Scegli il corso adatto a te',
      subtitle: 'Materie, aree e sedi',
      badgeLabel: '1 domanda',
      description: 'Parti dalle aree di studio che senti più vicine.',
      questions: [
        OrientationQuestionEntity(
          id: 'corso-area',
          topicId: 'corso',
          text: 'Quale area di studio ti attira di più?',
          required: true,
          options: [
            OrientationOptionEntity(value: 'umanistica', label: 'Umanistica'),
            OrientationOptionEntity(value: 'scientifica', label: 'Scientifica'),
            OrientationOptionEntity(
              value: 'ingegneria',
              label: 'Ingegneria & Informatica',
            ),
            OrientationOptionEntity(
              value: 'economica',
              label: 'Economica & Giuridica',
            ),
            OrientationOptionEntity(value: 'sanitaria', label: 'Sanitaria'),
            OrientationOptionEntity(
              value: 'artistica',
              label: 'Artistica & Design',
            ),
          ],
        ),
      ],
    ),
    OrientationTopicEntity(
      id: 'quiz',
      title: 'Accesso all’università',
      subtitle: 'TOLC e test di ingresso',
      badgeLabel: '3 domande',
      description: 'Chiarisci modalità di accesso e test richiesti.',
      questions: [
        OrientationQuestionEntity(
          id: 'quiz-access-type',
          topicId: 'quiz',
          text: 'Preferisci un corso a numero chiuso o ad accesso libero?',
          required: true,
          options: [
            OrientationOptionEntity(
              value: 'restricted',
              label: 'Numero chiuso',
            ),
            OrientationOptionEntity(value: 'free', label: 'Accesso libero'),
            OrientationOptionEntity(value: 'undecided', label: 'Non ho deciso'),
          ],
        ),
        OrientationQuestionEntity(
          id: 'quiz-tolc-done',
          topicId: 'quiz',
          text: 'Hai già sostenuto un TOLC?',
          options: [
            OrientationOptionEntity(value: 'yes', label: 'Sì'),
            OrientationOptionEntity(
              value: 'no-planning',
              label: 'No, ma voglio farlo',
            ),
            OrientationOptionEntity(
              value: 'no-unsure',
              label: 'Devo capire quale fare',
            ),
          ],
        ),
        OrientationQuestionEntity(
          id: 'quiz-tolc-type',
          topicId: 'quiz',
          text: 'Quale TOLC hai sostenuto o stai pianificando?',
          options: [
            OrientationOptionEntity(value: 'tolc-med', label: 'TOLC-MED'),
            OrientationOptionEntity(value: 'tolc-i', label: 'TOLC-I'),
            OrientationOptionEntity(value: 'tolc-e', label: 'TOLC-E'),
            OrientationOptionEntity(value: 'tolc-s', label: 'TOLC-S'),
            OrientationOptionEntity(value: 'tolc-su', label: 'TOLC-SU'),
            OrientationOptionEntity(value: 'tolc-f', label: 'TOLC-F'),
          ],
        ),
      ],
    ),
    OrientationTopicEntity(
      id: 'come-funziona',
      title: 'Come funziona l’università',
      subtitle: 'CFU, esami e autonomia',
      badgeLabel: '3 domande',
      description: 'Comprendi il metodo di studio e la gestione degli esami.',
      questions: [
        OrientationQuestionEntity(
          id: 'come-funziona-study-style',
          topicId: 'come-funziona',
          text: 'Come preferisci organizzare il tuo studio?',
          required: true,
          options: [
            OrientationOptionEntity(
              value: 'continuous',
              label: 'Studio con continuità',
            ),
            OrientationOptionEntity(
              value: 'binge',
              label: 'Studio prima degli esami',
            ),
            OrientationOptionEntity(value: 'unsure', label: 'Non lo so ancora'),
          ],
        ),
        OrientationQuestionEntity(
          id: 'come-funziona-esami',
          topicId: 'come-funziona',
          text: 'Che tipo di esame preferisci?',
          options: [
            OrientationOptionEntity(value: 'oral', label: 'Orale'),
            OrientationOptionEntity(value: 'written', label: 'Scritto'),
            OrientationOptionEntity(value: 'mixed', label: 'Misto'),
          ],
        ),
        OrientationQuestionEntity(
          id: 'come-funziona-autonomy',
          topicId: 'come-funziona',
          text: 'Come ti senti rispetto all’autonomia richiesta?',
          options: [
            OrientationOptionEntity(value: 'ready', label: 'Mi sento pronto'),
            OrientationOptionEntity(
              value: 'nervous',
              label: 'Ho qualche preoccupazione',
            ),
            OrientationOptionEntity(
              value: 'unsure',
              label: 'Voglio capire meglio',
            ),
          ],
        ),
      ],
    ),
    OrientationTopicEntity(
      id: 'vita',
      title: 'Orari e impegno',
      subtitle: 'Studio individuale e lavoro',
      badgeLabel: '2 domande',
      description: 'Valuta il tempo che puoi dedicare alla vita universitaria.',
      questions: [
        OrientationQuestionEntity(
          id: 'vita-study-hours',
          topicId: 'vita',
          text: 'Quante ore al giorno puoi dedicare allo studio?',
          required: true,
          options: [
            OrientationOptionEntity(value: 'less-2', label: 'Meno di 2 ore'),
            OrientationOptionEntity(value: '2-4', label: '2-4 ore'),
            OrientationOptionEntity(value: 'more-4', label: 'Più di 4 ore'),
            OrientationOptionEntity(value: 'unsure', label: 'Non lo so ancora'),
          ],
        ),
        OrientationQuestionEntity(
          id: 'vita-work',
          topicId: 'vita',
          text: 'Pensi di lavorare mentre studi?',
          options: [
            OrientationOptionEntity(value: 'yes', label: 'Sì'),
            OrientationOptionEntity(value: 'maybe', label: 'Forse'),
            OrientationOptionEntity(value: 'no', label: 'No'),
          ],
        ),
      ],
    ),
    OrientationTopicEntity(
      id: 'sbocchi',
      title: 'Sbocchi lavorativi',
      subtitle: 'Priorità e contesto lavorativo',
      badgeLabel: '2 domande',
      description: 'Rifletti su cosa cerchi nel tuo futuro professionale.',
      questions: [
        OrientationQuestionEntity(
          id: 'sbocchi-career-priority',
          topicId: 'sbocchi',
          text: 'Cosa conta di più nel lavoro che vorresti fare?',
          required: true,
          options: [
            OrientationOptionEntity(value: 'stability', label: 'Stabilità'),
            OrientationOptionEntity(value: 'growth', label: 'Crescita'),
            OrientationOptionEntity(value: 'passion', label: 'Passione'),
            OrientationOptionEntity(value: 'impact', label: 'Impatto sociale'),
          ],
        ),
        OrientationQuestionEntity(
          id: 'sbocchi-work-context',
          topicId: 'sbocchi',
          text: 'In che ambiente ti immagini a lavorare?',
          options: [
            OrientationOptionEntity(
              value: 'big-company',
              label: 'Grande azienda',
            ),
            OrientationOptionEntity(value: 'startup', label: 'Startup'),
            OrientationOptionEntity(value: 'public', label: 'Settore pubblico'),
            OrientationOptionEntity(value: 'freelance', label: 'Autonomo'),
          ],
        ),
      ],
    ),
    OrientationTopicEntity(
      id: 'errori',
      title: 'Errori comuni da evitare',
      subtitle: 'Dubbi, fonti e piano di studi',
      badgeLabel: '4 domande',
      description: 'Riconosci le trappole più comuni prima di scegliere.',
      questions: [
        OrientationQuestionEntity(
          id: 'errori-confidence',
          topicId: 'errori',
          text: 'Quanto ti senti sicuro della scelta?',
          required: true,
          options: [
            OrientationOptionEntity(value: 'very-sure', label: 'Molto sicuro'),
            OrientationOptionEntity(
              value: 'fairly-sure',
              label: 'Abbastanza sicuro',
            ),
            OrientationOptionEntity(value: 'unsure', label: 'Poco sicuro'),
            OrientationOptionEntity(value: 'confused', label: 'Confuso'),
          ],
        ),
        OrientationQuestionEntity(
          id: 'errori-info-source',
          topicId: 'errori',
          text: 'Da chi hai ricevuto più consigli?',
          required: true,
          options: [
            OrientationOptionEntity(value: 'family', label: 'Famiglia'),
            OrientationOptionEntity(value: 'friends', label: 'Amici'),
            OrientationOptionEntity(value: 'teachers', label: 'Insegnanti'),
            OrientationOptionEntity(value: 'internet', label: 'Internet'),
            OrientationOptionEntity(value: 'alone', label: 'Nessuno'),
          ],
        ),
        OrientationQuestionEntity(
          id: 'errori-talked-to-students',
          topicId: 'errori',
          text: 'Hai parlato con studenti del corso?',
          required: true,
          options: [
            OrientationOptionEntity(value: 'yes', label: 'Sì'),
            OrientationOptionEntity(value: 'no', label: 'No'),
          ],
        ),
        OrientationQuestionEntity(
          id: 'errori-study-plan-check',
          topicId: 'errori',
          text: 'Hai controllato il piano di studi?',
          required: true,
          options: [
            OrientationOptionEntity(
              value: 'thoroughly',
              label: 'Sì, nel dettaglio',
            ),
            OrientationOptionEntity(value: 'briefly', label: 'Solo brevemente'),
            OrientationOptionEntity(value: 'no', label: 'Non ancora'),
          ],
        ),
      ],
    ),
    OrientationTopicEntity(
      id: 'borse-studio',
      title: 'Budget e costi reali',
      subtitle: 'Spese e sostegni disponibili',
      badgeLabel: '2 domande',
      description: 'Stima il budget e gli eventuali supporti necessari.',
      questions: [
        OrientationQuestionEntity(
          id: 'budget-availability',
          topicId: 'borse-studio',
          text: 'Come descriveresti la tua disponibilità economica?',
          required: true,
          options: [
            OrientationOptionEntity(value: 'good', label: 'Buona'),
            OrientationOptionEntity(value: 'limited', label: 'Limitata'),
            OrientationOptionEntity(
              value: 'support',
              label: 'Avrò bisogno di supporto',
            ),
            OrientationOptionEntity(value: 'unsure', label: 'Non lo so ancora'),
          ],
        ),
        OrientationQuestionEntity(
          id: 'budget-monthly',
          topicId: 'borse-studio',
          text: 'Quale budget mensile pensi di avere?',
          options: [
            OrientationOptionEntity(value: 'less-400', label: 'Meno di 400 €'),
            OrientationOptionEntity(value: '400-700', label: '400-700 €'),
            OrientationOptionEntity(value: '700-1000', label: '700-1.000 €'),
            OrientationOptionEntity(
              value: 'more-1000',
              label: 'Più di 1.000 €',
            ),
          ],
        ),
      ],
    ),
    OrientationTopicEntity(
      id: 'costi-geografici',
      title: 'Dove studiare in Italia',
      subtitle: 'Aree, città e costo della vita',
      badgeLabel: '2 domande',
      description: 'Confronta distanza, opportunità e sostenibilità economica.',
      questions: [
        OrientationQuestionEntity(
          id: 'geo-area-preference',
          topicId: 'costi-geografici',
          text: 'In quale area geografica vorresti studiare?',
          required: true,
          options: [
            OrientationOptionEntity(value: 'nord', label: 'Nord'),
            OrientationOptionEntity(value: 'centro', label: 'Centro'),
            OrientationOptionEntity(value: 'sud', label: 'Sud e Isole'),
            OrientationOptionEntity(
              value: 'no-pref',
              label: 'Nessuna preferenza',
            ),
          ],
        ),
        OrientationQuestionEntity(
          id: 'geo-city-priority',
          topicId: 'costi-geografici',
          text: 'Cosa conta di più nella scelta della città?',
          options: [
            OrientationOptionEntity(
              value: 'proximity',
              label: 'Vicinanza a casa',
            ),
            OrientationOptionEntity(
              value: 'job-market',
              label: 'Opportunità lavorative',
            ),
            OrientationOptionEntity(value: 'cost', label: 'Costo della vita'),
            OrientationOptionEntity(
              value: 'social-life',
              label: 'Vita sociale',
            ),
          ],
        ),
      ],
    ),
  ];
}
