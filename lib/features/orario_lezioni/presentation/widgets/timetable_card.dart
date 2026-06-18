import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/timetable_document_entity.dart';

class TimetableCard extends StatelessWidget {
  const TimetableCard({
    super.key,
    required this.document,
    required this.onView,
    required this.onDownload,
  });

  final TimetableDocumentEntity document;
  final ValueChanged<TimetableDocumentEntity> onView;
  final ValueChanged<TimetableDocumentEntity> onDownload;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomCardWidget(
      variant: CardVariant.info,
      padding: CardPadding.none,
      shadow: CardShadow.md,
      radius: CardRadius.lg,
      bordered: false,
      accentBar: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimaryLight,
                    borderRadius: BorderRadius.circular(AppColors.radiusMd),
                  ),
                  child: const Icon(
                    LucideIcons.calendarClock,
                    color: AppColors.colorPrimaryText,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${document.universityName} - ${document.department}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.colorNeutral500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CustomBadgeWidget(
                  label: document.degreeClass,
                  variant: BadgeVariant.secondary,
                  size: BadgeSize.sm,
                  shape: BadgeShape.pill,
                ),
                CustomBadgeWidget(
                  label: document.academicYear,
                  variant: BadgeVariant.neutral,
                  size: BadgeSize.sm,
                  shape: BadgeShape.pill,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final stackActions = constraints.maxWidth < 340;
                final downloadButton = CustomButtonWidget(
                  label: 'Scarica PDF',
                  icon: LucideIcons.download,
                  variant: ButtonVariant.outline,
                  size: ButtonSize.sm,
                  fullWidth: true,
                  onPressed: () => onDownload(document),
                );
                final viewButton = CustomButtonWidget(
                  label: 'Visualizza online',
                  icon: LucideIcons.externalLink,
                  iconPosition: ButtonIconPosition.right,
                  variant: ButtonVariant.info,
                  size: ButtonSize.sm,
                  fullWidth: true,
                  onPressed: () => onView(document),
                );

                if (stackActions) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (document.hasPdf) ...[
                        downloadButton,
                        const SizedBox(height: 8),
                      ],
                      viewButton,
                    ],
                  );
                }

                return Row(
                  children: [
                    if (document.hasPdf) ...[
                      Expanded(child: downloadButton),
                      const SizedBox(width: 10),
                    ],
                    Expanded(child: viewButton),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
