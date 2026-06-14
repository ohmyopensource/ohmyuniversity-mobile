import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import 'calendar_date_labels.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.selectedDate,
    required this.onOpenDatePicker,
    required this.onBack,
  });

  final DateTime selectedDate;
  final VoidCallback onOpenDatePicker;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(LucideIcons.arrowLeft),
            color: AppColors.textPrimary,
            iconSize: 22,
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(AppColors.radiusMd),
            onTap: onOpenDatePicker,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    CalendarDateLabels.monthYear(selectedDate),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: AppColors.textPrimary.withValues(alpha: 0.62),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
