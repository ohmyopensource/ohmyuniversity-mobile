import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../domain/entities/orientation_question_entity.dart';
import '../../providers/orientation_providers.dart';
import '../../widgets/orientation_bottom_nav.dart';

// ─── Colore di sfondo pastel per questa sezione ───────────────────────────────
const _pastelBackground = Color(0xFFEEF2FF); // indigo-50 leggero

// ─── Dati statici ─────────────────────────────────────────────────────────────

class _WeekBlock {
  const _WeekBlock({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.ore,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final String ore;
  final Color color;
}

const _weekBlocks = [
  _WeekBlock(
    icon: LucideIcons.calendar,
    label: 'Lezioni',
    subtitle: 'In aula o da remoto',
    ore: '15–20 ore/sett.',
    color: Color(0xFF1A73E8),
  ),
  _WeekBlock(
    icon: LucideIcons.bookOpen,
    label: 'Studio individuale',
    subtitle: 'Ripasso, esercizi, appunti',
    ore: '20–25 ore/sett.',
    color: Color(0xFF0D9488),
  ),
  _WeekBlock(
    icon: LucideIcons.users,
    label: 'Gruppi di studio',
    subtitle: 'Facoltativo ma molto utile',
    ore: '0–5 ore/sett.',
    color: Color(0xFF34A853),
  ),
  _WeekBlock(
    icon: LucideIcons.zap,
    label: 'Tempo libero e sport',
    subtitle: 'Fondamentale per la produttività',
    ore: '15–20 ore/sett.',
    color: Color(0xFFF59E0B),
  ),
];

class _TimelineTip {
  const _TimelineTip({required this.titolo, required this.testo});

  final String titolo;
  final String testo;
}

const _orariTips = [
  _TimelineTip(
    titolo: 'Niente campanella.',
    testo:
        'A differenza delle superiori, non hai uno scampanellio che scandisce la giornata. Gli orari cambiano ogni giorno e tocca a te tenerne traccia.',
  ),
  _TimelineTip(
    titolo: 'Lezioni a blocchi di 1,5–2 ore.',
    testo:
        'Una lezione universitaria dura spesso 90 o 120 minuti. Sono sessioni più lunghe e intense: impara a concentrarti senza distrarti ogni venti minuti.',
  ),
  _TimelineTip(
    titolo: 'Buchi tra le lezioni.',
    testo:
        'Potresti avere due ore di pausa tra una lezione e l\'altra. Sfruttale per ripassare, non per scrollare il telefono.',
  ),
  _TimelineTip(
    titolo: 'Orari variabili per semestre.',
    testo:
        'L\'orario cambia ogni sei mesi circa. Il primo semestre può essere più intenso del secondo oppure viceversa, dipende dal piano di studi.',
  ),
];

class _StudyTip {
  const _StudyTip({required this.titolo, required this.testo});

  final String titolo;
  final String testo;
}

const _studioTips = [
  _StudyTip(
    titolo: 'Studia subito dopo la lezione.',
    testo:
        'Ripassare entro 24 ore riduce drasticamente il tempo totale di studio prima dell\'esame.',
  ),
  _StudyTip(
    titolo: 'Usa una tecnica attiva.',
    testo:
        'Riassumere, spiegare a voce alta o fare esercizi è più efficace del semplice rileggere gli appunti.',
  ),
  _StudyTip(
    titolo: 'Pianifica la settimana il lunedì.',
    testo:
        'Assegna slot fissi allo studio di ogni materia. Il piano scritto riduce la procrastinazione.',
  ),
];

// ─── Pagina principale ────────────────────────────────────────────────────────

class VitaUniversitariaPage extends ConsumerStatefulWidget {
  const VitaUniversitariaPage({
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
  ConsumerState<VitaUniversitariaPage> createState() =>
      _VitaUniversitariaPageState();
}

class _VitaUniversitariaPageState extends ConsumerState<VitaUniversitariaPage> {
  // Domande per questa sezione (recuperate dalla lista topic)
  late final List<OrientationQuestionEntity> _questions;

  @override
  void initState() {
    super.initState();
    final topics = ref.read(orientationTopicsProvider);
    final topic = topics.firstWhere((t) => t.id == 'vita');
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
            // ── Header progresso ─────────────────────────────────────────────
            _TopicProgressHeader(
              index: widget.activeIndex + 1,
              total: widget.totalTopics,
              title: 'Orari e impegno',
              progress: topicProgress,
              answeredCount: widget.answeredCount,
              totalCount: widget.totalCount,
            ),

            // ── Contenuto scrollabile ─────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Macro-area badge
                  CustomBadgeWidget(
                    label:
                        'Macro-area ${widget.activeIndex + 1} di ${widget.totalTopics}',
                    variant: BadgeVariant.primary,
                    size: BadgeSize.sm,
                    shape: BadgeShape.pill,
                  ),
                  const SizedBox(height: 12),

                  // Titolo sezione
                  Text(
                    'Orari e impegno',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Quante ore occupa davvero l\'università? Molti lo scoprono solo dopo essersi iscritti. Capire come si distribuisce il tempo ti aiuta a pianificare meglio la tua settimana e a evitare di trovarti impreparato a sessione.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Sezione: settimana tipo ───────────────────────────────
                  Text(
                    'Come si distribuisce la settimana',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Uno studente a tempo pieno occupa mediamente 50–60 ore settimanali tra lezioni, studio e attività collegate.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Grid 2×2 dei blocchi orari
                  Row(
                    children: [
                      Expanded(child: _WeekBlockCard(block: _weekBlocks[0])),
                      const SizedBox(width: 10),
                      Expanded(child: _WeekBlockCard(block: _weekBlocks[1])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _WeekBlockCard(block: _weekBlocks[2])),
                      const SizedBox(width: 10),
                      Expanded(child: _WeekBlockCard(block: _weekBlocks[3])),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Sezione: orari delle lezioni (timeline) ───────────────
                  Text(
                    'Gli orari delle lezioni',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Le lezioni universitarie non sono come le ore scolastiche. Ecco cosa cambia davvero.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._orariTips.asMap().entries.map((entry) {
                    final isLast = entry.key == _orariTips.length - 1;
                    return _TimelineStep(tip: entry.value, isLast: isLast);
                  }),
                  const SizedBox(height: 24),

                  // ── Sezione: studio individuale ───────────────────────────
                  Text(
                    'Studio individuale – la vera differenza',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Le lezioni coprono circa un terzo del lavoro reale. Il resto dipende da te e da come organizzi il tempo fuori dall\'aula.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._studioTips.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _StudioTipCard(tip: tip),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Stat highlight 40h / 3x ───────────────────────────────
                  Row(
                    children: const [
                      Expanded(
                        child: _StatHighlight(
                          value: '40h',
                          label: 'di impegno settimanale medio richiesto',
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _StatHighlight(
                          value: '3×',
                          label: 'studio individuale vs ore di lezione',
                          color: Color(0xFF20C997),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),

            // ── Nav inferiore ─────────────────────────────────────────────────
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

// ─── Widget privati ───────────────────────────────────────────────────────────

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

class _WeekBlockCard extends StatelessWidget {
  const _WeekBlockCard({required this.block});

  final _WeekBlock block;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: block.color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(color: block.color.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(block.icon, size: 20, color: block.color),
          const SizedBox(height: 8),
          Text(
            block.label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            block.subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.colorNeutral500,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: block.color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppColors.radiusFull),
            ),
            child: Text(
              block.ore,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: block.color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.tip, required this.isLast});

  final _TimelineTip tip;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                color: AppColors.colorPrimaryDark,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 38, color: AppColors.colorNeutral200),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.titolo,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tip.testo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral500,
                    height: 1.4,
                  ),
                ),
                if (!isLast) const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StudioTipCard extends StatelessWidget {
  const _StudioTipCard({required this.tip});

  final _StudyTip tip;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
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
            size: 18,
            color: AppColors.colorSuccessDark,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.titolo,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tip.testo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral600,
                    height: 1.4,
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

class _StatHighlight extends StatelessWidget {
  const _StatHighlight({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
