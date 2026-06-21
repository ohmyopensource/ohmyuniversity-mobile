import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../providers/career_provider.dart';
import '../widgets/career_charts_section.dart';
import '../widgets/career_statistics_section.dart';
import '../widgets/career_study_plan_section.dart';

class CareerOverviewView extends ConsumerWidget {
  const CareerOverviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(careerProvider);
    final statistics = ref.watch(careerStatisticsProvider);

    return Stack(
      children: [
        ListView(
          key: const Key('career-overview-list'),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 112),
          physics: const BouncingScrollPhysics(),
          children: [
            CareerStatisticsSection(statistics: statistics),
            const SizedBox(height: 28),
            const _SectionTitle(
              icon: LucideIcons.chartNoAxesCombined,
              label: 'Andamento',
            ),
            const SizedBox(height: 10),
            CareerChartsSection(statistics: statistics),
            const SizedBox(height: 28),
            const _SectionTitle(
              icon: LucideIcons.bookOpenCheck,
              label: 'Esami',
            ),
            const SizedBox(height: 10),
            const CareerStudyPlanSection(),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 84,
          child: IgnorePointer(
            ignoring: !state.hasSimulation,
            child: AnimatedScale(
              key: const Key('simulation-mode-indicator'),
              scale: state.hasSimulation ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: CustomBadgeWidget(
                label: 'Modalità simulazione',
                icon: LucideIcons.flaskConical,
                variant: BadgeVariant.secondary,
                size: BadgeSize.lg,
                removable: true,
                semanticLabel: 'Modalità simulazione attiva',
                onRemoved: () {
                  ref.read(careerProvider.notifier).clearSimulations();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.colorNeutral900),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.colorNeutral900,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
