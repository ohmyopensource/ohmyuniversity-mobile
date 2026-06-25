import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';

class OrientationProgressBar extends StatelessWidget {
  const OrientationProgressBar({
    super.key,
    required this.answeredCount,
    required this.totalCount,
    required this.progress,
  });

  final int answeredCount;
  final int totalCount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.info,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Il tuo percorso',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              CustomBadgeWidget(
                label: '${(progress * 100).round()}%',
                variant: BadgeVariant.info,
                size: BadgeSize.sm,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppColors.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.colorNeutral200,
              color: AppColors.colorInfoDark,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '$answeredCount di $totalCount risposte · Completamento ${(progress * 100).round()}%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.colorNeutral500,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
