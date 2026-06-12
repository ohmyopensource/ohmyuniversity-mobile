// @file custom_toast_widget.dart
// Toast container (global overlay) and individual toast item.
//
// ### Setup in app.dart
// ```dart
// MaterialApp.router(
//   builder: (context, child) => Stack(
//     children: [
//       child ?? const SizedBox.shrink(),
//       const ToastContainerWidget(),
//     ],
//   ),
//   ...
// )
// ```

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import 'custom_toast_model.dart';
import 'custom_toast_service.dart';

// ─────────────────────────────────────────────
// Container
// ─────────────────────────────────────────────

/// Global overlay rendering all active toasts grouped by position.
/// Place this once inside the `builder` of `MaterialApp.router`.
class ToastContainerWidget extends ConsumerWidget {
  const ToastContainerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final byPosition = ref.watch(toastServiceProvider.notifier).byPosition;
    // Re-build whenever the toast list changes
    ref.watch(toastServiceProvider);

    return Stack(
      children: [
        for (final entry in byPosition.entries)
          if (entry.value.isNotEmpty)
            _ToastStack(position: entry.key, toasts: entry.value),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Stack per position
// ─────────────────────────────────────────────

class _ToastStack extends StatelessWidget {
  const _ToastStack({required this.position, required this.toasts});

  final ToastPosition position;
  final List<ToastModel> toasts;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isMobile = mq.size.width <= 480;
    final safeTop = mq.padding.top;
    final safeBottom = mq.padding.bottom;

    final isBottom =
        position == ToastPosition.bottomRight ||
        position == ToastPosition.bottomLeft ||
        position == ToastPosition.bottomCenter;
    final isTop = !isBottom;

    // Mobile: full-width, stacked from top or bottom
    if (isMobile) {
      return Positioned(
        top: isTop ? safeTop + 8 : null,
        bottom: isBottom ? safeBottom + 8 : null,
        left: 8,
        right: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          verticalDirection: isBottom
              ? VerticalDirection.up
              : VerticalDirection.down,
          children: toasts
              .map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ToastItemWidget(toast: t),
                ),
              )
              .toList(),
        ),
      );
    }

    // Desktop: positioned per spec
    final (left, right, top, bottom, crossAxis) = switch (position) {
      ToastPosition.topRight => (
        null,
        16.0,
        safeTop + 16.0,
        null,
        CrossAxisAlignment.end,
      ),
      ToastPosition.topLeft => (
        16.0,
        null,
        safeTop + 16.0,
        null,
        CrossAxisAlignment.start,
      ),
      ToastPosition.topCenter => (
        null,
        null,
        safeTop + 16.0,
        null,
        CrossAxisAlignment.center,
      ),
      ToastPosition.bottomRight => (
        null,
        16.0,
        null,
        safeBottom + 16.0,
        CrossAxisAlignment.end,
      ),
      ToastPosition.bottomLeft => (
        16.0,
        null,
        null,
        safeBottom + 16.0,
        CrossAxisAlignment.start,
      ),
      ToastPosition.bottomCenter => (
        null,
        null,
        null,
        safeBottom + 16.0,
        CrossAxisAlignment.center,
      ),
    };

    Widget stack = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxis,
      verticalDirection: isBottom
          ? VerticalDirection.up
          : VerticalDirection.down,
      children: toasts
          .map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ToastItemWidget(toast: t),
            ),
          )
          .toList(),
    );

    // topCenter / bottomCenter need centering
    if (position == ToastPosition.topCenter ||
        position == ToastPosition.bottomCenter) {
      stack = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [stack],
      );
    }

    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: stack,
    );
  }
}

// ─────────────────────────────────────────────
// Toast item
// ─────────────────────────────────────────────

class _ToastItemWidget extends ConsumerStatefulWidget {
  const _ToastItemWidget({required this.toast});

  final ToastModel toast;

  @override
  ConsumerState<_ToastItemWidget> createState() => _ToastItemWidgetState();
}

class _ToastItemWidgetState extends ConsumerState<_ToastItemWidget>
    with SingleTickerProviderStateMixin {
  // ── Visibility animation ───────────────────────────────────────────────────
  late final AnimationController _animCtrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  // ── Progress bar ───────────────────────────────────────────────────────────
  double _progress = 1.0; // 1.0 = full, 0.0 = empty
  Timer? _progressTimer;
  DateTime? _startTime;
  Duration _remaining = Duration.zero;

  // ── Drag (swipe to dismiss) ────────────────────────────────────────────────
  double _dragOffset = 0;
  double _dragOpacity = 1;
  bool _isDragging = false;
  double _dragStartX = 0;

  // ── Hover ──────────────────────────────────────────────────────────────────
  bool _hovered = false;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));

    // Delayed entrance (matches Angular's 10ms setTimeout)
    Future.delayed(const Duration(milliseconds: 10), () {
      if (mounted) _animCtrl.forward();
    });

    _remaining = widget.toast.duration;
    if (_remaining > Duration.zero) _startProgress();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  // ── Progress ───────────────────────────────────────────────────────────────

  void _startProgress() {
    _startTime = DateTime.now();
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!mounted || widget.toast.paused) return;
      final elapsed = DateTime.now().difference(_startTime!);
      final newProgress =
          1.0 - elapsed.inMilliseconds / _remaining.inMilliseconds;
      setState(() => _progress = newProgress.clamp(0.0, 1.0));
    });
  }

  void _pauseProgress() {
    if (_startTime != null) {
      final elapsed = DateTime.now().difference(_startTime!);
      _remaining = _remaining - elapsed;
      if (_remaining < Duration.zero) _remaining = Duration.zero;
    }
    _progressTimer?.cancel();
    ref.read(toastServiceProvider.notifier).pause(widget.toast.id);
  }

  void _resumeProgress() {
    ref
        .read(toastServiceProvider.notifier)
        .resume(widget.toast.id, remaining: _remaining);
    _startTime = DateTime.now();
    _startProgress();
  }

  // ── Dismiss ────────────────────────────────────────────────────────────────

  void _dismiss({_ExitDirection dir = _ExitDirection.normal}) {
    _progressTimer?.cancel();

    if (dir != _ExitDirection.normal) {
      setState(() {
        _dragOffset = dir == _ExitDirection.right ? 300 : -300;
        _dragOpacity = 0;
      });
    }

    _animCtrl.reverse().then((_) {
      if (mounted) {
        ref.read(toastServiceProvider.notifier).dismiss(widget.toast.id);
      }
    });
  }

  // ── Drag handlers ──────────────────────────────────────────────────────────

  void _onDragStart(double clientX) {
    _isDragging = true;
    _dragStartX = clientX;
  }

  void _onDragMove(double clientX) {
    if (!_isDragging) return;
    final offset = clientX - _dragStartX;
    setState(() {
      _dragOffset = offset;
      _dragOpacity = (1 - (offset.abs() / 150)).clamp(0.0, 1.0);
    });
  }

  void _onDragEnd() {
    if (!_isDragging) return;
    _isDragging = false;
    if (_dragOffset.abs() > 80) {
      _dismiss(
        dir: _dragOffset > 0 ? _ExitDirection.right : _ExitDirection.left,
      );
    } else {
      setState(() {
        _dragOffset = 0;
        _dragOpacity = 1;
      });
    }
  }

  // ── Colors ─────────────────────────────────────────────────────────────────

  _ToastColors get _colors => switch (widget.toast.variant) {
    ToastVariant.success => _ToastColors(
      background: LinearGradient(
        colors: [AppColors.colorSuccessLight, const Color(0xFFE8FDF2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: AppColors.colorSuccessDark,
      text: AppColors.colorSuccessText,
      progress: AppColors.colorSuccessDark,
    ),
    ToastVariant.error => _ToastColors(
      background: LinearGradient(
        colors: [AppColors.colorErrorLight, const Color(0xFFFDF2F2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: AppColors.colorErrorDark,
      text: AppColors.colorErrorText,
      progress: AppColors.colorErrorDark,
    ),
    ToastVariant.warning => _ToastColors(
      background: LinearGradient(
        colors: [AppColors.colorWarningLight, const Color(0xFFFDFAF0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: AppColors.colorWarningDark,
      text: AppColors.colorWarningText,
      progress: AppColors.colorWarningDark,
    ),
    ToastVariant.info => _ToastColors(
      background: LinearGradient(
        colors: [AppColors.colorInfoLight, const Color(0xFFF0F4FD)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: AppColors.colorInfoDark,
      text: AppColors.colorInfoText,
      progress: AppColors.colorInfoDark,
    ),
    ToastVariant.neutral => _ToastColors(
      background: LinearGradient(
        colors: [AppColors.colorNeutral100, Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: AppColors.colorNeutral300,
      text: AppColors.colorNeutral600,
      progress: AppColors.colorNeutral400,
    ),
  };

  IconData get _icon => switch (widget.toast.variant) {
    ToastVariant.success => LucideIcons.circleCheck,
    ToastVariant.error => LucideIcons.circleX,
    ToastVariant.warning => LucideIcons.triangleAlert,
    ToastVariant.info => LucideIcons.info,
    ToastVariant.neutral => LucideIcons.messageSquare,
  };

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    final hasDuration = widget.toast.duration > Duration.zero;

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      transform: Matrix4.translationValues(_dragOffset, _hovered ? -1 : 0, 0),
      child: Opacity(
        opacity: _dragOpacity,
        child: Container(
          constraints: const BoxConstraints(minWidth: 280, maxWidth: 380),
          decoration: BoxDecoration(
            gradient: c.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.border, width: 1.5),
            boxShadow: _hovered
                ? const [
                    BoxShadow(
                      color: Color(0x29000000),
                      blurRadius: 30,
                      offset: Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Main row ──
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    14,
                    13,
                    10,
                    hasDuration ? 18 : 13,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Icon(_icon, size: 18, color: c.text),
                      ),
                      const SizedBox(width: 10),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.toast.title != null) ...[
                              Text(
                                widget.toast.title!,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: c.text,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                            Text(
                              widget.toast.message,
                              style: TextStyle(
                                fontSize: 13,
                                color: c.text,
                                height: 1.4,
                              ),
                            ),
                            if (widget.toast.action != null) ...[
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  widget.toast.action!.onClick();
                                  _dismiss();
                                },
                                child: Text(
                                  widget.toast.action!.label,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: c.text,
                                    decoration: TextDecoration.underline,
                                    decorationColor: c.text,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Close button
                      if (widget.toast.dismissible) ...[
                        const SizedBox(width: 4),
                        _CloseButton(color: c.text, onTap: _dismiss),
                      ],
                    ],
                  ),
                ),

                // ── Progress bar ──
                if (hasDuration)
                  SizedBox(
                    height: 3,
                    child: LayoutBuilder(
                      builder: (_, constraints) => Stack(
                        children: [
                          Container(
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 30),
                            width: constraints.maxWidth * _progress,
                            color: c.progress,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    // Entrance animation
    content = FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: content),
    );

    // Hover + drag interactions
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        _pauseProgress();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        if (!widget.toast.paused) _resumeProgress();
      },
      child: GestureDetector(
        onHorizontalDragStart: (d) => _onDragStart(d.globalPosition.dx),
        onHorizontalDragUpdate: (d) => _onDragMove(d.globalPosition.dx),
        onHorizontalDragEnd: (_) => _onDragEnd(),
        child: content,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Close button
// ─────────────────────────────────────────────

class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.color, required this.onTap});
  final Color color;
  final VoidCallback onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.black.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            LucideIcons.x,
            size: 14,
            color: widget.color.withValues(alpha: _hovered ? 1 : 0.5),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Internal helpers
// ─────────────────────────────────────────────

enum _ExitDirection { normal, left, right }

class _ToastColors {
  const _ToastColors({
    required this.background,
    required this.border,
    required this.text,
    required this.progress,
  });

  final Gradient background;
  final Color border;
  final Color text;
  final Color progress;
}
