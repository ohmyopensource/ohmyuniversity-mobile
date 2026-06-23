import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/orientation_topic_entity.dart';

class OrientationTopicCard extends StatelessWidget {
  const OrientationTopicCard({
    super.key,
    required this.topic,
    required this.answeredCount,
    required this.onTap,
  });

  final OrientationTopicEntity topic;
  final int answeredCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final completed = answeredCount == topic.questions.length;

    return CustomCardWidget(
      variant: completed ? CardVariant.success : CardVariant.defaultVariant,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: !completed,
      clickable: true,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: completed
                  ? AppColors.colorSuccessLight
                  : AppColors.colorPrimaryLight,
              borderRadius: BorderRadius.circular(AppColors.radiusMd),
            ),
            child: Icon(
              completed ? LucideIcons.check : LucideIcons.compass,
              size: 19,
              color: completed
                  ? AppColors.colorSuccessText
                  : AppColors.colorPrimaryText,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  topic.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral500,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 9),
                CustomBadgeWidget(
                  label: completed
                      ? 'Completato'
                      : '$answeredCount/${topic.questions.length} risposte',
                  variant: completed
                      ? BadgeVariant.success
                      : BadgeVariant.neutral,
                  size: BadgeSize.xs,
                  shape: BadgeShape.pill,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            LucideIcons.chevronRight,
            size: 18,
            color: AppColors.colorNeutral400,
          ),
        ],
      ),
    );
  }
}
