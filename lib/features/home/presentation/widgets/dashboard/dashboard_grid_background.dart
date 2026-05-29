import 'package:flutter/material.dart';

import '../../../../../config/theme/app_colors.dart';

class DashboardGridBackground extends StatelessWidget {
  const DashboardGridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: CustomPaint(
        painter: _DashboardGridPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _DashboardGridPainter extends CustomPainter {
  static const _columns = 4;
  static const _dashLength = 7.0;
  static const _dashGap = 6.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.18)
      ..strokeWidth = 1;
    final cellSize = size.width / _columns;

    for (var x = 0.0; x <= size.width + 0.1; x += cellSize) {
      _drawDashedLine(canvas, Offset(x, 0), Offset(x, size.height), paint);
    }

    for (var y = 0.0; y <= size.height + 0.1; y += cellSize) {
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final delta = end - start;
    final distance = delta.distance;
    final direction = delta / distance;
    var drawn = 0.0;

    while (drawn < distance) {
      final segmentStart = start + direction * drawn;
      final segmentEnd =
          start + direction * (drawn + _dashLength).clamp(0, distance);
      canvas.drawLine(segmentStart, segmentEnd, paint);
      drawn += _dashLength + _dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
