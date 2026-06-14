import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/calendar_event_entity.dart';
import 'calendar_date_labels.dart';
import 'calendar_event_type_ui.dart';

class CalendarEventCard extends StatelessWidget {
  const CalendarEventCard({
    super.key,
    required this.event,
    this.compact = false,
    this.onTap,
  });

  final CalendarEventEntity event;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = event.type.foregroundColor;

    return CustomCardWidget(
      variant: event.type.cardVariant,
      padding: CardPadding.none,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      clickable: onTap != null,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 14,
          vertical: compact ? 10 : 13,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: compact ? 30 : 34,
              height: compact ? 30 : 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: foregroundColor,
                borderRadius: BorderRadius.circular(AppColors.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: foregroundColor.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                event.type.icon,
                size: compact ? 16 : 18,
                color: Colors.white,
              ),
            ),
            SizedBox(width: compact ? 10 : 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                  ),
                  SizedBox(height: compact ? 4 : 7),
                  Text(
                    CalendarDateLabels.eventTimeRange(
                      event.startDate,
                      event.endDate,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: foregroundColor.withValues(alpha: 0.76),
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: compact ? 8 : 10),
            CustomBadgeWidget(
              label: CalendarDateLabels.duration(
                event.startDate,
                event.endDate,
              ),
              variant: event.type.badgeVariant,
              size: BadgeSize.sm,
              shape: BadgeShape.pill,
            ),
          ],
        ),
      ),
    );
  }
}
