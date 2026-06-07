import 'package:flutter/material.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../models/dashboard_widget_item.dart';
import 'dashboard_widget_content.dart';

class DashboardPlacedWidgetTile extends StatefulWidget {
  const DashboardPlacedWidgetTile({
    super.key,
    required this.item,
    required this.cellSize,
    required this.isEditing,
    required this.onMoved,
    required this.onRemoved,
  });

  final DashboardWidgetItem item;
  final double cellSize;
  final bool isEditing;
  final void Function(String id, int columnDelta, int rowDelta) onMoved;
  final ValueChanged<String> onRemoved;

  @override
  State<DashboardPlacedWidgetTile> createState() =>
      _DashboardPlacedWidgetTileState();
}

class _DashboardPlacedWidgetTileState extends State<DashboardPlacedWidgetTile> {
  Offset _dragOffset = Offset.zero;

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!widget.isEditing) return;

    setState(() => _dragOffset += details.delta);
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!widget.isEditing) return;

    final columnDelta = (_dragOffset.dx / widget.cellSize).round();
    final rowDelta = (_dragOffset.dy / widget.cellSize).round();

    setState(() => _dragOffset = Offset.zero);

    if (columnDelta == 0 && rowDelta == 0) return;
    widget.onMoved(widget.item.id, columnDelta, rowDelta);
  }

  void _handlePanCancel() {
    if (!widget.isEditing) return;
    setState(() => _dragOffset = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _dragOffset,
      child: GestureDetector(
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        onPanCancel: _handlePanCancel,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: AnimatedContainer(
                duration: _dragOffset == Offset.zero
                    ? const Duration(milliseconds: 180)
                    : Duration.zero,
                curve: Curves.easeOutCubic,
                child: DashboardWidgetContent(option: widget.item.option),
              ),
            ),
            if (widget.isEditing)
              Positioned(
                top: -6,
                right: -6,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => widget.onRemoved(widget.item.id),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.16),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
