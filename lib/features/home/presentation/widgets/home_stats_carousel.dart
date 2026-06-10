import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';

class HomeStatsCarousel extends StatefulWidget {
  const HomeStatsCarousel({super.key});

  @override
  State<HomeStatsCarousel> createState() => _HomeStatsCarouselState();
}

class _HomeStatsCarouselState extends State<HomeStatsCarousel> {
  late final PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 136,
          child: PageView(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: const [
              _StatsSummaryCard(
                stats: [
                  _MetricData(
                    label: 'Media A.',
                    value: '20.01',
                    icon: LucideIcons.calculator,
                  ),
                  _MetricData(
                    label: 'Media P.',
                    value: '20.01',
                    icon: LucideIcons.sigma,
                  ),
                  _MetricData(
                    label: 'Base di L.',
                    value: '90',
                    icon: LucideIcons.graduationCap,
                  ),
                ],
              ),
              _StatsSummaryCard(
                stats: [
                  _MetricData(
                    label: 'CFU',
                    value: '118',
                    icon: LucideIcons.bookOpen,
                  ),
                  _MetricData(
                    label: 'Esami',
                    value: '16',
                    icon: LucideIcons.clipboardCheck,
                  ),
                  _MetricData(
                    label: 'Lodi',
                    value: '2',
                    icon: LucideIcons.star,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _CarouselIndicator(count: 2, currentIndex: _currentIndex),
      ],
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class _StatsSummaryCard extends StatelessWidget {
  const _StatsSummaryCard({required this.stats});

  final List<_MetricData> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: stats.map((item) {
          return Expanded(child: _MetricBubble(data: item));
        }).toList(),
      ),
    );
  }
}

class _MetricBubble extends StatelessWidget {
  const _MetricBubble({required this.data});

  final _MetricData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data.label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cta.withValues(alpha: 0.58),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 8,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(data.icon, size: 16, color: Colors.white),
              const SizedBox(height: 1),
              Text(
                data.value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CarouselIndicator extends StatelessWidget {
  const _CarouselIndicator({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 72 : 10,
          height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: isActive
                ? AppColors.textPrimary
                : AppColors.textPrimary.withValues(alpha: 0.22),
          ),
        );
      }),
    );
  }
}
