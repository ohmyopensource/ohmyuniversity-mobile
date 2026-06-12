import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';
import '../../mocks/app_mock_data.dart';
import '../../../shared/widgets/custom_badge/custom_badge_widget.dart';

abstract final class AcademicSummaryTiles {
  static const tileColor = Color(0xFFFFFEE7);
  static const successColor = Color(0xFF95F2A5);
  static const summaryHeight = 208.0;
}

enum CareerMetricTrend { up, down }

class StudentIdentityTile extends StatefulWidget {
  const StudentIdentityTile({super.key});

  @override
  State<StudentIdentityTile> createState() => _StudentIdentityTileState();
}

class _StudentIdentityTileState extends State<StudentIdentityTile> {
  bool _showBadge = false;

  void _toggleBadge() {
    setState(() => _showBadge = !_showBadge);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleBadge,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: _showBadge ? math.pi : 0),
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOutCubic,
        builder: (context, angle, child) {
          final showBack = angle > math.pi / 2;
          final displayAngle = showBack ? angle - math.pi : angle;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0014)
              ..rotateY(displayAngle),
            child: showBack
                ? const _StudentBadgeBack()
                : const _StudentIdentityFront(),
          );
        },
      ),
    );
  }
}

class CareerMetricsGrid extends StatelessWidget {
  const CareerMetricsGrid({
    super.key,
    this.arithmeticAverage = '25.5',
    this.weightedAverage = '25.5',
    this.acquiredCredits = 90,
    this.totalCredits = 180,
  });

  final String arithmeticAverage;
  final String weightedAverage;
  final int acquiredCredits;
  final int totalCredits;

  @override
  Widget build(BuildContext context) {
    final progressValue = totalCredits == 0
        ? 0.0
        : (acquiredCredits / totalCredits).clamp(0.0, 1.0);

    return SizedBox(
      height: AcademicSummaryTiles.summaryHeight,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CareerMetricTile(
                    label: 'Media aritmetica',
                    value: arithmeticAverage,
                    showTrendBadge: true,
                    trend: CareerMetricTrend.up,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CareerMetricTile(
                    label: 'Media Ponderata',
                    value: weightedAverage,
                    showTrendBadge: true,
                    trend: CareerMetricTrend.down,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: CareerMetricTile(
              label: 'Cfu acquisiti',
              value: '$acquiredCredits/$totalCredits',
              showProgress: true,
              isWide: true,
              progressValue: progressValue,
              progressCaption:
                  '$acquiredCredits CFU completati su $totalCredits',
            ),
          ),
        ],
      ),
    );
  }
}

class CareerMetricTile extends StatelessWidget {
  const CareerMetricTile({
    super.key,
    required this.label,
    required this.value,
    this.showProgress = false,
    this.isWide = false,
    this.progressValue = 0.5,
    this.progressCaption,
    this.showTrendBadge = false,
    this.trend = CareerMetricTrend.up,
  });

  final String label;
  final String value;
  final bool showProgress;
  final bool isWide;
  final double progressValue;
  final String? progressCaption;
  final bool showTrendBadge;
  final CareerMetricTrend trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 14 : 9,
        vertical: isWide ? 12 : 10,
      ),
      decoration: _summaryTileDecoration(alpha: isWide ? 0.06 : 0.06),
      child: isWide
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          height: 1,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FittedBox(
                      child: Text(
                        value,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 7,
                    backgroundColor: Colors.white.withValues(alpha: 0.74),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AcademicSummaryTiles.successColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  progressCaption ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.64),
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 7),
                FittedBox(
                  child: showTrendBadge
                      ? _MetricValue(value: value, trend: trend)
                      : Text(
                          value,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                ),
                if (showProgress) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      minHeight: 5,
                      backgroundColor: Colors.white.withValues(alpha: 0.72),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AcademicSummaryTiles.successColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class CareerAveragePairTile extends StatelessWidget {
  const CareerAveragePairTile({
    super.key,
    required this.arithmeticAverage,
    required this.weightedAverage,
    this.arithmeticTrend = CareerMetricTrend.up,
    this.weightedTrend = CareerMetricTrend.down,
  });

  final String arithmeticAverage;
  final String weightedAverage;
  final CareerMetricTrend arithmeticTrend;
  final CareerMetricTrend weightedTrend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: _summaryTileDecoration(alpha: 0.06),
      child: Row(
        children: [
          Expanded(
            child: _AveragePairColumn(
              label: 'Media aritmetica',
              value: arithmeticAverage,
              trend: arithmeticTrend,
              theme: theme,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: AppColors.textPrimary.withValues(alpha: 0.08),
          ),
          Expanded(
            child: _AveragePairColumn(
              label: 'Media ponderata',
              value: weightedAverage,
              trend: weightedTrend,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

class _AveragePairColumn extends StatelessWidget {
  const _AveragePairColumn({
    required this.label,
    required this.value,
    required this.trend,
    required this.theme,
  });

  final String label;
  final String value;
  final CareerMetricTrend trend;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            height: 1.05,
            fontSize: 9.5,
          ),
        ),
        const SizedBox(height: 7),
        FittedBox(
          child: _MetricValue(value: value, trend: trend),
        ),
      ],
    );
  }
}

class _MetricValue extends StatelessWidget {
  const _MetricValue({required this.value, required this.trend});

  final String value;
  final CareerMetricTrend trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = trend == CareerMetricTrend.up;
    final trendColor = isPositive ? AppColors.examPassed : AppColors.examFailed;

    return Container(
      constraints: const BoxConstraints(minWidth: 74),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.colorPrimaryLight.withValues(alpha: 0.86),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(width: 5),
          Icon(
            isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
            size: 14,
            color: trendColor,
          ),
        ],
      ),
    );
  }
}

class _StudentIdentityFront extends StatelessWidget {
  const _StudentIdentityFront();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _StudentTileSurface(
      child: Column(
        children: [
          Text(
            AppMockData.student.fullName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1.04,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            AppMockData.student.studentId,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            'LODI',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 8.5,
            ),
          ),
          const SizedBox(height: 5),
          // Honors badge.
          CustomBadgeWidget(
            label: '${AppMockData.student.honorsCount}',
            icon: LucideIcons.award,
            variant: BadgeVariant.primary,
            size: BadgeSize.xs,
            shape: BadgeShape.pill,
          ),
          const Spacer(),
          Text(
            'ESAMI',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 8.5,
            ),
          ),
          const SizedBox(height: 5),
          // Passed exams badge.
          CustomBadgeWidget(
            label: '${AppMockData.student.passedExamCount}',
            icon: LucideIcons.checkCircle,
            variant: BadgeVariant.success,
            size: BadgeSize.xs,
            shape: BadgeShape.pill,
          ),
          const SizedBox(height: 6),
          // Failed exams badge.
          CustomBadgeWidget(
            label: '${AppMockData.student.failedExamCount}',
            icon: LucideIcons.xCircle,
            variant: BadgeVariant.neutral,
            size: BadgeSize.xs,
            shape: BadgeShape.pill,
          ),
        ],
      ),
    );
  }
}

class _StudentBadgeBack extends StatelessWidget {
  const _StudentBadgeBack();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _StudentTileSurface(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppMockData.student.fullName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            AppMockData.student.universityName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.72),
              fontWeight: FontWeight.w700,
              height: 1.05,
              fontSize: 8.6,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 78,
            height: 78,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.12),
              ),
            ),
            child: const CustomPaint(painter: _MockQrPainter()),
          ),
          const SizedBox(height: 10),
          Text(
            AppMockData.student.badgeIdLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.68),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentTileSurface extends StatelessWidget {
  const _StudentTileSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AcademicSummaryTiles.summaryHeight,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      decoration: _summaryTileDecoration(alpha: 0.07),
      child: child,
    );
  }
}

class _MockQrPainter extends CustomPainter {
  const _MockQrPainter();

  static const _modules = 21;

  @override
  void paint(Canvas canvas, Size size) {
    final moduleSize = size.shortestSide / _modules;
    final darkPaint = Paint()..color = AppColors.textPrimary;

    void drawModule(int x, int y) {
      canvas.drawRect(
        Rect.fromLTWH(x * moduleSize, y * moduleSize, moduleSize, moduleSize),
        darkPaint,
      );
    }

    void drawFinder(int startX, int startY) {
      for (var y = 0; y < 7; y++) {
        for (var x = 0; x < 7; x++) {
          final isOuter = x == 0 || y == 0 || x == 6 || y == 6;
          final isInner = x >= 2 && x <= 4 && y >= 2 && y <= 4;
          if (isOuter || isInner) drawModule(startX + x, startY + y);
        }
      }
    }

    drawFinder(0, 0);
    drawFinder(14, 0);
    drawFinder(0, 14);

    for (var y = 0; y < _modules; y++) {
      for (var x = 0; x < _modules; x++) {
        final inTopLeft = x < 8 && y < 8;
        final inTopRight = x > 12 && y < 8;
        final inBottomLeft = x < 8 && y > 12;
        if (inTopLeft || inTopRight || inBottomLeft) continue;

        final shouldDraw =
            (x * 7 + y * 11 + x * y) % 5 == 0 || (x + y * 3) % 11 == 0;
        if (shouldDraw) drawModule(x, y);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

BoxDecoration _summaryTileDecoration({required double alpha}) {
  return BoxDecoration(
    color: AcademicSummaryTiles.tileColor,
    borderRadius: BorderRadius.circular(17),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: alpha),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
}
