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
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                left: item.column * cellSize + (_tileGap / 2),
                top: item.row * cellSize + (_tileGap / 2),
                width: item.option.size.width,
                height: item.option.size.height,
                child: DashboardPlacedWidgetTile(
                  item: item,
                  cellSize: cellSize,
                  isEditing: isEditing,
                  onMoved: onWidgetMoved,
                  onRemoved: onWidgetRemoved,
                ),
              ),
          ],
        );
      },
    );
  }
}
