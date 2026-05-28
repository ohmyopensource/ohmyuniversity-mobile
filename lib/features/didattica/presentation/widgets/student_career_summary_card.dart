import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';

class StudentCareerSummaryCard extends StatelessWidget {
  const StudentCareerSummaryCard({super.key});

  static const _tileColor = Color(0xFFFFFEE7);
  static const _successColor = Color(0xFF95F2A5);
  static const _summaryHeight = 208.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 14, child: _StudentIdentityTile()),
        SizedBox(width: 10),
        Expanded(flex: 23, child: _CareerMetricsGrid()),
      ],
    );
  }
}

class _StudentIdentityTile extends StatefulWidget {
  const _StudentIdentityTile();

  @override
  State<_StudentIdentityTile> createState() => _StudentIdentityTileState();
}

class _StudentIdentityTileState extends State<_StudentIdentityTile> {
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
            backgroundColor: StudentCareerSummaryCard._tileColor,
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
            backgroundColor: StudentCareerSummaryCard._successColor,
          ),
          const SizedBox(height: 6),
          const _CompactValuePill(
            value: '6',
            icon: LucideIcons.xCircle,
            backgroundColor: StudentCareerSummaryCard._tileColor,
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
      height: StudentCareerSummaryCard._summaryHeight,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      decoration: BoxDecoration(
        color: StudentCareerSummaryCard._tileColor,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
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

class _CareerMetricsGrid extends StatelessWidget {
  const _CareerMetricsGrid();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: StudentCareerSummaryCard._summaryHeight,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _MetricTile(label: 'Media aritmetica', value: '25.5'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _MetricTile(label: 'Media Ponderata', value: '25.5'),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Cfu acquisiti',
                    value: '90/180',
                    showProgress: true,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _MetricTile(label: 'Base di laurea', value: '99'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    this.showProgress = false,
  });

  final String label;
  final String value;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      decoration: BoxDecoration(
        color: StudentCareerSummaryCard._tileColor,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
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
                  StudentCareerSummaryCard._successColor,
                ),
              ),
            ),
          ],
        ],
      ),
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
