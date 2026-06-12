import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────────────────

/// Visual variant — maps to Angular `ButtonVariant`.
enum ButtonVariant {
  primary,
  secondary,
  tertiary,
  success,
  warning,
  error,
  info,
  ghost,
  outline,
  flat,
}

/// Size scale — maps to Angular `ButtonSize`.
enum ButtonSize { xs, sm, md, lg }

/// Icon placement — maps to Angular `IconPosition`.
enum ButtonIconPosition { left, right }

/// Visual style applied in the succeeded state — maps to Angular `SucceededStyle`.
enum SucceededStyle { filled, ghost }

// ─────────────────────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────────────────────

/// Design-system button with variants, sizes, loading state, success state,
/// icon support, icon-only mode, and ripple animation.
///
/// Direct Flutter migration of `CustomButtonComponent` (Angular).
///
/// ### Basic usage
/// ```dart
/// CustomButtonWidget(label: 'Accedi', onPressed: _submit)
///
/// CustomButtonWidget(
///   label: 'Salva',
///   variant: ButtonVariant.success,
///   loading: _isLoading,
///   succeeded: _isDone,
///   succeededLabel: 'Salvato!',
/// )
///
/// CustomButtonWidget(
///   icon: LucideIcons.plus,
///   iconOnly: true,
///   ariaLabel: 'Aggiungi',
///   variant: ButtonVariant.primary,
/// )
/// ```
class CustomButtonWidget extends StatefulWidget {
  const CustomButtonWidget({
    super.key,
    this.label = '',
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.fullWidth = false,
    this.icon,
    this.iconPosition = ButtonIconPosition.left,
    this.iconOnly = false,
    this.disabled = false,
    this.loading = false,
    this.succeeded = false,
    this.succeededStyle = SucceededStyle.filled,
    this.succeededLabel = '',
    this.onPressed,
    this.ariaLabel = '',
  });

  /// Text label displayed inside the button.
  final String label;

  /// Visual colour variant.
  final ButtonVariant variant;

  /// Physical size of the button.
  final ButtonSize size;

  /// Expands the button to fill its parent width.
  final bool fullWidth;

  /// Optional Lucide icon.
  final IconData? icon;

  /// Side on which the icon appears relative to the label.
  final ButtonIconPosition iconPosition;

  /// When `true`, hides the label and renders a square icon button.
  /// Always provide [ariaLabel] when using this mode.
  final bool iconOnly;

  /// Prevents interaction.
  final bool disabled;

  /// Shows a spinning loader and prevents interaction.
  final bool loading;

  /// Shows a success checkmark and prevents interaction.
  final bool succeeded;

  /// Visual style of the succeeded state.
  final SucceededStyle succeededStyle;

  /// Alternative label shown in the succeeded state.
  /// Falls back to [label] if empty.
  final String succeededLabel;

  /// Callback fired on tap. Ignored when inert.
  final VoidCallback? onPressed;

  /// Accessible label for screen readers.
  /// Required when [iconOnly] is `true`.
  final String ariaLabel;

  @override
  State<CustomButtonWidget> createState() => _CustomButtonWidgetState();
}

class _CustomButtonWidgetState extends State<CustomButtonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rippleController;
  late Animation<double> _rippleScale;
  late Animation<double> _rippleOpacity;

  Offset _rippleOffset = Offset.zero;
  double _rippleRadius = 0;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _rippleScale = Tween<double>(
      begin: 0,
      end: 3.5,
    ).animate(CurvedAnimation(parent: _rippleController, curve: Curves.linear));
    _rippleOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: const Interval(0.6, 1.0),
      ),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  // ── Derived state ──────────────────────────────────────────────────────────

  bool get _isInert => widget.disabled || widget.loading || widget.succeeded;

  String get _displayLabel =>
      widget.succeeded && widget.succeededLabel.isNotEmpty
      ? widget.succeededLabel
      : widget.label;

  // ── Size tokens ────────────────────────────────────────────────────────────

  double get _fontSize => switch (widget.size) {
    ButtonSize.xs => 11.2,
    ButtonSize.sm => 12.8,
    ButtonSize.md => 14.4,
    ButtonSize.lg => 16,
  };

  double get _minHeight => switch (widget.size) {
    ButtonSize.xs => 28,
    ButtonSize.sm => 34,
    ButtonSize.md => 42,
    ButtonSize.lg => 52,
  };

  EdgeInsets get _padding {
    if (widget.iconOnly) return EdgeInsets.zero;
    return switch (widget.size) {
      ButtonSize.xs => const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ButtonSize.sm => const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ButtonSize.md => const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      ButtonSize.lg => const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
    };
  }

  double get _iconSize => switch (widget.size) {
    ButtonSize.xs => 14,
    ButtonSize.sm => 16,
    ButtonSize.md => 18,
    ButtonSize.lg => 20,
  };

  double? get _fixedSize => widget.iconOnly
      ? switch (widget.size) {
          ButtonSize.xs => 28,
          ButtonSize.sm => 34,
          ButtonSize.md => 42,
          ButtonSize.lg => 52,
        }
      : null;

  // ── Colour resolution ──────────────────────────────────────────────────────

  _ButtonColors _resolveColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isInert && widget.disabled) {
      return _ButtonColors(
        gradient: LinearGradient(
          colors: [AppColors.colorNeutral200, AppColors.colorNeutral300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        text: AppColors.colorNeutral400,
        shadow: Colors.transparent,
        focusColor: Colors.transparent,
        rippleColor: Colors.white24,
      );
    }

    if (widget.succeeded) {
      if (widget.succeededStyle == SucceededStyle.ghost) {
        return _ButtonColors(
          background: Colors.transparent,
          text: AppColors.colorSuccessDark,
          border: AppColors.colorSuccessDark,
          shadow: Colors.transparent,
          focusColor: AppColors.colorSuccessFocus,
          rippleColor: AppColors.colorSuccessDark.withValues(alpha: 0.15),
        );
      }
      return _ButtonColors(
        gradient: LinearGradient(
          colors: [AppColors.colorSuccessLight, AppColors.colorSuccessDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        text: AppColors.colorSuccessText,
        shadow: AppColors.colorSuccessShadow,
        focusColor: AppColors.colorSuccessFocus,
        rippleColor: Colors.white38,
      );
    }

    switch (widget.variant) {
      case ButtonVariant.primary:
        return _ButtonColors(
          gradient: LinearGradient(
            colors: [AppColors.colorPrimaryLight, AppColors.colorPrimaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: AppColors.colorPrimaryText,
          shadow: AppColors.colorPrimaryShadow,
          focusColor: AppColors.colorPrimaryFocus,
          rippleColor: Colors.white38,
        );
      case ButtonVariant.secondary:
        return _ButtonColors(
          gradient: LinearGradient(
            colors: [
              AppColors.colorSecondaryLight,
              AppColors.colorSecondaryDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: AppColors.colorSecondaryText,
          shadow: AppColors.colorSecondaryShadow,
          focusColor: AppColors.colorSecondaryFocus,
          rippleColor: Colors.white38,
        );
      case ButtonVariant.tertiary:
        return _ButtonColors(
          gradient: LinearGradient(
            colors: [AppColors.colorTertiaryLight, AppColors.colorTertiaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: AppColors.colorTertiaryText,
          shadow: AppColors.colorTertiaryShadow,
          focusColor: AppColors.colorTertiaryFocus,
          rippleColor: Colors.white38,
        );
      case ButtonVariant.success:
        return _ButtonColors(
          gradient: LinearGradient(
            colors: [AppColors.colorSuccessLight, AppColors.colorSuccessDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: AppColors.colorSuccessText,
          shadow: AppColors.colorSuccessShadow,
          focusColor: AppColors.colorSuccessFocus,
          rippleColor: Colors.white38,
        );
      case ButtonVariant.warning:
        return _ButtonColors(
          gradient: LinearGradient(
            colors: [AppColors.colorWarningLight, AppColors.colorWarningDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: AppColors.colorWarningText,
          shadow: AppColors.colorWarningShadow,
          focusColor: AppColors.colorWarningFocus,
          rippleColor: Colors.white38,
        );
      case ButtonVariant.error:
        return _ButtonColors(
          gradient: LinearGradient(
            colors: [AppColors.colorErrorLight, AppColors.colorErrorDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: AppColors.colorErrorText,
          shadow: AppColors.colorErrorShadow,
          focusColor: AppColors.colorErrorFocus,
          rippleColor: Colors.white38,
        );
      case ButtonVariant.info:
        return _ButtonColors(
          gradient: LinearGradient(
            colors: [AppColors.colorInfoLight, AppColors.colorInfoDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: AppColors.colorInfoText,
          shadow: AppColors.colorInfoShadow,
          focusColor: AppColors.colorInfoFocus,
          rippleColor: Colors.white38,
        );
      case ButtonVariant.ghost:
        return _ButtonColors(
          background: Colors.transparent,
          text: isDark ? AppColors.colorNeutral400 : AppColors.colorNeutral500,
          border: isDark
              ? AppColors.colorNeutral600
              : AppColors.colorNeutral300,
          shadow: const Color(0x14646E82),
          focusColor: AppColors.colorPrimaryFocus,
          rippleColor: const Color(0x2E50648E),
        );
      case ButtonVariant.outline:
        return _ButtonColors(
          background: Colors.transparent,
          text: isDark
              ? AppColors.colorPrimaryLight
              : AppColors.colorPrimaryDark,
          border: isDark
              ? AppColors.colorPrimaryLight
              : AppColors.colorPrimaryDark,
          shadow: AppColors.colorPrimaryShadow.withValues(alpha: 0.12),
          focusColor: AppColors.colorPrimaryFocus,
          rippleColor: const Color(0x2E50648E),
        );
      case ButtonVariant.flat:
        return _ButtonColors(
          background: Colors.transparent,
          text: isDark
              ? AppColors.colorPrimaryLight
              : AppColors.colorPrimaryDark,
          shadow: Colors.transparent,
          focusColor: AppColors.colorPrimaryFocus,
          rippleColor: const Color(0x2E50648E),
        );
    }
  }

  // ── Interaction ────────────────────────────────────────────────────────────

  void _handleTapDown(TapDownDetails details, RenderBox box) {
    if (_isInert) return;
    setState(() {
      _isPressed = true;
      _rippleOffset = box.globalToLocal(details.globalPosition);
      _rippleRadius = (box.size.longestSide / 2).clamp(
        20,
        box.size.longestSide,
      );
    });
    _rippleController.forward(from: 0);
  }

  void _handleTapUp(TapUpDetails _) {
    if (_isInert) return;
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  void _handleTapCancel() => setState(() => _isPressed = false);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(context);
    final hasGradient = colors.gradient != null;
    final hasBorder = colors.border != null;

    BoxDecoration decoration = BoxDecoration(
      gradient: hasGradient ? colors.gradient : null,
      color: hasGradient ? null : colors.background,
      borderRadius: BorderRadius.circular(10),
      border: hasBorder ? Border.all(color: colors.border!, width: 1.5) : null,
      boxShadow: colors.shadow != Colors.transparent && !_isInert
          ? [
              BoxShadow(
                color: _isPressed ? Colors.transparent : colors.shadow,
                blurRadius: _isPressed ? 0 : 14,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );

    Widget button = Semantics(
      button: true,
      enabled: !_isInert,
      label: widget.ariaLabel.isNotEmpty ? widget.ariaLabel : _displayLabel,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(
            minHeight: _minHeight,
            minWidth: _fixedSize ?? 0,
            maxWidth: _fixedSize ?? double.infinity,
          ),
          width: widget.iconOnly
              ? _fixedSize
              : widget.fullWidth
              ? double.infinity
              : null,
          height: widget.iconOnly ? _fixedSize : null,
          decoration: decoration,
          clipBehavior: Clip.hardEdge,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Ripple ───────────────────────────────────────
              AnimatedBuilder(
                animation: _rippleController,
                builder: (_, _) => _rippleController.value > 0
                    ? Positioned(
                        left: _rippleOffset.dx - _rippleRadius,
                        top: _rippleOffset.dy - _rippleRadius,
                        child: Opacity(
                          opacity: _rippleOpacity.value,
                          child: Transform.scale(
                            scale: _rippleScale.value,
                            child: Container(
                              width: _rippleRadius * 2,
                              height: _rippleRadius * 2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.rippleColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // ── Content ──────────────────────────────────────
              Padding(padding: _padding, child: _buildContent(colors)),
            ],
          ),
        ),
      ),
    );

    // Wrap in GestureDetector with RenderBox access for ripple coords
    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) _handleTapDown(details, box);
      },
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: MouseRegion(
        cursor: _isInert
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: button,
      ),
    );
  }

  Widget _buildContent(_ButtonColors colors) {
    // Loading state
    if (widget.loading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SpinnerIcon(size: _iconSize, color: colors.text),
          if (!widget.iconOnly && _displayLabel.isNotEmpty) ...[
            const SizedBox(width: 8),
            _buildLabel(colors),
          ],
        ],
      );
    }

    // Succeeded state
    if (widget.succeeded) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.circleCheck, size: _iconSize, color: colors.text),
          if (!widget.iconOnly && _displayLabel.isNotEmpty) ...[
            const SizedBox(width: 8),
            _buildLabel(colors),
          ],
        ],
      );
    }

    // Icon-only
    if (widget.iconOnly) {
      return Icon(widget.icon, size: _iconSize, color: colors.text);
    }

    // Standard: icon left + label + icon right
    final children = <Widget>[];

    if (widget.icon != null && widget.iconPosition == ButtonIconPosition.left) {
      children.add(Icon(widget.icon, size: _iconSize, color: colors.text));
      if (_displayLabel.isNotEmpty) children.add(const SizedBox(width: 8));
    }

    if (_displayLabel.isNotEmpty) children.add(_buildLabel(colors));

    if (widget.icon != null &&
        widget.iconPosition == ButtonIconPosition.right) {
      if (_displayLabel.isNotEmpty) children.add(const SizedBox(width: 8));
      children.add(Icon(widget.icon, size: _iconSize, color: colors.text));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildLabel(_ButtonColors colors) {
    return Text(
      _displayLabel,
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.02 * _fontSize,
        height: 1,
        color: colors.text,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Spinning loader icon
// ─────────────────────────────────────────────────────────────────────────────

class _SpinnerIcon extends StatefulWidget {
  const _SpinnerIcon({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  State<_SpinnerIcon> createState() => _SpinnerIconState();
}

class _SpinnerIconState extends State<_SpinnerIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: Icon(
        LucideIcons.loaderCircle,
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal colour bundle
// ─────────────────────────────────────────────────────────────────────────────

class _ButtonColors {
  const _ButtonColors({
    this.gradient,
    this.background = Colors.transparent,
    required this.text,
    this.border,
    required this.shadow,
    required this.focusColor,
    required this.rippleColor,
  });

  final LinearGradient? gradient;
  final Color background;
  final Color text;
  final Color? border;
  final Color shadow;
  final Color focusColor;
  final Color rippleColor;
}
