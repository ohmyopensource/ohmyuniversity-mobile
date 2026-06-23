import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';

class OrientationCfuChart extends StatelessWidget {
  const OrientationCfuChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ChartCard(
      icon: LucideIcons.chartLine,
      title: 'Come si distribuisce lo studio',
      subtitle: 'Esempio orientativo del carico legato ai CFU',
      items: [
        _ChartItem('Lezioni', 0.40, AppColors.colorPrimaryDark),
        _ChartItem('Studio individuale', 0.50, AppColors.colorInfoDark),
        _ChartItem('Esami e prove', 0.10, AppColors.colorSecondaryDark),
      ],
    );
  }
}

class OrientationCareerDirectionsCard extends StatelessWidget {
  const OrientationCareerDirectionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ChartCard(
      icon: LucideIcons.briefcaseBusiness,
      title: 'Possibili direzioni',
      subtitle: 'Ambiti trasversali da esplorare',
      items: [
        _ChartItem('Aziende e consulenza', 0.70, AppColors.colorInfoDark),
        _ChartItem(
          'Pubblica amministrazione',
          0.55,
          AppColors.colorSuccessDark,
        ),
        _ChartItem('Libera professione', 0.45, AppColors.colorSecondaryDark),
        _ChartItem('Ricerca e formazione', 0.40, AppColors.colorWarningDark),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<_ChartItem> items;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.defaultVariant,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.colorPrimaryDark),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.colorNeutral500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final item in items) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.colorNeutral600,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${(item.value * 100).round()}%',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppColors.radiusFull),
              child: LinearProgressIndicator(
                value: item.value,
                minHeight: 7,
                backgroundColor: AppColors.colorNeutral200,
                color: item.color,
              ),
            ),
            if (item != items.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ChartItem {
  const _ChartItem(this.label, this.value, this.color);
  final String label;
  final double value;
  final Color color;
}
