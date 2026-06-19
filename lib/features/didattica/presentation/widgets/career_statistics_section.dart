import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_variants_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/didattica_statistics_entity.dart';

class CareerStatisticsSection extends StatelessWidget {
  const CareerStatisticsSection({super.key, required this.statistics});

  final DidatticaStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              _PathProgressCard(statistics: statistics),
              _GraduationProjectionCard(statistics: statistics),
            ];
            if (constraints.maxWidth < 680) {
              return Column(
                children: [
                  SizedBox(height: 116, child: cards.first),
                  const SizedBox(height: 14),
                  SizedBox(height: 116, child: cards.last),
                ],
              );
            }
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: cards.first),
                  const SizedBox(width: 14),
                  Expanded(child: cards.last),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        _StatisticsGrid(statistics: statistics),
        const SizedBox(height: 14),
        const CardStatusWidget(
          statusVariant: StatusVariant.info,
          icon: LucideIcons.info,
          description:
              'La media ponderata considera i CFU di ogni esame; la base '
              'di laurea è (media ponderata / 30) × 110. Le lodi valgono '
              '30 nella media e sono conteggiate separatamente.',
          padding: CardPadding.sm,
          shadow: CardShadow.none,
        ),
      ],
    );
  }
}

class _PathProgressCard extends StatelessWidget {
  const _PathProgressCard({required this.statistics});

  final DidatticaStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final percent = (statistics.completionProgress * 100).round();

    return CustomCardWidget(
      key: const Key('career-path-progress-card'),
      variant: CardVariant.warning,
      padding: CardPadding.sm,
      shadow: CardShadow.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AVANZAMENTO PERCORSO',
                      style: const TextStyle(
                        color: AppColors.colorNeutral500,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${statistics.acquiredCredits}',
                            style: const TextStyle(
                              color: AppColors.colorNeutral900,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          TextSpan(
                            text: ' / ${statistics.totalCredits} CFU',
                            style: const TextStyle(
                              color: AppColors.colorNeutral500,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CustomBadgeWidget(
                label: '$percent%',
                variant: BadgeVariant.warning,
                size: BadgeSize.md,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              key: const Key('career-progress'),
              value: statistics.completionProgress,
              minHeight: 8,
              backgroundColor: AppColors.colorNeutral100,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.colorWarningDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GraduationProjectionCard extends StatelessWidget {
  const _GraduationProjectionCard({required this.statistics});

  final DidatticaStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final progress = (statistics.projectedGraduationScore / 110)
        .clamp(0, 1)
        .toDouble();

    return CustomCardWidget(
      key: const Key('career-graduation-projection-card'),
      variant: CardVariant.success,
      padding: CardPadding.sm,
      shadow: CardShadow.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.graduationCap,
                size: 18,
                color: AppColors.colorSuccessDark,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'PROIEZIONE DI LAUREA',
                  maxLines: 1,
                  style: const TextStyle(
                    color: AppColors.colorNeutral500,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: statistics.projectedGraduationScore.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.colorNeutral900,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: ' / 110',
                  style: const TextStyle(
                    color: AppColors.colorNeutral500,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.colorNeutral100,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.colorSuccessDark,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Stima basata sulla media ponderata corrente',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.colorNeutral500,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsGrid extends StatelessWidget {
  const _StatisticsGrid({required this.statistics});

  final DidatticaStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final cards = [
      CardStatWidget(
        key: const Key('arithmetic-average-stat'),
        icon: LucideIcons.calculator,
        value: statistics.arithmeticAverage.toStringAsFixed(1),
        suffix: '/30',
        label: 'Media aritmetica',
        variant: statistics.hasSimulation
            ? CardVariant.secondary
            : CardVariant.info,
        padding: CardPadding.sm,
        shadow: CardShadow.sm,
        stretchHeight: true,
      ),
      CardStatWidget(
        key: const Key('weighted-average-stat'),
        icon: LucideIcons.scale,
        value: statistics.weightedAverage.toStringAsFixed(1),
        suffix: '/30',
        label: 'Media ponderata',
        variant: CardVariant.secondary,
        padding: CardPadding.sm,
        shadow: CardShadow.sm,
        stretchHeight: true,
      ),
      CardStatWidget(
        icon: LucideIcons.graduationCap,
        value: statistics.graduationBase.toStringAsFixed(0),
        suffix: '/110',
        label: 'Base di laurea',
        variant: statistics.hasSimulation
            ? CardVariant.secondary
            : CardVariant.success,
        padding: CardPadding.sm,
        shadow: CardShadow.sm,
        stretchHeight: true,
      ),
      CardStatWidget(
        icon: LucideIcons.sparkles,
        value: '${statistics.honorsCount}',
        label: 'Lodi ottenute',
        variant: CardVariant.warning,
        padding: CardPadding.sm,
        shadow: CardShadow.sm,
        stretchHeight: true,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 780 ? 4 : 2;
        const gap = 12.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        if (constraints.maxWidth < 380) {
          final compactCards = [
            _CompactCareerStat(
              key: const Key('arithmetic-average-stat'),
              icon: LucideIcons.calculator,
              value: statistics.arithmeticAverage.toStringAsFixed(1),
              suffix: '/30',
              label: 'Media aritmetica',
              color: AppColors.colorInfoDark,
            ),
            _CompactCareerStat(
              key: const Key('weighted-average-stat'),
              icon: LucideIcons.scale,
              value: statistics.weightedAverage.toStringAsFixed(1),
              suffix: '/30',
              label: 'Media ponderata',
              color: AppColors.colorSecondaryDark,
            ),
            _CompactCareerStat(
              icon: LucideIcons.graduationCap,
              value: statistics.graduationBase.toStringAsFixed(0),
              suffix: '/110',
              label: 'Base di laurea',
              color: AppColors.colorSuccessDark,
            ),
            _CompactCareerStat(
              icon: LucideIcons.sparkles,
              value: '${statistics.honorsCount}',
              label: 'Lodi ottenute',
              color: AppColors.colorWarningDark,
            ),
          ];
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final card in compactCards)
                SizedBox(width: width, height: 112, child: card),
            ],
          );
        }

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final card in cards)
              SizedBox(width: width, height: 148, child: card),
          ],
        );
      },
    );
  }
}

class _CompactCareerStat extends StatelessWidget {
  const _CompactCareerStat({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.suffix = '',
  });

  final IconData icon;
  final String value;
  final String suffix;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      padding: CardPadding.sm,
      shadow: CardShadow.sm,
      stretchHeight: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: AppColors.colorNeutral900,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (suffix.isNotEmpty)
                    TextSpan(
                      text: suffix,
                      style: const TextStyle(
                        color: AppColors.colorNeutral500,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.colorNeutral500,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
