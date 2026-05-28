import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../widgets/home_deadline_pill.dart';
import '../widgets/home_exam_call_card.dart';
import '../widgets/home_header_background.dart';
import '../widgets/home_quick_action_tile.dart';
import '../widgets/home_stats_carousel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const HomeHeaderBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 42),
                Text(
                  'Ciao, Alessio',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                const HomeStatsCarousel(),
                const SizedBox(height: 26),
                const Row(
                  children: [
                    Expanded(
                      child: HomeQuickActionTile(
                        icon: LucideIcons.medal,
                        label: 'Voti',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: HomeQuickActionTile(
                        icon: LucideIcons.map,
                        label: 'Piano',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: HomeQuickActionTile(
                        icon: LucideIcons.badgeCheck,
                        label: 'Badge',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: HomeQuickActionTile(
                        icon: LucideIcons.newspaper,
                        label: 'News',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Prossimi Appelli',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(
                      child: HomeExamCallCard(
                        title: 'Disponibili',
                        value: '9',
                        icon: LucideIcons.calendarPlus,
                        color: Color(0xFF9ADBD6),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: HomeExamCallCard(
                        title: 'Prenotati',
                        value: '4',
                        icon: LucideIcons.calendarCheck,
                        color: Color(0xFF7BE184),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Scadenze',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                const HomeDeadlinePill(
                  title: 'Tasse da Pagare',
                  value: '0',
                  icon: LucideIcons.receipt,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
