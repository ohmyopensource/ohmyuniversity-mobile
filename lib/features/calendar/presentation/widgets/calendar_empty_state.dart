import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';

class CalendarEmptyState extends StatelessWidget {
  const CalendarEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.calendarClock,
              size: 42,
              color: AppColors.textPrimary.withValues(alpha: 0.28),
            ),
            const SizedBox(height: 12),
            Text(
              'Nessun evento in programma',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Gli esami, i promemoria e gli eventi compariranno qui.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.58),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
