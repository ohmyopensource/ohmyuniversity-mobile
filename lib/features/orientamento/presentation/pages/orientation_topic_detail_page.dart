import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../shared/widgets/custom_toast/custom_toast_service.dart';
import '../../domain/entities/orientation_topic_entity.dart';
import '../providers/orientation_providers.dart';
import '../widgets/orientation_bottom_nav.dart';
import '../widgets/orientation_course_choice_section.dart';
import '../widgets/orientation_expandable_card.dart';
import '../widgets/orientation_geographic_study_section.dart';
import '../widgets/orientation_lesson_card.dart';
import '../widgets/orientation_question_card.dart';
import '../widgets/orientation_simple_charts.dart';
import '../widgets/orientation_university_access_section.dart';
import '../widgets/orientation_how_university_works_section.dart';
import '../widgets/orientation_university_life_section.dart';

class OrientationTopicDetailPage extends ConsumerStatefulWidget {
  const OrientationTopicDetailPage({
    super.key,
    required this.topic,
    required this.activeIndex,
    required this.totalTopics,
    required this.answeredCount,
    required this.totalCount,
    required this.onPrevious,
    required this.onNext,
    required this.onBackToTopics,
    required this.onComplete,
  });

  final OrientationTopicEntity topic;
  final int activeIndex;
  final int totalTopics;
  final int answeredCount;
  final int totalCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onBackToTopics;
  final VoidCallback onComplete;

  @override
  ConsumerState<OrientationTopicDetailPage> createState() =>
      _OrientationTopicDetailPageState();
}

class _OrientationTopicDetailPageState
    extends ConsumerState<OrientationTopicDetailPage> {
  int _currentQuestionIndex = 0;

  OrientationTopicEntity get topic => widget.topic;
  int get activeIndex => widget.activeIndex;
  int get totalTopics => widget.totalTopics;
  int get answeredCount => widget.answeredCount;
  int get totalCount => widget.totalCount;
  VoidCallback get onPrevious => widget.onPrevious;
  VoidCallback get onNext => widget.onNext;
  VoidCallback get onBackToTopics => widget.onBackToTopics;
  VoidCallback get onComplete => widget.onComplete;

  @override
  void didUpdateWidget(covariant OrientationTopicDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topic.id != widget.topic.id) {
      _currentQuestionIndex = 0;
    }
  }

  void _openQuestions() {
    setState(() => _currentQuestionIndex = 0);
    ref.read(orientationQuestionStageProvider.notifier).showQuestions();
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() => _currentQuestionIndex--);
      return;
    }
    ref.read(orientationQuestionStageProvider.notifier).showContent();
  }

  void _nextQuestion(Map<String, Object?> answers) {
    final question = topic.questions[_currentQuestionIndex];
    if (!answers.containsKey(question.id)) {
      ref
          .read(toastServiceProvider.notifier)
          .warning('attenzione, domanda saltata');
    }
    if (_currentQuestionIndex < topic.questions.length - 1) {
      setState(() => _currentQuestionIndex++);
      return;
    }
    ref.read(orientationQuestionStageProvider.notifier).showContent();
    if (activeIndex < totalTopics - 1) {
      onNext();
    } else {
      onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final answers = ref.watch(orientationAnswersProvider);
    final showQuestions = ref.watch(orientationQuestionStageProvider);
    final content = _contentFor(topic.id);
    final topicProgress = (activeIndex + 1) / totalTopics;
    final currentQuestion = showQuestions
        ? topic.questions[_currentQuestionIndex]
        : null;
    final currentQuestionAnswered =
        currentQuestion != null && answers.containsKey(currentQuestion.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopicProgressHeader(
              index: activeIndex + 1,
              total: totalTopics,
              title: topic.title,
              progress: topicProgress,
              answeredCount: answeredCount,
              totalCount: totalCount,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                physics: const BouncingScrollPhysics(),
                children: [
                  if (!showQuestions) ...[
                    CustomBadgeWidget(
                      label: 'Macro-area ${activeIndex + 1} di $totalTopics',
                      variant: BadgeVariant.primary,
                      size: BadgeSize.sm,
                      shape: BadgeShape.pill,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      topic.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      topic.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.colorNeutral500,
                        height: 1.45,
                      ),
                    ),
                    if (topic.id == 'corso') ...[
                      const OrientationCourseChoiceSection(),
                    ] else if (topic.id == 'quiz') ...[
                      const OrientationUniversityAccessSection(),
                    ] else if (topic.id == 'come-funziona') ...[
                      const OrientationHowUniversityWorksSection(),
                    ] else if (topic.id == 'vita') ...[
                      const OrientationUniversityLifeSection(),
                    ] else if (topic.id == 'costi-geografici') ...[
                      const OrientationGeographicStudySection(),
                    ] else ...[
                      for (final lesson in content.lessons) ...[
                        OrientationLessonCard(
                          icon: lesson.icon,
                          title: lesson.title,
                          description: lesson.description,
                          detail: lesson.resolvedDetail,
                          chips: lesson.chips,
                          tappable: true,
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (topic.id == 'come-funziona') ...[
                        const OrientationCfuChart(),
                        const SizedBox(height: 12),
                      ],
                      if (topic.id == 'sbocchi') ...[
                        const OrientationCareerDirectionsCard(),
                        const SizedBox(height: 12),
                      ],
                      for (final item in content.expandables) ...[
                        if (item.sectionTitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.sectionTitle!,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        OrientationExpandableCard(
                          icon: item.icon,
                          title: item.title,
                          subtitle: item.subtitle,
                          description: item.description,
                          chips: item.chips,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                    if (activeIndex == totalTopics - 1) ...[
                      const SizedBox(height: 14),
                      _FinalOrientationCard(
                        onBackToTopics: onBackToTopics,
                        onGoToSummary: onComplete,
                      ),
                    ],
                  ] else ...[
                    const CustomBadgeWidget(
                      label: 'Domande per te',
                      variant: BadgeVariant.info,
                      size: BadgeSize.sm,
                      shape: BadgeShape.pill,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ora tocca a te',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Le risposte aggiornano il tuo profilo di orientamento e il risultato finale.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.colorNeutral500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _QuestionProgress(
                      current: _currentQuestionIndex + 1,
                      total: topic.questions.length,
                    ),
                    const SizedBox(height: 14),
                    OrientationQuestionCard(
                      question: currentQuestion!,
                      selectedValue: answers[currentQuestion.id]?.value,
                      onSelected: (option) {
                        ref
                            .read(orientationControllerProvider.notifier)
                            .saveAnswer(
                              questionId: currentQuestion.id,
                              topicId: topic.id,
                              value: option.value,
                              label: option.label,
                            );
                        ref
                            .read(toastServiceProvider.notifier)
                            .success('Risposta salvata');
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: showQuestions
          ? OrientationBottomNav(
              hasPrevious: true,
              hasNext: true,
              onPrevious: _previousQuestion,
              onNext: () => _nextQuestion(answers),
              nextLabel: _currentQuestionIndex == topic.questions.length - 1
                  ? 'Completa sezione'
                  : currentQuestionAnswered
                  ? 'Salva e continua'
                  : 'Avanti',
              onBackToTopics: onBackToTopics,
            )
          : OrientationBottomNav(
              hasPrevious: activeIndex > 0,
              hasNext: activeIndex < totalTopics - 1,
              onPrevious: onPrevious,
              onNext: onNext,
              onBackToTopics: onBackToTopics,
              primaryActionLabel: topic.questions.isNotEmpty
                  ? 'Vai alle domande'
                  : null,
              onPrimaryAction: topic.questions.isNotEmpty
                  ? _openQuestions
                  : null,
            ),
    );
  }
}

class _FinalOrientationCard extends StatelessWidget {
  const _FinalOrientationCard({
    required this.onBackToTopics,
    required this.onGoToSummary,
  });

  final VoidCallback onBackToTopics;
  final VoidCallback onGoToSummary;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.success,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.circleCheck,
                size: 18,
                color: AppColors.colorSuccessDark,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hai completato la guida all\'orientamento',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Ora hai gli strumenti per fare una scelta consapevole. Rivedi le tue risposte nel riepilogo per scoprire i suggerimenti pensati per te.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.colorNeutral600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          CustomButtonWidget(
            label: 'Rileggi un argomento',
            variant: ButtonVariant.outline,
            fullWidth: true,
            onPressed: onBackToTopics,
          ),
          const SizedBox(height: 8),
          CustomButtonWidget(
            label: 'Vai al riepilogo',
            icon: LucideIcons.clipboardList,
            iconPosition: ButtonIconPosition.right,
            fullWidth: true,
            onPressed: onGoToSummary,
          ),
        ],
      ),
    );
  }
}

class _QuestionProgress extends StatelessWidget {
  const _QuestionProgress({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Domanda $current di $total',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppColors.radiusFull),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 6,
            backgroundColor: AppColors.colorNeutral200,
            color: AppColors.colorInfoDark,
          ),
        ),
      ],
    );
  }
}

class _TopicProgressHeader extends StatelessWidget {
  const _TopicProgressHeader({
    required this.index,
    required this.total,
    required this.title,
    required this.progress,
    required this.answeredCount,
    required this.totalCount,
  });

  final int index;
  final int total;
  final String title;
  final double progress;
  final int answeredCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.colorNeutral200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$index di $total · $title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Completamento ${totalCount == 0 ? 0 : ((answeredCount / totalCount) * 100).round()}%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.colorNeutral500,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppColors.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.colorNeutral200,
              color: AppColors.colorPrimaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicContent {
  const _TopicContent({required this.lessons, required this.expandables});

  final List<_LessonContent> lessons;
  final List<_ExpandableContent> expandables;
}

class _LessonContent {
  const _LessonContent(
    this.icon,
    this.title,
    this.description, {
    this.detail,
    this.chips = const [],
  });

  final IconData icon;
  final String title;
  final String description;
  final String? detail;
  final List<String> chips;

  String get resolvedDetail =>
      detail ??
      '$description\n\nPrima di decidere, verifica questo aspetto sul sito ufficiale del corso e confrontalo con le tue priorità, il tempo disponibile e il metodo di studio che preferisci.';
}

class _ExpandableContent {
  const _ExpandableContent(
    this.icon,
    this.title,
    this.subtitle,
    this.description, [
    this.chips = const [],
    this.sectionTitle,
  ]);

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final List<String> chips;
  final String? sectionTitle;
}

_TopicContent _contentFor(String topicId) {
  return switch (topicId) {
    'corso' => const _TopicContent(
      lessons: [
        _LessonContent(
          LucideIcons.compass,
          'Parti da ciò che ti incuriosisce',
          'Confronta materie, metodo di studio e attività reali del corso, non soltanto il nome.',
          detail:
              'Inizia dagli argomenti che affronti volentieri anche senza essere obbligato. Poi confrontali con gli insegnamenti reali del corso, il metodo di studio richiesto e le attività previste. Il nome di una laurea può essere attraente, ma il piano di studi racconta meglio ciò che farai ogni giorno.',
          chips: ['Interessi', 'Materie', 'Metodo di studio'],
        ),
        _LessonContent(
          LucideIcons.listChecks,
          'Leggi il piano di studi',
          'Controlla gli insegnamenti di tutti gli anni, gli esami obbligatori e le attività a scelta.',
        ),
        _LessonContent(
          LucideIcons.users,
          'Parla con chi lo frequenta',
          'Gli studenti possono raccontarti carico reale, organizzazione e aspetti che le brochure non mostrano.',
        ),
        _LessonContent(
          LucideIcons.mapPin,
          'Valuta anche la sede',
          'Trasporti, servizi, costi e distanza da casa fanno parte della sostenibilità della scelta.',
        ),
      ],
      expandables: [],
    ),
    'quiz' => const _TopicContent(
      lessons: [
        _LessonContent(
          LucideIcons.doorOpen,
          'Accesso libero o programmato',
          'Verifica sempre bando, scadenze e punteggio minimo richiesto dal corso.',
        ),
        _LessonContent(
          LucideIcons.calendarClock,
          'Controlla le scadenze',
          'Iscrizione al test, graduatorie e immatricolazione hanno date diverse e non sempre prorogabili.',
        ),
        _LessonContent(
          LucideIcons.bookOpenCheck,
          'Preparati con simulazioni',
          'Usa il syllabus ufficiale e prove complete per capire su quali argomenti devi lavorare.',
        ),
      ],
      expandables: [
        _ExpandableContent(
          LucideIcons.fileQuestion,
          'TOLC',
          'Il test cambia in base all’area scelta',
          'I TOLC valutano conoscenze iniziali e possono essere richiesti anche nei corsi ad accesso libero.',
          ['TOLC-I', 'TOLC-E', 'TOLC-S', 'TOLC-SU', 'TOLC-F'],
        ),
      ],
    ),
    'come-funziona' => const _TopicContent(
      lessons: [
        _LessonContent(
          LucideIcons.graduationCap,
          'Dalla scuola all’università',
          'Aumentano autonomia e responsabilità: sei tu a organizzare lezioni, studio ed esami.',
        ),
        _LessonContent(
          LucideIcons.chartNoAxesColumnIncreasing,
          'Che cosa sono i CFU',
          'I crediti misurano il carico di lavoro complessivo richiesto da ogni attività formativa.',
        ),
        _LessonContent(
          LucideIcons.filePenLine,
          'Tipi di esame',
          'Prove scritte, orali, pratiche e progetti richiedono strategie di preparazione differenti.',
        ),
        _LessonContent(
          LucideIcons.calendarRange,
          'Sessioni e appelli',
          'Gli esami si concentrano in periodi definiti; ogni sessione offre uno o più appelli.',
        ),
        _LessonContent(
          LucideIcons.personStanding,
          'Autonomia reale',
          'Nessuno controlla ogni giorno il tuo studio: pianificazione e continuità diventano essenziali.',
        ),
      ],
      expandables: [],
    ),
    'vita' => const _TopicContent(
      lessons: [
        _LessonContent(
          LucideIcons.clock3,
          'Organizza la giornata',
          'Alterna lezioni, studio individuale e pause. Una routine sostenibile vale più delle maratone.',
        ),
        _LessonContent(
          LucideIcons.briefcaseBusiness,
          'Studio e lavoro',
          'Se lavori, valuta frequenza obbligatoria, spostamenti e tempo necessario per preparare gli esami.',
        ),
        _LessonContent(
          LucideIcons.calendarDays,
          'Orari non sempre regolari',
          'Lezioni al mattino e al pomeriggio possono lasciare pause lunghe da organizzare in modo utile.',
        ),
        _LessonContent(
          LucideIcons.focus,
          'Lo studio individuale conta di più',
          'Le lezioni sono solo una parte del lavoro: ripasso, esercizi e preparazione dipendono da te.',
        ),
      ],
      expandables: [],
    ),
    'sbocchi' => const _TopicContent(
      lessons: [
        _LessonContent(
          LucideIcons.target,
          'Non esiste un solo mestiere',
          'Lo stesso corso può aprire percorsi diversi: cerca ruoli, competenze richieste e possibilità di crescita.',
        ),
        _LessonContent(
          LucideIcons.chartLine,
          'Leggi i dati con cautela',
          'Occupazione e stipendio cambiano per territorio, esperienza, settore e competenze personali.',
        ),
        _LessonContent(
          LucideIcons.searchCheck,
          'Usa fonti affidabili',
          'AlmaLaurea permette di confrontare occupazione e prosecuzione degli studi per corso e ateneo.',
        ),
      ],
      expandables: [
        _ExpandableContent(
          LucideIcons.building2,
          'Contesti lavorativi',
          'Azienda, pubblico, startup o libera professione',
          'Ogni ambiente offre ritmi, responsabilità e opportunità differenti. Considera ciò che conta davvero per te.',
          ['Azienda', 'Startup', 'Pubblico', 'Freelance'],
        ),
      ],
    ),
    'errori' => const _TopicContent(
      lessons: [
        _LessonContent(
          LucideIcons.triangleAlert,
          'Non scegliere solo per il nome',
          'Controlla sempre insegnamenti, modalità d’esame, sedi e testimonianze di studenti reali.',
        ),
        _LessonContent(
          LucideIcons.messageCircleQuestion,
          'Confronta fonti diverse',
          'Open day, docenti, studenti e documenti ufficiali aiutano a ridurre aspettative poco realistiche.',
        ),
        _LessonContent(
          LucideIcons.users,
          'Non scegliere per pressione',
          'Famiglia e amici possono aiutarti, ma la scelta deve restare coerente con interessi e capacità personali.',
        ),
        _LessonContent(
          LucideIcons.badgeAlert,
          'Non ignorare le difficoltà',
          'Informarti sulle materie più impegnative ti permette di prepararti, non di rinunciare in anticipo.',
        ),
        _LessonContent(
          LucideIcons.route,
          'Non fermarti alla prima opzione',
          'Confronta corsi simili e possibili alternative prima di decidere dove immatricolarti.',
        ),
        _LessonContent(
          LucideIcons.timerReset,
          'Non aspettare l’ultimo momento',
          'Test, bandi e richieste di borsa iniziano spesso mesi prima dell’avvio delle lezioni.',
        ),
      ],
      expandables: [],
    ),
    'borse-studio' => const _TopicContent(
      lessons: [
        _LessonContent(
          LucideIcons.walletCards,
          'Calcola il costo reale',
          'Considera tasse, alloggio, trasporti, libri e spese quotidiane prima di scegliere la sede.',
        ),
        _LessonContent(
          LucideIcons.receiptText,
          'Tasse e ISEE',
          'La contribuzione varia in base ad ateneo, reddito e merito. Presentare l’ISEE in tempo è fondamentale.',
        ),
        _LessonContent(
          LucideIcons.house,
          'Costo della vita',
          'Affitto e trasporti incidono più dei libri: confronta quartieri, collegamenti e servizi per studenti.',
        ),
      ],
      expandables: [
        _ExpandableContent(
          LucideIcons.badgeEuro,
          'Borse e agevolazioni',
          'ISEE, merito e servizi regionali',
          'Consulta ogni anno bandi, requisiti e scadenze. Molti sostegni richiedono una domanda dedicata.',
          ['Borsa di studio', 'Alloggio', 'Mensa', 'No tax area'],
        ),
      ],
    ),
    'costi-geografici' => const _TopicContent(
      lessons: [
        _LessonContent(
          LucideIcons.mapPinned,
          'La città fa parte della scelta',
          'Distanza, trasporti, affitti e opportunità incidono sull’esperienza quanto il corso.',
        ),
        _LessonContent(
          LucideIcons.trainFront,
          'Valuta gli spostamenti',
          'Un corso vicino ma mal collegato può richiedere più tempo e costi di una sede apparentemente lontana.',
        ),
        _LessonContent(
          LucideIcons.building,
          'Grande città o centro piccolo',
          'Le grandi città offrono più servizi; i centri piccoli possono garantire costi bassi e ritmi più semplici.',
        ),
      ],
      expandables: [
        _ExpandableContent(
          LucideIcons.map,
          'Nord',
          '750–1.050 €/mese · più opportunità e servizi',
          'Costo medio: 750–1.050 € al mese.\n\nAffitto e alloggio: nelle città maggiori rappresentano la spesa principale; una stanza fuori centro può ridurre il costo.\n\nTrasporti e vita quotidiana: le reti sono spesso estese, ma abbonamenti e servizi hanno prezzi più alti.\n\nVantaggi: offerta formativa ampia, collegamenti e opportunità di tirocinio.\n\nCriticità: affitti elevati e forte domanda di alloggi.\n\nPuò convenire a chi cerca molte opportunità ed è disposto a pianificare con anticipo budget e casa.',
          ['Costo alto', 'Servizi', 'Tirocini', 'Trasporti'],
          'Dove studiare in Italia',
        ),
        _ExpandableContent(
          LucideIcons.map,
          'Centro',
          '600–900 €/mese · equilibrio tra servizi e distanze',
          'Costo medio: 600–900 € al mese.\n\nAffitto e alloggio: cambia molto tra grandi città e centri universitari medi.\n\nTrasporti e vita quotidiana: valuta bene i collegamenti regionali e la distanza tra casa, sede e servizi.\n\nVantaggi: buona offerta culturale e posizione spesso centrale negli spostamenti nazionali.\n\nCriticità: alcune città hanno affitti simili al Nord e quartieri universitari molto richiesti.\n\nPuò convenire a chi cerca un compromesso tra opportunità, costo e collegamenti.',
          ['Costo medio', 'Cultura', 'Collegamenti', 'Servizi'],
        ),
        _ExpandableContent(
          LucideIcons.map,
          'Sud e Isole',
          '450–700 €/mese · costo quotidiano più contenuto',
          'Costo medio: 450–700 € al mese.\n\nAffitto e alloggio: in molti centri è più accessibile, ma verifica sempre disponibilità vicino alle sedi.\n\nTrasporti e vita quotidiana: il costo può essere più basso; collegamenti e frequenza dei mezzi variano molto.\n\nVantaggi: maggiore sostenibilità economica e possibilità di restare vicini alla rete familiare.\n\nCriticità: alcuni spostamenti richiedono più tempo e l’offerta di servizi può essere meno uniforme.\n\nPuò convenire a chi dà priorità al budget e trova un corso coerente con i propri obiettivi.',
          ['Costo contenuto', 'Vicinanza', 'Comunità', 'Budget'],
        ),
        _ExpandableContent(
          LucideIcons.building2,
          'Grande città universitaria',
          'Molti servizi, opportunità e costi più alti',
          'Offre numerosi corsi, biblioteche, eventi, tirocini e reti professionali. Verifica costo reale dell’affitto, tempi degli spostamenti, disponibilità degli alloggi e distanza tra le diverse sedi. Consiglio pratico: simula una settimana tipo, includendo tragitti e spese quotidiane.',
          ['Opportunità', 'Eventi', 'Affitti', 'Distanze'],
          'Città universitarie',
        ),
        _ExpandableContent(
          LucideIcons.building,
          'Città media',
          'Servizi essenziali e ritmi più gestibili',
          'Può offrire un buon equilibrio tra vita universitaria, costi e spostamenti. Verifica la varietà dei servizi, i collegamenti con altre città e le opportunità di tirocinio. Consiglio pratico: controlla se puoi raggiungere a piedi o con una sola linea le sedi che frequenterai.',
          ['Equilibrio', 'Mobilità', 'Servizi', 'Tirocini'],
        ),
        _ExpandableContent(
          LucideIcons.house,
          'Città vicina a casa',
          'Rete familiare e minori costi di trasferimento',
          'Restare vicino può ridurre affitto e complessità organizzativa. Verifica però durata e affidabilità del pendolarismo, frequenza obbligatoria e impatto sulla vita universitaria. Consiglio pratico: calcola il tempo totale settimanale sui mezzi, non soltanto la distanza.',
          ['Pendolarismo', 'Famiglia', 'Risparmio', 'Tempo'],
        ),
        _ExpandableContent(
          LucideIcons.walletCards,
          'Città con costo più basso',
          'Budget sostenibile e maggiore autonomia economica',
          'Un costo inferiore può rendere il percorso più sostenibile, ma va confrontato con qualità del corso, trasporti, servizi e opportunità. Consiglio pratico: prepara un budget mensile completo con affitto, utenze, mensa, libri, trasporti e rientri a casa.',
          ['Budget', 'Affitto', 'Servizi', 'Qualità del corso'],
        ),
      ],
    ),
    _ => const _TopicContent(lessons: [], expandables: []),
  };
}
