import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/orientation_question_entity.dart';
import 'orientation_option_button.dart';

class OrientationQuestionCard extends StatelessWidget {
  const OrientationQuestionCard({
    super.key,
    required this.question,
    required this.selectedValue,
    required this.onSelected,
  });

  final OrientationQuestionEntity question;
  final String? selectedValue;
  final ValueChanged<OrientationOptionEntity> onSelected;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.info,
      padding: CardPadding.md,
      shadow: CardShadow.md,
      radius: CardRadius.lg,
      bordered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomBadgeWidget(
            label: 'Una domanda per te',
            variant: BadgeVariant.info,
            size: BadgeSize.sm,
            shape: BadgeShape.pill,
          ),
          const SizedBox(height: 12),
          Text(
            question.text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          for (final option in question.options) ...[
            OrientationOptionButton(
              option: option,
              selected: selectedValue == option.value,
              onTap: () {
                if (selectedValue != option.value) onSelected(option);
              },
            ),
            if (option != question.options.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
