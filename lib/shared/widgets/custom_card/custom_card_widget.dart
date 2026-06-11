import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

// ─────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────

/// Card color variant — maps to Angular `CardVariant`.
enum CardVariant {
  defaultVariant,
  primary,
  secondary,
  tertiary,
  success,
  warning,
  error,
  info,
  neutral,
}

/// Internal padding — maps to Angular `CardPadding`.
enum CardPadding { none, sm, md, lg }

/// Shadow intensity — maps to Angular `CardShadow`.
enum CardShadow { none, sm, md, lg }

/// Corner radius — maps to Angular `CardRadius`.
enum CardRadius { sm, md, lg }

/// Interaction mode — maps to Angular `CardMode`.
enum CardMode { defaultMode, linkInternal, linkExternal }

// ─────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────

/// Flexible base card component with variants, padding, shadow, radius,
/// accent bar, hover lift, dark mode, and optional tap / navigation.
///
/// This is the base building block. Prefer the specialised variants
/// (`CardSimpleWidget`, `CardNavWidget`, etc.) for common patterns.
///
/// ### Usage
/// ```dart
/// CustomCardWidget(
///   variant: CardVariant.primary,
///   shadow: CardShadow.md,
///   accentBar: true,
///   onTap: () => doSomething(),
///   child: Text('Hello'),
/// )
/// ```
class CustomCardWidget extends StatefulWidget {
  const CustomCardWidget({
    super.key,
    required this.child,
    this.variant = CardVariant.defaultVariant,
    this.padding = CardPadding.md,
    this.shadow = CardShadow.md,
    this.radius = CardRadius.md,
    this.stretchHeight = false,
    this.bordered = true,
    this.accentBar = false,
    this.darkTheme,
    this.hoverable = false,
    this.clickable = false,
    this.onTap,
    this.semanticsLabel,
  });

  /// Card body content.
  final Widget child;

  /// Color variant. Default: [CardVariant.defaultVariant].
  final CardVariant variant;

  /// Internal padding. Default: [CardPadding.md].
  final CardPadding padding;

  /// Shadow intensity. Default: [CardShadow.md].
  final CardShadow shadow;

  /// Corner radius. Default: [CardRadius.md].
  final CardRadius radius;

  /// Expands to fill parent height.
  final bool stretchHeight;

  /// Renders a 1.5px border. Default: true.
  final bool bordered;

  /// Shows a 4px colored bar on the left edge, colored by [variant].
  final bool accentBar;

  /// Forces dark styling. Null = follows system theme.
  final bool? darkTheme;

  /// Shows hover lift even when [onTap] is null.
  final bool hoverable;

  /// Applies pointer cursor and ripple. Set true when [onTap] is provided.
  final bool clickable;

  /// Tap callback. When non-null the card becomes interactive.
  final VoidCallback? onTap;

  /// Accessibility label for the card when interactive.
  final String? semanticsLabel;

  @override
  State<CustomCardWidget> createState() => _CustomCardWidgetState();
}

class _CustomCardWidgetState extends State<CustomCardWidget> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _isDark =>
      widget.darkTheme ?? (Theme.of(context).brightness == Brightness.dark);

  bool get _isInteractive => widget.onTap != null || widget.clickable;

  // ── Padding ────────────────────────────────────────────────────────────────

  EdgeInsets get _resolvedPadding => switch (widget.padding) {
    CardPadding.none => EdgeInsets.zero,
    CardPadding.sm => const EdgeInsets.all(12),
    CardPadding.md => const EdgeInsets.all(20),
    CardPadding.lg => const EdgeInsets.all(32),
  };

  // ── Border radius ──────────────────────────────────────────────────────────

  BorderRadius get _resolvedRadius => switch (widget.radius) {
    CardRadius.sm => BorderRadius.circular(6),
    CardRadius.md => BorderRadius.circular(10),
    CardRadius.lg => BorderRadius.circular(16),
  };

  // ── Shadow ─────────────────────────────────────────────────────────────────

  List<BoxShadow> _resolveShadow({bool hovered = false, bool pressed = false}) {
    if (hovered && !pressed) {
      return const [
        BoxShadow(color: Color(0x1F000000), blurRadius: 36, offset: Offset(0, 12)),
        BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 3)),
      ];
    }
    if (pressed) {
      return const [
        BoxShadow(color: Color(0x17000000), blurRadius: 20, offset: Offset(0, 6)),
      ];
    }
    return switch (widget.shadow) {
      CardShadow.none => const [],
      CardShadow.sm => const [
        BoxShadow(color: Color(0x0F000000), blurRadius: 4, offset: Offset(0, 1)),
        BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1)),
      ],
      CardShadow.md => const [
        BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4)),
        BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1)),
      ],
      CardShadow.lg => const [
        BoxShadow(color: Color(0x1A000000), blurRadius: 32, offset: Offset(0, 8)),
        BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2)),
      ],
    };
  }

  // ── Background ─────────────────────────────────────────────────────────────

  Gradient? _resolveGradient() {
    if (_isDark) return _resolveDarkGradient();
    return switch (widget.variant) {
      CardVariant.defaultVariant => null,
      CardVariant.neutral => null,
      CardVariant.primary => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.colorPrimaryLight.withValues(alpha: 0.30),
          Colors.white,
        ],
      ),
      CardVariant.secondary => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.colorSecondaryLight.withValues(alpha: 0.30),
          Colors.white,
        ],
      ),
      CardVariant.tertiary => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.colorTertiaryLight.withValues(alpha: 0.30),
          Colors.white,
        ],
      ),
      CardVariant.success => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.colorSuccessLight.withValues(alpha: 0.30),
          Colors.white,
        ],
      ),
      CardVariant.warning => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.colorWarningLight.withValues(alpha: 0.30),
          Colors.white,
        ],
      ),
      CardVariant.error => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.colorErrorLight.withValues(alpha: 0.30),
          Colors.white,
        ],
      ),
      CardVariant.info => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.colorInfoLight.withValues(alpha: 0.30),
          Colors.white,
        ],
      ),
    };
  }

  Gradient? _resolveDarkGradient() => switch (widget.variant) {
    CardVariant.defaultVariant || CardVariant.neutral => null,
    CardVariant.primary => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.colorPrimaryDark.withValues(alpha: 0.20),
        AppColors.colorNeutral900,
      ],
    ),
    CardVariant.secondary => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.colorSecondaryDark.withValues(alpha: 0.20),
        AppColors.colorNeutral900,
      ],
    ),
    CardVariant.tertiary => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.colorTertiaryDark.withValues(alpha: 0.20),
        AppColors.colorNeutral900,
      ],
    ),
    CardVariant.success => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.colorSuccessDark.withValues(alpha: 0.20),
        AppColors.colorNeutral900,
      ],
    ),
    CardVariant.warning => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.colorWarningDark.withValues(alpha: 0.20),
        AppColors.colorNeutral900,
      ],
    ),
    CardVariant.error => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.colorErrorDark.withValues(alpha: 0.20),
        AppColors.colorNeutral900,
      ],
    ),
    CardVariant.info => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.colorInfoDark.withValues(alpha: 0.20),
        AppColors.colorNeutral900,
      ],
    ),
  };

  Color _resolveSolidBackground() {
    if (_isDark) return AppColors.colorNeutral900;
    return switch (widget.variant) {
      CardVariant.neutral => AppColors.colorNeutral100,
      _ => Colors.white,
    };
  }

  // ── Border color ───────────────────────────────────────────────────────────

  Color _resolveBorderColor() {
    if (!widget.bordered) return Colors.transparent;
    if (_isDark) {
      return switch (widget.variant) {
        CardVariant.primary => AppColors.colorPrimaryDark,
        CardVariant.secondary => AppColors.colorSecondaryDark,
        CardVariant.tertiary => AppColors.colorTertiaryDark,
        CardVariant.success => AppColors.colorSuccessDark,
        CardVariant.warning => AppColors.colorWarningDark,
        CardVariant.error => AppColors.colorErrorDark,
        CardVariant.info => AppColors.colorInfoDark,
        _ => AppColors.colorNeutral600,
      };
    }
    return switch (widget.variant) {
      CardVariant.defaultVariant => AppColors.colorNeutral200,
      CardVariant.neutral => AppColors.colorNeutral200,
      CardVariant.primary => AppColors.colorPrimaryLight,
      CardVariant.secondary => AppColors.colorSecondaryLight,
      CardVariant.tertiary => AppColors.colorTertiaryLight,
      CardVariant.success => AppColors.colorSuccessLight,
      CardVariant.warning => AppColors.colorWarningLight,
      CardVariant.error => AppColors.colorErrorLight,
      CardVariant.info => AppColors.colorInfoLight,
    };
  }

  // ── Accent bar color ───────────────────────────────────────────────────────

  Color _resolveAccentColor() => switch (widget.variant) {
    CardVariant.secondary => AppColors.colorSecondaryDark,
    CardVariant.tertiary => AppColors.colorTertiaryDark,
    CardVariant.success => AppColors.colorSuccessDark,
    CardVariant.warning => AppColors.colorWarningDark,
    CardVariant.error => AppColors.colorErrorDark,
    CardVariant.info => AppColors.colorInfoDark,
    CardVariant.neutral => AppColors.colorNeutral400,
    _ => AppColors.colorPrimaryDark,
  };

  // ── Hover shadow variant color ─────────────────────────────────────────────

  List<BoxShadow> _resolveHoverShadow() {
    Color shadowColor;
    if (_isDark) {
      shadowColor = Colors.black.withValues(alpha: 0.4);
    } else {
      shadowColor = switch (widget.variant) {
        CardVariant.primary => AppColors.colorPrimaryShadow,
        CardVariant.secondary => AppColors.colorSecondaryShadow,
        CardVariant.tertiary => AppColors.colorTertiaryShadow,
        CardVariant.success => AppColors.colorSuccessShadow,
        CardVariant.warning => AppColors.colorWarningShadow,
        CardVariant.error => AppColors.colorErrorShadow,
        CardVariant.info => AppColors.colorInfoShadow,
        _ => const Color(0x1F000000),
      };
    }
    return [
      BoxShadow(color: shadowColor, blurRadius: 36, offset: const Offset(0, 12)),
      BoxShadow(
        color: shadowColor.withValues(alpha: shadowColor.a * 0.5),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ];
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final gradient = _resolveGradient();
    final bgColor = _resolveSolidBackground();
    final borderColor = _resolveBorderColor();
    final shadows = (_hovered && (widget.hoverable || _isInteractive))
        ? _resolveHoverShadow()
        : _resolveShadow(pressed: _pressed);
    final lift = _hovered && (widget.hoverable || _isInteractive) && !_pressed
        ? -3.0
        : _pressed
        ? -1.0
        : 0.0;

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, lift, 0),
      height: widget.stretchHeight ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? bgColor : null,
        borderRadius: _resolvedRadius,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: _resolvedRadius,
        child: Stack(
          children: [
            // ── Accent bar ──
            if (widget.accentBar)
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: _resolveAccentColor(),
                    borderRadius: BorderRadius.only(
                      topLeft: _resolvedRadius.topLeft,
                      bottomLeft: _resolvedRadius.bottomLeft,
                    ),
                  ),
                ),
              ),

            // ── Content ──
            Padding(padding: _resolvedPadding, child: widget.child),
          ],
        ),
      ),
    );

    if (_isInteractive) {
      card = Semantics(
        button: true,
        label: widget.semanticsLabel,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() {
            _hovered = false;
            _pressed = false;
          }),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            },
            onTapCancel: () => setState(() => _pressed = false),
            child: card,
          ),
        ),
      );
    } else if (widget.hoverable) {
      card = MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: card,
      );
    }

    return card;
  }
}