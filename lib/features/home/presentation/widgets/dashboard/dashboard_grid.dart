import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../config/theme/app_colors.dart';
import 'dashboard_empty_state.dart';
import 'dashboard_grid_background.dart';
import 'dashboard_widget_picker.dart';

class DashboardGrid extends StatefulWidget {
  const DashboardGrid({super.key});

  @override
  State<DashboardGrid> createState() => _DashboardGridState();
}

class _DashboardGridState extends State<DashboardGrid> {
  Timer? _longPressTimer;
  bool _isEditing = false;

  @override
  void dispose() {
    _cancelLongPressTimer();
    super.dispose();
  }

  void _startLongPressTimer() {
    if (_isEditing) return;

    _cancelLongPressTimer();
    _longPressTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      HapticFeedback.mediumImpact();
      setState(() => _isEditing = true);
    });
  }

  void _cancelLongPressTimer() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
  }

  void _exitEditMode() {
    _cancelLongPressTimer();
    if (!_isEditing) return;

    HapticFeedback.selectionClick();
    setState(() => _isEditing = false);
  }

  Future<void> _openWidgetPicker() async {
    final selectedWidget = await showModalBottomSheet<DashboardWidgetOption>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DashboardWidgetPicker(),
    );

    if (!mounted || selectedWidget == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${selectedWidget.title} selezionato'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _startLongPressTimer(),
      onTapUp: (_) => _cancelLongPressTimer(),
      onTapCancel: _cancelLongPressTimer,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              child: _isEditing
                  ? const DashboardGridBackground()
                  : const DashboardEmptyState(),
            ),
          ),

          if (_isEditing)
            Positioned(
              top: 16,
              right: 18,
              child: SafeArea(
                child: IconButton.filledTonal(
                  onPressed: _exitEditMode,
                  icon: const Icon(LucideIcons.x),
                  color: AppColors.textPrimary,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.background.withValues(
                      alpha: 0.92,
                    ),
                    fixedSize: const Size(42, 42),
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ),
          if (_isEditing)
            Positioned(
              right: 20,
              bottom: 24,
              child: FloatingActionButton.small(
                heroTag: 'dashboard-widget-picker',
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.textPrimary,
                elevation: 4,
                shape: const CircleBorder(),
                onPressed: _openWidgetPicker,
                child: const Icon(LucideIcons.plus),
              ),
            ),
        ],
      ),
    );
  }
}
