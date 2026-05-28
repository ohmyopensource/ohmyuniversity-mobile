import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/average_trend_point_entity.dart';
import '../providers/exam_courses_provider.dart';

class StatisticsSection extends ConsumerWidget {
  const StatisticsSection({super.key});

  static const _accentColor = Color(0xFF95F2A5);
  static const _lineColor = Color(0xFFC58444);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(didatticaStatisticsProvider);

    return Column(
      children: [
        _GraduationProjectionCard(
          value: statistics.projectedGraduationBase,
          maxValue: statistics.maxGraduationBase,
        ),
        const SizedBox(height: 14),
        _AverageTrendCard(points: statistics.averageTrend),
      ],
    );
  }
}

class _GraduationProjectionCard extends StatelessWidget {
  const _GraduationProjectionCard({
    required this.value,
    required this.maxValue,
  });

  final double value;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (value / maxValue).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      decoration: _statisticsCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROIEZIONE DI LAUREA',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.45),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toStringAsFixed(2),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '/ ${maxValue.toStringAsFixed(0)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.45),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.textPrimary.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(
                StatisticsSection._accentColor,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Voto finale proiettato',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.38),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AverageTrendCard extends StatelessWidget {
  const _AverageTrendCard({required this.points});

  final List<AverageTrendPointEntity> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spots = [
      for (var index = 0; index < points.length; index++)
        FlSpot(index.toDouble(), points[index].value),
    ];
    final values = points.map((point) => point.value);
    final minY = values.isEmpty ? 18.0 : values.reduce(math.min) - 1;
    final maxY = values.isEmpty ? 30.0 : values.reduce(math.max) + 1;

    return Container(
      width: double.infinity,
      height: 184,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      decoration: _statisticsCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ANDAMENTO MEDIA',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.45),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: math.max(spots.length - 1, 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineTouchData: const LineTouchData(enabled: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.textPrimary.withValues(alpha: 0.08),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    color: StatisticsSection._lineColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: AppColors.background,
                          strokeWidth: 3,
                          strokeColor: StatisticsSection._lineColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: StatisticsSection._lineColor.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _ChartDateLabels(points: points),
        ],
      ),
    );
  }
}

class _ChartDateLabels extends StatelessWidget {
  const _ChartDateLabels({required this.points});

  final List<AverageTrendPointEntity> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final firstDate = points.first.date;
    final lastDate = points.last.date;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _ChartDateLabel(date: firstDate, theme: theme),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: _ChartDateLabel(date: lastDate, theme: theme),
          ),
        ),
      ],
    );
  }
}

class _ChartDateLabel extends StatelessWidget {
  const _ChartDateLabel({required this.date, required this.theme});

  final DateTime date;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDate(date),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelSmall?.copyWith(
        color: AppColors.textPrimary.withValues(alpha: 0.42),
        fontWeight: FontWeight.w700,
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Gen',
      'Feb',
      'Mar',
      'Apr',
      'Mag',
      'Giu',
      'Lug',
      'Ago',
      'Set',
      'Ott',
      'Nov',
      'Dic',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

BoxDecoration _statisticsCardDecoration() {
  return BoxDecoration(
    color: AppColors.background,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.05)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
