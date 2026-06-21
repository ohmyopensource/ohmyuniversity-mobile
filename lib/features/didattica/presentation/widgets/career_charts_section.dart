import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/average_trend_point_entity.dart';
import '../../domain/entities/didattica_statistics_entity.dart';

class CareerChartsSection extends StatelessWidget {
  const CareerChartsSection({super.key, required this.statistics});

  final DidatticaStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final charts = [
      _CareerChartCard(
        title: 'Storico voti',
        points: statistics.gradeHistory,
        color: AppColors.colorPrimaryDark,
      ),
      _CareerChartCard(
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

class _CareerChartCard extends StatelessWidget {
  const _CareerChartCard({
    required this.title,
    required this.points,
    required this.color,
  });

  final String title;
  final List<AverageTrendPointEntity> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 236,
      child: CustomCardWidget(
        padding: CardPadding.md,
        shadow: CardShadow.sm,
        stretchHeight: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.colorNeutral900,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: points.isEmpty
                  ? const _EmptyChart()
                  : _LineAreaChart(points: points, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineAreaChart extends StatelessWidget {
  const _LineAreaChart({required this.points, required this.color});

  final List<AverageTrendPointEntity> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final spots = [
      for (var index = 0; index < points.length; index++)
        FlSpot(index.toDouble(), points[index].value),
    ];
    final values = points.map((point) => point.value);
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final minY = math.max(17, minValue - 1).toDouble();
    final maxY = math.min(31, maxValue + 1).toDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: math.max(spots.length - 1, 1).toDouble(),
        minY: minY,
        maxY: maxY == minY ? minY + 1 : maxY,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.colorNeutral900,
            getTooltipItems: (spots) => [
              for (final spot in spots)
                LineTooltipItem(
                  spot.y.toStringAsFixed(2),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: AppColors.colorNeutral200, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: color,
            barWidth: 3,
            isCurved: true,
            curveSmoothness: 0.25,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final isLast = index == spots.length - 1;
                return FlDotCirclePainter(
                  radius: isLast ? 4 : 2.5,
                  color: Colors.white,
                  strokeColor: color,
                  strokeWidth: isLast ? 3 : 2,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: 0.24),
                  color.withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 350),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Nessun voto disponibile',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.colorNeutral400,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
