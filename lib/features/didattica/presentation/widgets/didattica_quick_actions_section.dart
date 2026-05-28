import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';

class DidatticaQuickActionsSection extends StatelessWidget {
  const DidatticaQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _DidatticaActionButton(
          title: 'Piano di studio',
          icon: LucideIcons.calendarDays,
          routeName: AppRoutes.didatticaStudyPlanName,
          accentColor: Color(0xFFE9942F),
          accentBackgroundColor: Color(0xFFFFF1E6),
        ),
        SizedBox(height: 10),
        _DidatticaActionButton(
          title: 'Tasse da pagare',
          icon: LucideIcons.creditCard,
          routeName: AppRoutes.didatticaTuitionFeesName,
          accentColor: Color(0xFF14185E),
          accentBackgroundColor: Color(0xFFE7FBFF),
        ),
        SizedBox(height: 10),
        _DidatticaActionButton(
          title: 'Amministrativa',
          icon: LucideIcons.clipboardList,
          routeName: AppRoutes.didatticaAdministrativeName,
          accentColor: Color(0xFFD7BE21),
          accentBackgroundColor: Color(0xFFFFFCE6),
        ),
      ],
    );
  }
}

class _DidatticaActionButton extends StatelessWidget {
  const _DidatticaActionButton({
    required this.title,
    required this.icon,
    required this.routeName,
    required this.accentColor,
    required this.accentBackgroundColor,
  });

  final String title;
  final IconData icon;
  final String routeName;
  final Color accentColor;
  final Color accentBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(routeName),
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.textPrimary.withValues(alpha: 0.42),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
