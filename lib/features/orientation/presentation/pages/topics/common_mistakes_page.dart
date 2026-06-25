import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../domain/entities/orientation_question_entity.dart';
import '../../providers/orientation_providers.dart';
import '../../widgets/orientation_bottom_nav.dart';

const _pastelBackground = Color(0xFFFFF7ED);

class _CommonMistake {
  const _CommonMistake({
    required this.icon,
    required this.titolo,
    required this.perche,
    required this.soluzione,
  });

  final IconData icon;
  final String titolo;
  final String perche;
  final String soluzione;
}

const _commonMistakes = [
  _CommonMistake(
    icon: LucideIcons.sparkles,
    titolo: 'Scegliere per moda',
    perche:
        'Certi corsi diventano "di tendenza" in determinati periodi. Ma se non ti appassionano, il rischio di abbandonare è altissimo.',
    soluzione:
        'Confronta il piano di studi con i tuoi interessi reali. Il mercato del lavoro cambia: punta su ciò che ti motiva davvero.',
  ),
  _CommonMistake(
    icon: LucideIcons.users,
    titolo: 'Seguire gli amici',
    perche:
        'Andare nella stessa università degli amici può sembrare rassicurante. Ma se il corso non è giusto per te, saranno tre anni difficili.',
    soluzione:
        'La scelta universitaria è personale. I tuoi amici avranno i loro percorsi: scegli il tuo con testa.',
  ),
  _CommonMistake(
    icon: LucideIcons.calculator,
    titolo: 'Sottovalutare matematica e teoria',
    perche:
        'Anche corsi apparentemente non tecnici – economia, psicologia, scienze politiche – richiedono statistica e logica.',
    soluzione:
        'Arriva preparato: il primo anno spesso fa la selezione naturale proprio su queste basi.',
  ),
  _CommonMistake(
    icon: LucideIcons.clipboardList,
    titolo: 'Non informarsi sugli esami',
    perche:
        'Molti studenti si iscrivono senza aver mai visto un esame del corso che scelgono. Le sorprese arrivano tardi.',
    soluzione:
        'Cerca su YouTube, chiedi a studenti degli anni superiori, leggi i forum universitari. Sapere cosa ti aspetta è già metà del lavoro.',
  ),
  _CommonMistake(
    icon: LucideIcons.mapPin,
    titolo: 'Ignorare il fattore sede',
    perche:
        'Scegliere un corso senza valutare la città significa ignorare affitti, trasporti, servizi e qualità della vita.',
    soluzione:
        'Calcola il costo reale di vivere in quella città. Simula una settimana tipo prima di decidere.',
  ),
  _CommonMistake(
    icon: LucideIcons.hourglass,
    titolo: 'Non considerare i tempi reali di laurea',
    perche:
        'La laurea "in corso" è l\'eccezione, non la regola: la durata media effettiva supera quella legale di 1–2 anni.',
    soluzione:
        'Pianifica anche gli anni fuori corso nel tuo orizzonte economico e lavorativo. È normale e prevedibile.',
  ),
];

class ErroriComuniPage extends ConsumerStatefulWidget {
  const ErroriComuniPage({
    super.key,
    required this.activeIndex,
    required this.totalTopics,
    required this.answeredCount,
    required this.totalCount,
    required this.onPrevious,
    required this.onNext,
    required this.onBackToTopics,
  });

  final int activeIndex;
  final int totalTopics;
  final int answeredCount;
  final int totalCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onBackToTopics;

  @override
  ConsumerState<ErroriComuniPage> createState() => _ErroriComuniPageState();
}

class _ErroriComuniPageState extends ConsumerState<ErroriComuniPage> {
  late final List<OrientationQuestionEntity> _questions;

  @override
  void initState() {
    super.initState();
    final topics = ref.read(orientationTopicsProvider);
    final topic = topics.firstWhere((t) => t.id == 'errori');
    _questions = topic.questions;
  }

  void _goToQuestions() {
    ref.read(orientationQuestionStageProvider.notifier).showQuestions();
  }

  @override
  Widget build(BuildContext context) {
    final topicProgress = (widget.activeIndex + 1) / widget.totalTopics;

    return Scaffold(
      backgroundColor: _pastelBackground,
      body: SafeArea(
        child: Column(
          children: [
            _TopicProgressHeader(
              index: widget.activeIndex + 1,
              total: widget.totalTopics,
              title: 'Errori comuni',
              progress: topicProgress,
              answeredCount: widget.answeredCount,
              totalCount: widget.totalCount,
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                physics: const BouncingScrollPhysics(),
                children: [
                  CustomBadgeWidget(
                    label:
                        'Macro-area ${widget.activeIndex + 1} di ${widget.totalTopics}',
                    variant: BadgeVariant.primary,
                    size: BadgeSize.sm,
                    shape: BadgeShape.pill,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Errori comuni da evitare',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Questi sono gli errori che fanno quasi tutti, e che è facilissimo evitare se li conosci in anticipo. Ogni errore ha un "perché succede" e una soluzione concreta.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Le trappole più comuni',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sei errori che si ripetono ogni anno tra chi si iscrive senza essersi informato a fondo.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._commonMistakes.map(
                    (errore) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ErrorCard(errore: errore),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            OrientationBottomNav(
              hasPrevious: widget.activeIndex > 0,
              hasNext: widget.activeIndex < widget.totalTopics - 1,
              onPrevious: widget.onPrevious,
              onNext: widget.onNext,
              onBackToTopics: widget.onBackToTopics,
              primaryActionLabel: _questions.isNotEmpty
                  ? 'Vai alle domande'
                  : null,
              onPrimaryAction: _questions.isNotEmpty ? _goToQuestions : null,
            ),
          ],
        ),
      ),
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

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.errore});

  final _CommonMistake errore;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.defaultVariant,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.colorErrorLight,
              borderRadius: BorderRadius.circular(AppColors.radiusMd),
            ),
            child: Icon(errore.icon, size: 18, color: AppColors.colorErrorDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  errore.titolo,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  errore.perche,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                CustomCardWidget(
                  variant: CardVariant.success,
                  padding: CardPadding.sm,
                  shadow: CardShadow.none,
                  radius: CardRadius.md,
                  bordered: false,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        LucideIcons.circleCheck,
                        size: 15,
                        color: AppColors.colorSuccessDark,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          errore.soluzione,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.colorNeutral600,
                                height: 1.4,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
