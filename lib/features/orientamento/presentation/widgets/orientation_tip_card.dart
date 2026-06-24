import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';

class OrientationTipCard extends StatelessWidget {
  const OrientationTipCard({
    super.key,
    required this.icon,
    required this.title,
    required this.tips,
    this.variant = CardVariant.defaultVariant,
  });

  final IconData icon;
  final String title;
  final List<String> tips;
  final CardVariant variant;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: variant,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.colorPrimaryText),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final tip in tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: CircleAvatar(
                    radius: 2.5,
                    backgroundColor: AppColors.colorPrimaryDark,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    tip,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            if (tip != tips.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
