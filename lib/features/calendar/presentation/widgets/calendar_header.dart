import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_tab/custom_tab_widget.dart';
import '../providers/calendar_providers.dart';
import 'calendar_date_labels.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.selectedDate,
    required this.selectedView,
    required this.onViewChanged,
    required this.onOpenDatePicker,
    required this.onBack,
  });

  final DateTime selectedDate;
  final CalendarView selectedView;
  final ValueChanged<CalendarView> onViewChanged;
  final VoidCallback onOpenDatePicker;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
      child: Column(
        children: [
          Row(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _label,
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
          const SizedBox(height: 8),
          CustomTabWidget(
            tabs: const [
              TabItem(id: 'day', label: 'Giorno'),
              TabItem(id: 'month', label: 'Mese'),
              TabItem(id: 'year', label: 'Anno'),
            ],
            activeTab: selectedView.name,
            tabStyle: TabStyle.pill,
            size: TabSize.sm,
            fullWidth: true,
            onTabChange: (value) {
              onViewChanged(CalendarView.values.byName(value));
            },
          ),
        ],
      ),
    );
  }

  String get _label => switch (selectedView) {
    CalendarView.day ||
    CalendarView.month => CalendarDateLabels.fullMonthYear(selectedDate),
    CalendarView.year => selectedDate.year.toString(),
  };
}
