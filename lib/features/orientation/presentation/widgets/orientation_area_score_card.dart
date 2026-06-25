import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/orientation_result_entity.dart';
import '../utils/orientation_area_style.dart';

class OrientationAreaScoreCard extends StatelessWidget {
  const OrientationAreaScoreCard({
    super.key,
    required this.area,
    required this.position,
  });

  final OrientationAreaScoreEntity area;
  final int position;

  @override
  Widget build(BuildContext context) {
    final style = OrientationStyleHelper.area(area.id);
    return CustomCardWidget(
      variant: position == 1 ? CardVariant.info : CardVariant.defaultVariant,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomBadgeWidget(
                label: '#$position',
                variant: position == 1
                    ? BadgeVariant.info
                    : BadgeVariant.neutral,
                size: BadgeSize.sm,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  area.label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${area.percentage}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: style.textColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppColors.radiusFull),
            child: LinearProgressIndicator(
              value: area.percentage / 100,
              minHeight: 7,
              backgroundColor: AppColors.colorNeutral200,
              color: style.accent,
            ),
          ),
        ],
      ),
    );
  }
}
