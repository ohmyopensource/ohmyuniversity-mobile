import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/widgets/academic/academic_history_chart.dart';
import '../../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../didattica/domain/entities/average_trend_point_entity.dart';

class HomeCareerProgressWidget extends StatelessWidget {
  const HomeCareerProgressWidget({
    super.key,
    required this.acquiredCredits,
    required this.totalCredits,
    this.compact = false,
  });

  final int acquiredCredits;
  final int totalCredits;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final progress = totalCredits == 0
        ? 0.0
        : (acquiredCredits / totalCredits).clamp(0, 1).toDouble();
    final percent = (progress * 100).round();

    return CustomCardWidget(
      key: const Key('home-career-progress-widget'),
      variant: CardVariant.warning,
      padding: CardPadding.sm,
      shadow: CardShadow.sm,
      stretchHeight: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AVANZAMENTO PERCORSO',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.colorNeutral500,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$acquiredCredits',
                              style: TextStyle(
                                color: AppColors.colorNeutral900,
                                fontSize: compact ? 24 : 28,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                            TextSpan(
                              text: ' / $totalCredits CFU',
                              style: const TextStyle(
                                color: AppColors.colorNeutral500,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: 8),
                CustomBadgeWidget(
                  label: '$percent%',
                  variant: BadgeVariant.warning,
                  size: BadgeSize.sm,
                ),
              ],
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: compact ? 6 : 8,
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

class HomeGraduationProjectionWidget extends StatelessWidget {
  const HomeGraduationProjectionWidget({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final progress = (value / 110).clamp(0, 1).toDouble();
    return CustomCardWidget(
      key: const Key('home-graduation-projection-widget'),
      variant: CardVariant.success,
      padding: CardPadding.sm,
      shadow: CardShadow.sm,
      stretchHeight: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                LucideIcons.graduationCap,
                size: 17,
                color: AppColors.colorSuccessDark,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'PROIEZIONE DI LAUREA',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.colorNeutral500,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.colorNeutral900,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const TextSpan(
                  text: ' / 110',
                  style: TextStyle(
                    color: AppColors.colorNeutral500,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
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
          const Text(
            'Stima sulla media ponderata',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.colorNeutral500,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCareerMetricWidget extends StatelessWidget {
  const HomeCareerMetricWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.suffix = '',
  });

  final String label;
  final String value;
  final String suffix;
  final IconData icon;
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
          Icon(icon, size: 16, color: color),
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
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  if (suffix.isNotEmpty)
                    TextSpan(
                      text: suffix,
                      style: const TextStyle(
                        color: AppColors.colorNeutral500,
                        fontSize: 10,
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
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCareerHistoryWidget extends StatelessWidget {
  const HomeCareerHistoryWidget({
    super.key,
    required this.title,
    required this.points,
    required this.color,
  });

  final String title;
  final List<AverageTrendPointEntity> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AcademicHistoryChart(
      title: title,
      color: color,
      compact: true,
      points: points
          .map(
            (point) =>
                AcademicHistoryPoint(date: point.date, value: point.value),
          )
          .toList(growable: false),
    );
  }
}
