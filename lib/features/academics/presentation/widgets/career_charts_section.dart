import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/academic/academic_history_chart.dart';
import '../../domain/entities/average_trend_point_entity.dart';
import '../../domain/entities/academic_statistics_entity.dart';

class CareerChartsSection extends StatelessWidget {
  const CareerChartsSection({super.key, required this.statistics});

  final AcademicStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final charts = [
      _CareerChart(
        title: 'Storico voti',
        points: statistics.gradeHistory,
        color: AppColors.colorPrimaryDark,
      ),
      _CareerChart(
        title: 'Storico media ponderata',
        points: statistics.averageTrend,
        color: AppColors.colorSecondaryDark,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return Column(
            children: [charts.first, const SizedBox(height: 14), charts.last],
          );
        }
        return Row(
          children: [
            Expanded(child: charts.first),
            const SizedBox(width: 14),
            Expanded(child: charts.last),
          ],
        );
      },
    );
  }
}

class _CareerChart extends StatelessWidget {
  const _CareerChart({
    required this.title,
    required this.points,
    required this.color,
  });

  final String title;
  final List<AverageTrendPointEntity> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 258,
      child: AcademicHistoryChart(
        title: title,
        color: color,
        points: points
            .map(
              (point) =>
                  AcademicHistoryPoint(date: point.date, value: point.value),
            )
            .toList(growable: false),
      ),
    );
  }
}
