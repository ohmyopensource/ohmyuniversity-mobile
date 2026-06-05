import 'package:flutter/material.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/widgets/academic/academic_statistics_tiles.dart';
import '../../../../../shared/widgets/academic/academic_summary_tiles.dart';
import '../../models/dashboard_widget_option.dart';

class DashboardWidgetContent extends StatelessWidget {
  const DashboardWidgetContent({
    super.key,
    required this.option,
    this.preview = false,
  });

  final DashboardWidgetOption option;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    return switch (option.key) {
      'student' => const StudentIdentityTile(),
      'arithmetic_average' => const CareerMetricTile(
        label: 'Media aritmetica',
        value: '25.5',
      ),
      'weighted_average' => const CareerMetricTile(
        label: 'Media Ponderata',
        value: '25.5',
      ),
      'acquired_credits' => const CareerMetricTile(
        label: 'Cfu acquisiti',
        value: '90/180',
        showProgress: true,
        isWide: true,
      ),
      'graduation_projection' => const GraduationProjectionTile(
        value: 90,
        maxValue: 110,
      ),
      'average_trend' => AverageTrendTile(
        points: [
          AcademicAverageTrendPoint(date: DateTime(2026, 5, 23), value: 30),
          AcademicAverageTrendPoint(date: DateTime(2026, 6, 20), value: 28.8),
          AcademicAverageTrendPoint(date: DateTime(2026, 7, 18), value: 27.2),
          AcademicAverageTrendPoint(date: DateTime(2026, 8, 28), value: 25.5),
        ],
      ),
      'exams' => _CompactInfoWidget(
        option: option,
        value: '21',
        caption: 'esami superati',
      ),
      'appeals' => _CompactInfoWidget(
        option: option,
        value: '4',
        caption: 'appelli disponibili',
      ),
      'tuition_fees' => _CompactInfoWidget(
        option: option,
        value: '0',
        caption: 'tasse da pagare',
      ),
      _ => _CompactInfoWidget(
        option: option,
        value: '',
        caption: option.subtitle,
      ),
    };
  }
}

class _CompactInfoWidget extends StatelessWidget {
  const _CompactInfoWidget({
    required this.option,
    required this.value,
    required this.caption,
  });

  final DashboardWidgetOption option;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AcademicSummaryTiles.tileColor,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: option.accentBackgroundColor.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(option.icon, color: AppColors.textPrimary, size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.58),
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          if (value.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
