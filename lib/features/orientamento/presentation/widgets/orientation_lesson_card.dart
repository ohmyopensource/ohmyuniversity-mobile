import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';

class OrientationLessonCard extends StatefulWidget {
  const OrientationLessonCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.detail,
    this.chips = const [],
    this.tappable = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? detail;
  final List<String> chips;
  final bool tappable;

  @override
  State<OrientationLessonCard> createState() => _OrientationLessonCardState();
}

class _OrientationLessonCardState extends State<OrientationLessonCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final canOpen = widget.tappable && widget.detail != null;
    return CustomCardWidget(
      variant: CardVariant.defaultVariant,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      clickable: canOpen,
      onTap: canOpen ? () => setState(() => _expanded = !_expanded) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.colorPrimaryLight,
                  borderRadius: BorderRadius.circular(AppColors.radiusMd),
                ),
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: AppColors.colorPrimaryText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.colorNeutral500,
                        height: 1.4,
                      ),
                    ),
                    if (canOpen) ...[
                      const SizedBox(height: 7),
                      Text(
                        _expanded ? 'Riduci' : 'Scopri',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.colorPrimaryText,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (_expanded && widget.detail != null) ...[
            const SizedBox(height: 14),
            Text(
              widget.detail!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.colorNeutral600,
                height: 1.45,
              ),
            ),
            if (widget.chips.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: widget.chips
                    .map(
                      (chip) => CustomBadgeWidget(
                        label: chip,
                        variant: BadgeVariant.info,
                        size: BadgeSize.sm,
                        shape: BadgeShape.pill,
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
