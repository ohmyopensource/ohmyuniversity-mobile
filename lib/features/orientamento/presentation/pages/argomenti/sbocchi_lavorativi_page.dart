import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../domain/entities/orientation_question_entity.dart';
import '../../providers/orientation_providers.dart';
import '../../widgets/orientation_bottom_nav.dart';
import '../../widgets/orientation_simple_charts.dart';

// ─── Colore di sfondo pastel ──────────────────────────────────────────────────
const _pastelBackground = Color(0xFFE9F6ED); // green-50 leggero

// ─── Dati statici ─────────────────────────────────────────────────────────────

class _CareerArea {
  const _CareerArea({
    required this.area,
    required this.occupazione1anno,
    required this.stipendioMedio,
  });

  final String area;
  final int occupazione1anno;
  final String stipendioMedio;
}

const _careerAreas = [
  _CareerArea(
    area: 'Ingegneria',
    occupazione1anno: 83,
    stipendioMedio: '1.350 €/mese',
  ),
  _CareerArea(
    area: 'Economica',
    occupazione1anno: 76,
    stipendioMedio: '1.200 €/mese',
  ),
  _CareerArea(
    area: 'Scientifica',
    occupazione1anno: 73,
    stipendioMedio: '1.150 €/mese',
  ),
  _CareerArea(
    area: 'Sanitaria',
    occupazione1anno: 89,
    stipendioMedio: '1.400 €/mese',
  ),
  _CareerArea(
    area: 'Umanistica',
    occupazione1anno: 52,
    stipendioMedio: '1.050 €/mese',
  ),
  _CareerArea(
    area: 'Artistica',
    occupazione1anno: 48,
    stipendioMedio: '980 €/mese',
  ),
];

class _CareerTip {
  const _CareerTip({required this.titolo, required this.testo});

  final String titolo;
  final String testo;
}

const _careerTips = [
  _CareerTip(
    titolo: 'I numeri medi nascondono grandi differenze.',
    testo:
        'Lo stesso corso può avere tassi di occupazione molto diversi a seconda dell\'ateneo, della sede e delle competenze acquisite durante il percorso.',
  ),
  _CareerTip(
    titolo: 'Il contesto geografico incide.',
    testo:
        'Una laurea in ingegneria a Milano apre porte diverse rispetto alla stessa laurea in una città più piccola. La rete locale e i tirocini fanno la differenza.',
  ),
  _CareerTip(
    titolo: 'Le competenze trasversali contano.',
    testo:
        'Lingue, capacità di comunicazione, lavoro di squadra e problem solving sono richiesti trasversalmente. Non sottovalutarle durante il percorso universitario.',
  ),
];

// ─── Pagina principale ────────────────────────────────────────────────────────

class SbocchiLavorativiPage extends ConsumerStatefulWidget {
  const SbocchiLavorativiPage({
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
  ConsumerState<SbocchiLavorativiPage> createState() =>
      _SbocchiLavorativiPageState();
}

class _SbocchiLavorativiPageState extends ConsumerState<SbocchiLavorativiPage> {
  late final List<OrientationQuestionEntity> _questions;

  @override
  void initState() {
    super.initState();
    final topics = ref.read(orientationTopicsProvider);
    final topic = topics.firstWhere((t) => t.id == 'sbocchi');
    _questions = topic.questions;
  }

  void _goToQuestions() {
    ref.read(orientationQuestionStageProvider.notifier).showQuestions();
  }

  Color _occupazioneColor(int val) {
    if (val >= 75) return AppColors.colorSuccessDark;
    if (val >= 55) return AppColors.colorWarningDark;
    return AppColors.colorErrorDark;
  }

  BadgeVariant _occupazioneVariant(int val) {
    if (val >= 75) return BadgeVariant.success;
    if (val >= 55) return BadgeVariant.warning;
    return BadgeVariant.error;
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
              title: 'Sbocchi lavorativi',
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
                    'Sbocchi lavorativi',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Prima di scegliere un corso, vale la pena capire cosa succede dopo la laurea. I dati seguenti si basano sul rapporto AlmaLaurea: la fonte più affidabile disponibile gratuitamente in Italia.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Chart occupazione ─────────────────────────────────────
                  Text(
                    'Occupazione a 1 anno dalla laurea',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Percentuale di laureati triennali occupati a 12 mesi, per area di studio.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const OrientationCareerDirectionsCard(),
                  const SizedBox(height: 24),

                  // ── Tabella stipendi ──────────────────────────────────────
                  Text(
                    'Stipendi medi netti al primo impiego',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dati indicativi basati su rilevazioni AlmaLaurea. Il contesto, le competenze trasversali e la sede geografica influenzano significativamente questi valori.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SalaryTable(
                    areas: _careerAreas,
                    occupazioneVariant: _occupazioneVariant,
                  ),
                  const SizedBox(height: 24),

                  // ── Come leggere i dati (timeline) ────────────────────────
                  Text(
                    'Come leggere questi dati',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'I numeri raccontano una parte della storia. Ecco cosa tenere a mente.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._careerTips.asMap().entries.map((entry) {
                    final isLast = entry.key == _careerTips.length - 1;
                    return _TimelineStep(tip: entry.value, isLast: isLast);
                  }),
                  const SizedBox(height: 24),

                  // ── Callout AlmaLaurea ────────────────────────────────────
                  CustomCardWidget(
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
                                'Approfondisci con AlmaLaurea',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Su almalaurea.it puoi cercare dati reali per corso, ateneo e anno di laurea. È lo strumento più affidabile disponibile gratuitamente per valutare gli sbocchi di un corso specifico.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.colorNeutral600,
                                height: 1.4,
                              ),
                        ),
                        const SizedBox(height: 12),
                        // Link esterno visivo
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.colorSuccessDark.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppColors.radiusMd,
                            ),
                            border: Border.all(
                              color: AppColors.colorSuccessDark.withValues(
                                alpha: 0.24,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                LucideIcons.externalLink,
                                size: 14,
                                color: AppColors.colorSuccessDark,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'www.almalaurea.it',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: AppColors.colorSuccessDark,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

class _SalaryTable extends StatelessWidget {
  const _SalaryTable({required this.areas, required this.occupazioneVariant});

  final List<_CareerArea> areas;
  final BadgeVariant Function(int) occupazioneVariant;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppColors.radiusLg),
      child: Table(
        border: TableBorder.all(
          color: AppColors.colorNeutral200,
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
        ),
        columnWidths: const {
          0: FlexColumnWidth(2.2),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.8),
        },
        children: [
          // Header
          TableRow(
            decoration: const BoxDecoration(color: AppColors.colorNeutral100),
            children: [
              _TableHeader('Area'),
              _TableHeader('Occup. 1a'),
              _TableHeader('Stipendio'),
            ],
          ),
          // Righe dati
          ...areas.map(
            (area) => TableRow(
              decoration: const BoxDecoration(color: Colors.white),
              children: [
                _TableCell(
                  child: Text(
                    area.area,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _TableCell(
                  child: CustomBadgeWidget(
                    label: '${area.occupazione1anno}%',
                    variant: occupazioneVariant(area.occupazione1anno),
                    size: BadgeSize.sm,
                    shape: BadgeShape.pill,
                  ),
                ),
                _TableCell(
                  child: Text(
                    area.stipendioMedio,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral600,
                    ),
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

class _TableHeader extends StatelessWidget {
  const _TableHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.colorNeutral500,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: child,
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.tip, required this.isLast});

  final _CareerTip tip;
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
