import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../widgets/exam_appeals_section.dart';

class AppealsOverviewView extends StatelessWidget {
  const AppealsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('appeals-overview-list'),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 112),
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.calendarDays,
              size: 19,
              color: AppColors.colorNeutral900,
            ),
            const SizedBox(width: 8),
            Text(
              'Appelli',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.colorNeutral900,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          'Consulta gli appelli prenotati e quelli disponibili.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.colorNeutral500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        const ExamAppealsSection(),
      ],
    );
  }
}
