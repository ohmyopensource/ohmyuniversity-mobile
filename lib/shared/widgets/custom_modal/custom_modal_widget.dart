import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_typography.dart';

// ─────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────

/// Layout strategy of the modal.
enum ModalType {
  center,
  drawerRight,
  drawerLeft,
  drawerBottom,
  drawerTop,
  fullscreen,
}

/// Size preset for [ModalType.center].
enum ModalSize { xs, sm, md, lg, xl, fullscreen }

/// Reason emitted when the modal is closed.
enum CloseReason { backdrop, esc, button, programmatic }

// ─────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────

/// Programmatic controller for [CustomModalWidget].
///
/// Pass a single instance to the widget and call [open], [close] or
/// [toggle] from outside.
///
/// Example:
/// ```dart
/// final _ctrl = CustomModalController();
///
/// CustomModalWidget(controller: _ctrl, child: ...);
///
/// ElevatedButton(onPressed: _ctrl.open, child: Text('Apri'));
/// ```
class CustomModalController extends ChangeNotifier {
  _CustomModalWidgetState? _state;

  void _attach(_CustomModalWidgetState s) => _state = s;
  void _detach() => _state = null;

  /// Opens the modal.
  void open() => _state?.open();

  /// Closes the modal.
  void close([CloseReason reason = CloseReason.programmatic]) =>
      _state?.close(reason);

  /// Toggles the modal.
  void toggle() => _state?.toggle();

  /// Whether the modal is currently open.
  bool get isOpen => _state?._isOpen ?? false;
}

// ─────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────

/// Flexible modal widget supporting multiple layouts:
/// center, drawer-right, drawer-left, drawer-bottom, drawer-top, fullscreen.
///
/// All layout types share the same header / body / footer structure and
/// animate in/out with transitions matching the Angular source.
///
/// Usage:
/// ```dart
/// CustomModalWidget(
///   controller: _ctrl,
///   type: ModalType.center,
///   size: ModalSize.md,
///   title: 'Titolo',
///   child: Text('Contenuto'),
///   footer: Row(children: [...]),
/// )
/// ```
class CustomModalWidget extends StatefulWidget {
  const CustomModalWidget({
    super.key,
    required this.child,
    this.controller,
    this.type = ModalType.center,
    this.size = ModalSize.md,
    this.drawerSize = 480,
    this.sheetSize,
    this.title,
    this.subtitle,
    this.showCloseButton = true,
    this.closeOnBackdrop = true,
    this.closeOnEsc = true,
    this.persistent = false,
    this.shakeOnPersist = true,
    this.darkTheme,
    this.lockScroll = true,
    this.footer,
    this.onClosed,
    this.onOpened,
  });

  /// Content rendered in the modal body.
  final Widget child;

  /// Optional programmatic controller.
  final CustomModalController? controller;

  /// Layout type. Default: [ModalType.center].
  final ModalType type;

  /// Size preset for [ModalType.center]. Default: [ModalSize.md].
  final ModalSize size;

  /// Width for drawer layouts (logical pixels). Default: 480.
  final double drawerSize;

  /// Height for bottom / top sheet (logical pixels). Null = auto (max 90%).
  final double? sheetSize;

  /// Header title. If null and [showCloseButton] is false, header is hidden.
  final String? title;

  /// Optional subtitle shown below [title].
  final String? subtitle;

  /// Shows the close × button in the header. Default: true.
  final bool showCloseButton;

  /// Closes on backdrop tap. Default: true.
  final bool closeOnBackdrop;

  /// Closes on ESC key press. Default: true.
  final bool closeOnEsc;

  /// Prevents closing via backdrop / ESC. Overrides the above.
  final bool persistent;

  /// Triggers shake animation when [persistent] blocks close. Default: true.
  final bool shakeOnPersist;

  /// Enables dark theme. Null follows the system theme automatically.
  final bool? darkTheme;

  /// Locks body scroll while open. Default: true.
  final bool lockScroll;

  /// Optional widget rendered in the footer area.
  final Widget? footer;

  /// Called with the close reason when the modal closes.
  final ValueChanged<CloseReason>? onClosed;

  /// Called when the modal finishes opening.
  final VoidCallback? onOpened;

  @override
  State<CustomModalWidget> createState() => _CustomModalWidgetState();
}

class _CustomModalWidgetState extends State<CustomModalWidget>
    with SingleTickerProviderStateMixin {
  // ── state ──────────────────────────────────
  bool _isOpen = false;
  bool _isVisible = false;
  bool _isShaking = false;

  // ── animation ──────────────────────────────
  late final AnimationController _animCtrl;
  late Animation<double> _backdropOpacity;
  late Animation<double> _containerOpacity;
  late Animation<Offset> _containerSlide;
  late Animation<double> _containerScale;

  // ── timers ─────────────────────────────────
  Timer? _openTimer;
  Timer? _closeTimer;
  Timer? _shakeTimer;

  // ── constants ──────────────────────────────
  static const _animDuration = Duration(milliseconds: 220);
  static const _closeDuration = Duration(milliseconds: 300);

  // ── lifecycle ──────────────────────────────

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    _animCtrl = AnimationController(vsync: this, duration: _animDuration);
    _buildAnimations();
  }

  @override
  void didUpdateWidget(covariant CustomModalWidget old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller?._detach();
      widget.controller?._attach(this);
    }
    if (old.type != widget.type) _buildAnimations();
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _animCtrl.dispose();
    _openTimer?.cancel();
    _closeTimer?.cancel();
    _shakeTimer?.cancel();
    super.dispose();
  }

  // ── animations ─────────────────────────────

  void _buildAnimations() {
    _backdropOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
    _containerOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));

    switch (widget.type) {
      case ModalType.center:
        _containerScale = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
        _containerSlide = Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(_animCtrl);
      case ModalType.drawerRight:
        _containerSlide = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
        _containerScale = Tween<double>(begin: 1, end: 1).animate(_animCtrl);
      case ModalType.drawerLeft:
        _containerSlide = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
        _containerScale = Tween<double>(begin: 1, end: 1).animate(_animCtrl);
      case ModalType.drawerBottom:
        _containerSlide = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
        _containerScale = Tween<double>(begin: 1, end: 1).animate(_animCtrl);
      case ModalType.drawerTop:
        _containerSlide = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
        _containerScale = Tween<double>(begin: 1, end: 1).animate(_animCtrl);
      case ModalType.fullscreen:
        _containerScale = Tween<double>(
          begin: 0.98,
          end: 1.0,
        ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
        _containerSlide = Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(_animCtrl);
    }
  }

  // ── public API ─────────────────────────────

  void open() {
    if (_isOpen) return;
    setState(() => _isOpen = true);

    _openTimer = Timer(const Duration(milliseconds: 10), () {
      setState(() => _isVisible = true);
      _animCtrl.forward();
      widget.onOpened?.call();
    });
  }

  void close([CloseReason reason = CloseReason.programmatic]) {
    if (!_isOpen) return;
    if (widget.persistent &&
        (reason == CloseReason.backdrop || reason == CloseReason.esc)) {
      _shake();
      return;
    }

    setState(() => _isVisible = false);
    _animCtrl.reverse();

    _closeTimer = Timer(_closeDuration, () {
      setState(() => _isOpen = false);
      widget.onClosed?.call(reason);
    });
  }

  void toggle() => _isOpen ? close(CloseReason.button) : open();

  // ── private helpers ────────────────────────

  void _onBackdropTap() {
    if (widget.closeOnBackdrop) {
      close(CloseReason.backdrop);
    } else {
      _shake();
    }
  }

  void _shake() {
    if (!widget.shakeOnPersist || _isShaking) return;
    setState(() => _isShaking = true);
    _shakeTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _isShaking = false);
    });
  }

  bool get _hasHeader =>
      (widget.title?.isNotEmpty ?? false) || widget.showCloseButton;

  bool _isDark(BuildContext ctx) =>
      widget.darkTheme ?? (Theme.of(ctx).brightness == Brightness.dark);

  // ── max-width per size ─────────────────────
  double? _maxWidth(ModalSize size) => switch (size) {
    ModalSize.xs => 320,
    ModalSize.sm => 480,
    ModalSize.md => 600,
    ModalSize.lg => 780,
    ModalSize.xl => 980,
    ModalSize.fullscreen => null,
  };

  // ── build ──────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (!_isOpen) return const SizedBox.shrink();

    final dark = _isDark(context);
    final mq = MediaQuery.of(context);
    final isMobile = mq.size.width <= 480;

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: (e) {
        if (e.logicalKey.keyLabel == 'Escape' && widget.closeOnEsc) {
          close(CloseReason.esc);
        } else if (e.logicalKey.keyLabel == 'Escape') {
          _shake();
        }
      },
      child: Stack(
        children: [
          // ── Backdrop ──
          _Backdrop(
            opacity: _backdropOpacity,
            dark: dark,
            onTap: _onBackdropTap,
          ),

          // ── Container ──
          _ModalContainer(
            type: widget.type,
            size: widget.size,
            drawerSize: widget.drawerSize,
            sheetSize: widget.sheetSize,
            maxWidth: _maxWidth(widget.size),
            dark: dark,
            isShaking: _isShaking,
            isMobile: isMobile,
            opacity: _containerOpacity,
            slide: _containerSlide,
            scale: _containerScale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ──
                if (_hasHeader)
                  _ModalHeader(
                    title: widget.title,
                    subtitle: widget.subtitle,
                    showCloseButton: widget.showCloseButton,
                    dark: dark,
                    onClose: () => close(CloseReason.button),
                  ),

                // ── Body ──
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: widget.child,
                  ),
                ),

                // ── Footer ──
                if (widget.footer != null)
                  _ModalFooter(dark: dark, child: widget.footer!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────

class _Backdrop extends StatelessWidget {
  const _Backdrop({
    required this.opacity,
    required this.dark,
    required this.onTap,
  });

  final Animation<double> opacity;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = dark
        ? Colors.black.withValues(alpha: 0.7)
        : Colors.black.withValues(alpha: 0.5);

    return AnimatedBuilder(
      animation: opacity,
      builder: (_, _) => GestureDetector(
        onTap: onTap,
        child: Container(
          color: bgColor.withValues(alpha: bgColor.a * opacity.value),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────

class _ModalContainer extends StatelessWidget {
  const _ModalContainer({
    required this.type,
    required this.size,
    required this.drawerSize,
    required this.sheetSize,
    required this.maxWidth,
    required this.dark,
    required this.isShaking,
    required this.isMobile,
    required this.opacity,
    required this.slide,
    required this.scale,
    required this.child,
  });

  final ModalType type;
  final ModalSize size;
  final double drawerSize;
  final double? sheetSize;
  final double? maxWidth;
  final bool dark;
  final bool isShaking;
  final bool isMobile;
  final Animation<double> opacity;
  final Animation<Offset> slide;
  final Animation<double> scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bg = dark ? AppColors.colorNeutral900 : Colors.white;
    const shadow = [
      BoxShadow(
        color: Color(0x26000000),
        blurRadius: 60,
        offset: Offset(0, 20),
      ),
      BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4)),
    ];

    Widget container = AnimatedBuilder(
      animation: Listenable.merge([opacity, slide, scale]),
      builder: (_, child) {
        Widget w = FadeTransition(
          opacity: opacity,
          child: ScaleTransition(
            scale: scale,
            child: SlideTransition(position: slide, child: child),
          ),
        );
        // shake
        if (isShaking) w = _ShakeWidget(child: w);
        return w;
      },
      child: Material(
        color: bg,
        borderRadius: _borderRadius(isMobile),
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: _borderRadius(isMobile),
            boxShadow: shadow,
          ),
          constraints: _constraints(context),
          child: child,
        ),
      ),
    );

    return _positionedByType(container, context);
  }

  BorderRadius _borderRadius(bool isMobile) {
    const r = Radius.circular(16);
    return switch (type) {
      ModalType.center when isMobile => const BorderRadius.vertical(top: r),
      ModalType.center => const BorderRadius.all(r),
      ModalType.drawerRight => const BorderRadius.horizontal(left: r),
      ModalType.drawerLeft => const BorderRadius.horizontal(right: r),
      ModalType.drawerBottom => const BorderRadius.vertical(top: r),
      ModalType.drawerTop => const BorderRadius.vertical(bottom: r),
      ModalType.fullscreen => BorderRadius.zero,
    };
  }

  BoxConstraints _constraints(BuildContext context) {
    final mq = MediaQuery.of(context);
    return switch (type) {
      ModalType.center when size == ModalSize.fullscreen => BoxConstraints(
        maxWidth: mq.size.width,
        maxHeight: mq.size.height,
      ),
      ModalType.center => BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: mq.size.height * 0.92,
      ),
      ModalType.drawerRight || ModalType.drawerLeft => BoxConstraints(
        maxWidth: drawerSize,
        maxHeight: mq.size.height,
      ),
      ModalType.drawerBottom => BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: sheetSize ?? mq.size.height * 0.9,
      ),
      ModalType.drawerTop => BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: sheetSize ?? mq.size.height * 0.5,
      ),
      ModalType.fullscreen => BoxConstraints(
        maxWidth: mq.size.width,
        maxHeight: mq.size.height,
      ),
    };
  }

  Widget _positionedByType(Widget container, BuildContext context) {
    final mq = MediaQuery.of(context);

    return switch (type) {
      ModalType.center when mq.size.width <= 480 => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: container,
      ),
      ModalType.center => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: container,
        ),
      ),
      ModalType.drawerRight => Positioned(
        top: 0,
        right: 0,
        bottom: 0,
        width: drawerSize.clamp(0, mq.size.width),
        child: container,
      ),
      ModalType.drawerLeft => Positioned(
        top: 0,
        left: 0,
        bottom: 0,
        width: drawerSize.clamp(0, mq.size.width),
        child: container,
      ),
      ModalType.drawerBottom => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: container,
      ),
      ModalType.drawerTop => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: container,
      ),
      ModalType.fullscreen => Positioned.fill(child: container),
    };
  }
}

// ─────────────────────────────────────────────

class _ModalHeader extends StatelessWidget {
  const _ModalHeader({
    required this.title,
    required this.subtitle,
    required this.showCloseButton,
    required this.dark,
    required this.onClose,
  });

  final String? title;
  final String? subtitle;
  final bool showCloseButton;
  final bool dark;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final titleColor = dark
        ? AppColors.colorNeutral100
        : AppColors.colorNeutral900;
    final subtitleColor = AppColors.colorNeutral500;
    final dividerColor = dark
        ? AppColors.colorNeutral600
        : AppColors.colorNeutral200;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor, width: 1.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title?.isNotEmpty ?? false)
                  Text(
                    title!,
                    style: AppTypography.textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                if (subtitle?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: subtitleColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showCloseButton) ...[
            const SizedBox(width: 8),
            _CloseButton(dark: dark, onTap: onClose),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────

class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.dark, required this.onTap});
  final bool dark;
  final VoidCallback onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = _hovered
        ? (widget.dark ? AppColors.colorNeutral200 : AppColors.colorNeutral600)
        : (widget.dark ? AppColors.colorNeutral500 : AppColors.colorNeutral400);
    final bgColor = _hovered
        ? (widget.dark ? AppColors.colorNeutral600 : AppColors.colorNeutral100)
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(LucideIcons.x, size: 18, color: iconColor),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────

class _ModalFooter extends StatelessWidget {
  const _ModalFooter({required this.dark, required this.child});
  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dividerColor = dark
        ? AppColors.colorNeutral600
        : AppColors.colorNeutral200;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: dividerColor, width: 1.5)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [child]),
    );
  }
}

// ─────────────────────────────────────────────
// Shake animation widget
// ─────────────────────────────────────────────

class _ShakeWidget extends StatefulWidget {
  const _ShakeWidget({required this.child});
  final Widget child;

  @override
  State<_ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<_ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shake;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 8, end: -5), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -5, end: 5), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 5, end: -3), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -3, end: 0), weight: 25),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (_, child) =>
          Transform.translate(offset: Offset(_shake.value, 0), child: child),
      child: widget.child,
    );
  }
}
