import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';

abstract final class AcademicSummaryTiles {
  static const tileColor = Color(0xFFFFFEE7);
  static const successColor = Color(0xFF95F2A5);
  static const summaryHeight = 208.0;
}

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
  const CareerMetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AcademicSummaryTiles.summaryHeight,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CareerMetricTile(
                    label: 'Media aritmetica',
                    value: '25.5',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CareerMetricTile(
                    label: 'Media Ponderata',
                    value: '25.5',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: CareerMetricTile(
              label: 'Cfu acquisiti',
              value: '90/180',
              showProgress: true,
              isWide: true,
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
  });

  final String label;
  final String value;
  final bool showProgress;
  final bool isWide;

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
                    value: 0.5,
                    minHeight: 7,
                    backgroundColor: Colors.white.withValues(alpha: 0.74),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AcademicSummaryTiles.successColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '90 CFU completati su 180',
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
                  child: Text(
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
                      value: 0.5,
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

class _StudentIdentityFront extends StatelessWidget {
  const _StudentIdentityFront();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _StudentTileSurface(
      child: Column(
        children: [
          Text(
            'Mario Rossi',
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
            '178034',
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
          const _CompactValuePill(
            value: '2',
            icon: LucideIcons.award,
            backgroundColor: AcademicSummaryTiles.tileColor,
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
          const _CompactValuePill(
            value: '21',
            icon: LucideIcons.checkCircle,
            backgroundColor: AcademicSummaryTiles.successColor,
          ),
          const SizedBox(height: 6),
          const _CompactValuePill(
            value: '6',
            icon: LucideIcons.xCircle,
            backgroundColor: AcademicSummaryTiles.tileColor,
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
            'Mario Rossi',
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
            'Universita degli Studi del Molise',
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
            'ID 178034',
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

class _CompactValuePill extends StatelessWidget {
  const _CompactValuePill({
    required this.value,
    required this.icon,
    required this.backgroundColor,
  });

  final String value;
  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(width: 4),
          Icon(icon, size: 15, color: AppColors.textPrimary),
        ],
      ),
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
