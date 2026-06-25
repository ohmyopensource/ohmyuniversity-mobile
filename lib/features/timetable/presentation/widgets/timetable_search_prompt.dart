import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';

class TimetableSearchPrompt extends StatelessWidget {
  const TimetableSearchPrompt({super.key, required this.onSearch});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomCardWidget(
      variant: CardVariant.neutral,
      padding: CardPadding.none,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: true,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 360;
            final copy = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.colorNeutral100,
                    borderRadius: BorderRadius.circular(AppColors.radiusFull),
                  ),
                  child: const Icon(
                    LucideIcons.search,
                    color: AppColors.colorNeutral500,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Non e l\'orario che cercavi?',
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Cerca l\'orario di qualsiasi corso per dipartimento, corso di laurea e semestre.',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.colorNeutral500,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );

            final button = CustomButtonWidget(
              label: 'Cerca orario',
              icon: LucideIcons.search,
              variant: ButtonVariant.info,
              size: ButtonSize.sm,
              fullWidth: true,
              onPressed: onSearch,
            );

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [copy, const SizedBox(height: 12), button],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: copy),
                const SizedBox(width: 14),
                SizedBox(width: 160, child: button),
              ],
            );
          },
        ),
      ),
    );
  }
}
