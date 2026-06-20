import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../custom_card/custom_card_widget.dart';

class AcademicHistoryPoint {
  const AcademicHistoryPoint({required this.date, required this.value});

  final DateTime date;
  final double value;
}

class AcademicHistoryChart extends StatelessWidget {
  const AcademicHistoryChart({
    super.key,
    required this.title,
    required this.points,
    required this.color,
    this.compact = false,
  });

  final String title;
  final List<AcademicHistoryPoint> points;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      padding: CardPadding.sm,
      shadow: CardShadow.sm,
      stretchHeight: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.colorNeutral900,
              fontSize: compact ? 12.5 : 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (points.isNotEmpty) ...[
            const SizedBox(height: 7),
            _ChartSummary(points: points, color: color, compact: compact),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: points.isEmpty
                ? const _EmptyChart()
                : _HistoryLineChart(
                    points: points,
                    color: color,
                    compact: compact,
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChartSummary extends StatelessWidget {
  const _ChartSummary({
    required this.points,
    required this.color,
    required this.compact,
  });

  final List<AcademicHistoryPoint> points;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final values = points.map((point) => point.value);
    final items = [
      ('Ultimo', points.last.value),
      ('Min', values.reduce(math.min)),
      ('Max', values.reduce(math.max)),
    ];

    return Row(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(width: 6),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 5 : 7,
                vertical: compact ? 3 : 4,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${items[index].$1} ',
                        style: const TextStyle(
                          color: AppColors.colorNeutral500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: items[index].$2.toStringAsFixed(1),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  style: TextStyle(fontSize: compact ? 9.5 : 10.5),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _HistoryLineChart extends StatelessWidget {
  const _HistoryLineChart({
    required this.points,
    required this.color,
    required this.compact,
  });

  final List<AcademicHistoryPoint> points;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final spots = [
      for (var index = 0; index < points.length; index++)
        FlSpot(index.toDouble(), points[index].value),
    ];

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: math.max(spots.length - 1, 1).toDouble(),
        minY: 18,
        maxY: 30.5,
        clipData: const FlClipData(
          top: false,
          right: true,
          bottom: true,
          left: true,
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchSpotThreshold: 24,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes
                .map(
                  (_) => TouchedSpotIndicatorData(
                    FlLine(
                      color: color.withValues(alpha: .35),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                    FlDotData(
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 6,
                            color: Colors.white,
                            strokeColor: color,
                            strokeWidth: 3,
                          ),
                    ),
                  ),
                )
                .toList();
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.colorNeutral900,
            tooltipBorderRadius: BorderRadius.circular(10),
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            tooltipMargin: 10,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.round().clamp(0, points.length - 1);
                final point = points[index];
                return LineTooltipItem(
                  '${index + 1}° esame\n',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: '${point.value.toStringAsFixed(1)} / 30',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: '\n${_formatDate(point.date)}',
                      style: const TextStyle(
                        color: AppColors.colorNeutral300,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 3,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: AppColors.colorNeutral200, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: compact ? 24 : 28,
              interval: 3,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: AppColors.colorNeutral400,
                  fontSize: compact ? 8 : 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: compact ? 20 : 24,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (value != index || index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }
                final step = math.max(
                  1,
                  (points.length / (compact ? 4 : 6)).ceil(),
                );
                if (index % step != 0 && index != points.length - 1) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '${index + 1}°',
                    style: TextStyle(
                      color: AppColors.colorNeutral400,
                      fontSize: compact ? 8 : 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: color,
            barWidth: compact ? 2.5 : 3,
            isCurved: true,
            curveSmoothness: .25,
            isStrokeCapRound: true,
            preventCurveOverShooting: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final isLast = index == spots.length - 1;
                return FlDotCirclePainter(
                  radius: isLast ? 4 : 3,
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
                  color.withValues(alpha: .22),
                  color.withValues(alpha: .02),
                ],
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'gen',
      'feb',
      'mar',
      'apr',
      'mag',
      'giu',
      'lug',
      'ago',
      'set',
      'ott',
      'nov',
      'dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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
