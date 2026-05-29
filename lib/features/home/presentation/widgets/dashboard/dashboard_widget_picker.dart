import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../config/theme/app_colors.dart';
import 'dashboard_widget_option_tile.dart';

class DashboardWidgetOption {
  const DashboardWidgetOption({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.accentBackgroundColor,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
  final Color accentBackgroundColor;
}

class DashboardWidgetPicker extends StatelessWidget {
  const DashboardWidgetPicker({super.key});

  static const _options = [
    DashboardWidgetOption(
      title: 'Statistiche',
      icon: LucideIcons.barChart3,
      accentColor: Color(0xFF12C7BE),
      accentBackgroundColor: Color(0xFFE7FBFF),
    ),
    DashboardWidgetOption(
      title: 'Card Studente',
      icon: LucideIcons.badgeCheck,
      accentColor: Color(0xFF0E3B43),
      accentBackgroundColor: Color(0xFFEEFDFF),
    ),
    DashboardWidgetOption(
      title: 'Esami',
      icon: LucideIcons.bookOpenCheck,
      accentColor: Color(0xFF5B93AE),
      accentBackgroundColor: Color(0xFFEEFDFF),
    ),
    DashboardWidgetOption(
      title: 'Appelli',
      icon: LucideIcons.calendarDays,
      accentColor: Color(0xFF62A77D),
      accentBackgroundColor: Color(0xFFEFFFEE),
    ),
    DashboardWidgetOption(
      title: 'Piano di studio',
      icon: LucideIcons.calendarDays,
      accentColor: Color(0xFFE9942F),
      accentBackgroundColor: Color(0xFFFFF1E6),
    ),
    DashboardWidgetOption(
      title: 'Tasse da pagare',
      icon: LucideIcons.creditCard,
      accentColor: Color(0xFF14185E),
      accentBackgroundColor: Color(0xFFE7FBFF),
    ),
    DashboardWidgetOption(
      title: 'Amministrativa',
      icon: LucideIcons.clipboardList,
      accentColor: Color(0xFFD7BE21),
      accentBackgroundColor: Color(0xFFFFFCE6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Aggiungi alla home',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _options.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 9),
                  itemBuilder: (context, index) {
                    final option = _options[index];

                    return DashboardWidgetOptionTile(
                      option: option,
                      onTap: () => Navigator.of(context).pop(option),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton.filledTonal(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x),
                  color: AppColors.examFailed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
