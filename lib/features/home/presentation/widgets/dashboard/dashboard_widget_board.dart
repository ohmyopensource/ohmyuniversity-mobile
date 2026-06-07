import 'package:flutter/material.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../models/dashboard_widget_item.dart';
import 'dashboard_grid_background.dart';
import 'dashboard_placed_widget_tile.dart';

class DashboardWidgetBoard extends StatelessWidget {
  const DashboardWidgetBoard({
    super.key,
    required this.items,
    required this.isEditing,
    required this.onWidgetMoved,
    required this.onWidgetRemoved,
  });

  final List<DashboardWidgetItem> items;
  final bool isEditing;
  final void Function(String id, int columnDelta, int rowDelta) onWidgetMoved;
  final ValueChanged<String> onWidgetRemoved;

  static const _columns = 4;
  static const _tileGap = 10.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = constraints.maxWidth / _columns;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: isEditing
                  ? const DashboardGridBackground()
                  : const ColoredBox(color: AppColors.background),
            ),
            for (final item in items)
              Builder(
                builder: (context) {
                  final areaLeft = item.column * cellSize + (_tileGap / 2);
                  final areaWidth = item.columnSpan * cellSize - _tileGap;
                  final itemWidth = item.columnSpan == _columns
                      ? areaWidth
                      : item.option.size.width.clamp(0, areaWidth).toDouble();
                  final centeredLeft = areaLeft + ((areaWidth - itemWidth) / 2);

                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    left: centeredLeft,
                    top: item.row * cellSize + (_tileGap / 2),
                    width: itemWidth,
                    height: item.option.size.height,
                    child: DashboardPlacedWidgetTile(
                      item: item,
                      cellSize: cellSize,
                      isEditing: isEditing,
                      onMoved: onWidgetMoved,
                      onRemoved: onWidgetRemoved,
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
