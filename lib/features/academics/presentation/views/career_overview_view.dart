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

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null) {
      return _CareerErrorState(
        message: state.errorMessage!,
        onRetry: ref.read(careerProvider.notifier).reload,
      );
    }

    return Stack(
      children: [
        ListView(
          key: const Key('career-overview-list'),
          padding: EdgeInsets.fromLTRB(
            16,
            state.hasSimulation ? 62 : 18,
            16,
            112,
          ),
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
          top: 10,
          left: 0,
          right: 0,
          child: IgnorePointer(
            ignoring: !state.hasSimulation,
            child: Center(
              child: AnimatedScale(
                key: const Key('simulation-mode-indicator'),
                scale: state.hasSimulation ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutBack,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
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
            ),
          ),
        ),
      ],
    );
  }
}

class _CareerErrorState extends StatelessWidget {
  const _CareerErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.cloudOff,
              size: 34,
              color: AppColors.colorNeutral400,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.colorNeutral600,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 17),
              label: const Text('Riprova'),
            ),
          ],
        ),
      ),
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
