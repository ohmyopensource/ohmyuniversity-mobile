import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';

class OrientationBottomNav extends StatelessWidget {
  const OrientationBottomNav({
    super.key,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrevious,
    required this.onNext,
    required this.onBackToTopics,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.previousLabel = 'Indietro',
    this.nextLabel = 'Avanti',
  });

  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onBackToTopics;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String previousLabel;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.colorNeutral200)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (primaryActionLabel != null && onPrimaryAction != null) ...[
                CustomButtonWidget(
                  label: primaryActionLabel!,
                  icon: LucideIcons.circleHelp,
                  iconPosition: ButtonIconPosition.right,
                  fullWidth: true,
                  onPressed: onPrimaryAction,
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Expanded(
                    child: CustomButtonWidget(
                      label: previousLabel,
                      icon: LucideIcons.arrowLeft,
                      variant: ButtonVariant.outline,
                      disabled: !hasPrevious,
                      fullWidth: true,
                      onPressed: onPrevious,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButtonWidget(
                      label: nextLabel,
                      icon: LucideIcons.arrowRight,
                      iconPosition: ButtonIconPosition.right,
                      disabled: !hasNext,
                      fullWidth: true,
                      onPressed: onNext,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomButtonWidget(
                label: 'Torna a Orientamento',
                icon: LucideIcons.layoutList,
                variant: ButtonVariant.ghost,
                fullWidth: true,
                onPressed: onBackToTopics,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
