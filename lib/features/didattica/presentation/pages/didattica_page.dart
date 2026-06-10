import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../widgets/didattica_quick_actions_section.dart';
import '../widgets/exam_appeals_section.dart';
import '../widgets/exams_section.dart';
import '../widgets/statistics_section.dart';
import '../widgets/student_career_summary_card.dart';

class DidatticaPage extends StatelessWidget {
  const DidatticaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
          physics: const BouncingScrollPhysics(),
          children: [
            const StudentCareerSummaryCard(),
            const SizedBox(height: 22),
            _SectionTitle(
              icon: LucideIcons.barChart3,
              label: 'Statistiche',
              theme: theme,
            ),
            const SizedBox(height: 10),
            const StatisticsSection(),
            const SizedBox(height: 22),
            _SectionTitle(
              icon: LucideIcons.bookOpenCheck,
              label: 'Esami',
              theme: theme,
            ),
            const SizedBox(height: 10),
            const ExamsSection(),
            const SizedBox(height: 22),
            _SectionTitle(
              icon: LucideIcons.calendarDays,
              label: 'Appelli',
              theme: theme,
            ),
            const SizedBox(height: 10),
            const ExamAppealsSection(),
            const SizedBox(height: 22),
            const DidatticaQuickActionsSection(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.label,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textPrimary),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
