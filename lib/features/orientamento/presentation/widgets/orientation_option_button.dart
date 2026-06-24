import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/orientation_question_entity.dart';

class OrientationOptionButton extends StatelessWidget {
  const OrientationOptionButton({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final OrientationOptionEntity option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: selected ? CardVariant.info : CardVariant.defaultVariant,
      padding: CardPadding.sm,
      shadow: selected ? CardShadow.sm : CardShadow.none,
      radius: CardRadius.md,
      bordered: true,
      clickable: true,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              option.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          if (selected)
            const Icon(
              LucideIcons.check,
              size: 17,
              color: AppColors.colorInfoText,
            ),
        ],
      ),
    );
  }
}
