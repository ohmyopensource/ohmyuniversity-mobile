import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';

class OrientationExpandableCard extends StatefulWidget {
  const OrientationExpandableCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    this.chips = const [],
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final List<String> chips;

  @override
  State<OrientationExpandableCard> createState() =>
      _OrientationExpandableCardState();
}

class _OrientationExpandableCardState extends State<OrientationExpandableCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: _expanded ? CardVariant.info : CardVariant.defaultVariant,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      clickable: true,
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.colorInfoLight,
                    borderRadius: BorderRadius.circular(AppColors.radiusMd),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 19,
                    color: AppColors.colorInfoText,
                  ),
                ),
                const SizedBox(width: 11),
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
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        maxLines: _expanded ? 3 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.colorNeutral500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  size: 18,
                  color: AppColors.colorNeutral500,
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 13),
              Text(
                widget.description,
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
      ),
    );
  }
}
