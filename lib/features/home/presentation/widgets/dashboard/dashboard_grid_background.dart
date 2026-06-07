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
  static const _dashLength = 5.0;
  static const _dashGap = 15.0;
  static const _cornerRadius = 18.0;

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / _columns;
    final linePaint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.12)
      ..strokeWidth = 0.9
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final borderPaint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.16)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final gridRect = Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1);
    final borderPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(gridRect, const Radius.circular(_cornerRadius)),
      );

    _drawDashedPath(canvas, borderPath, borderPaint);

    for (var column = 1; column < _columns; column++) {
      final x = column * cellSize;
      _drawDashedLine(canvas, Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (var y = cellSize; y < size.height; y += cellSize) {
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;

      while (distance < metric.length) {
        final nextDistance = distance + _dashLength;
        canvas.drawPath(
          metric.extractPath(distance, nextDistance.clamp(0, metric.length)),
          paint,
        );
        distance += _dashLength + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
