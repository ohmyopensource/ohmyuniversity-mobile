// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────────────────

/// Visual variant of the badge — maps to the Angular `BadgeVariant` type.
enum BadgeVariant {
  primary,
  secondary,
  tertiary,
  success,
  warning,
  error,
  info,
  neutral,
  ghost,
  outline,
  flat,
}

/// Size of the badge — maps to the Angular `BadgeSize` type.
enum BadgeSize { xs, sm, md, lg }

/// Border shape of the badge — maps to the Angular `BadgeShape` type.
enum BadgeShape { pill, rounded, square }

/// Position of the optional icon relative to the label.
enum BadgeIconPosition { left, right }

// ─────────────────────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────────────────────

/// Reusable badge widget supporting semantic variants, sizes, shapes,
/// icons, counters, removable actions, and status dot indicators.
///
/// Direct Flutter migration of `CustomBadgeComponent` (Angular).
///
/// ### Basic usage
/// ```dart
/// CustomBadgeWidget(label: 'Superato', variant: BadgeVariant.success)
/// CustomBadgeWidget(count: 42, variant: BadgeVariant.error)
/// CustomBadgeWidget(dot: true, variant: BadgeVariant.warning)
/// CustomBadgeWidget(
///   label: 'Rimuovi',
///   removable: true,
///   onRemoved: () { /* ... */ },
/// )
/// ```
class CustomBadgeWidget extends StatelessWidget {
  const CustomBadgeWidget({
    super.key,

    // Content
    this.label = '',
    this.count = 0,
    this.maxCount = 99,

    // Appearance
    this.variant = BadgeVariant.primary,
    this.size = BadgeSize.md,
    this.shape = BadgeShape.pill,

    // Dot / status
    this.dot = false,

    // Icon
    this.icon,
    this.iconPosition = BadgeIconPosition.left,

    // Behaviour
    this.removable = false,
    this.onRemoved,

    // Accessibility
    this.semanticLabel,
  });

  /// Text label displayed inside the badge.
  final String label;

  /// Numeric counter shown instead of the label when > 0.
  final int count;

  /// Cap value beyond which the counter renders as `{maxCount}+`.
  final int maxCount;

  /// Semantic colour variant.
  final BadgeVariant variant;

  /// Physical size of the badge.
  final BadgeSize size;

  /// Border radius shape.
  final BadgeShape shape;

  /// When `true`, renders a compact coloured dot (no text, no count).
  /// If [label] or [count] are also provided, shows the dot inline
  /// alongside the content.
  final bool dot;

  /// Optional Lucide icon displayed inside the badge (ignored in count mode).
  final IconData? icon;

  /// Side on which the [icon] appears relative to the label.
  final BadgeIconPosition iconPosition;

  /// Adds a close button that fires [onRemoved] when tapped.
  final bool removable;

  /// Callback fired when the remove button is tapped.
  final VoidCallback? onRemoved;

  /// Overrides the default semantic label for screen readers.
  final String? semanticLabel;

  // ── Derived state ──────────────────────────────────────────────────────────

  bool get _isCountMode => count > 0;

  bool get _isDotOnly => dot && label.isEmpty && !_isCountMode;

  String get _displayCount =>
      count > maxCount ? '$maxCount+' : '$count';

  // ── Size tokens ────────────────────────────────────────────────────────────

  double get _fontSize => switch (size) {
    BadgeSize.xs => 9,
    BadgeSize.sm => 10.5,
    BadgeSize.md => 11,
    BadgeSize.lg => 13,
  };

  EdgeInsets get _padding => switch (size) {
    BadgeSize.xs => const EdgeInsets.symmetric(
        horizontal: 5.5, vertical: 2.5),
    BadgeSize.sm => const EdgeInsets.symmetric(
        horizontal: 7, vertical: 3),
    BadgeSize.md => const EdgeInsets.symmetric(
        horizontal: 9, vertical: 4),
    BadgeSize.lg => const EdgeInsets.symmetric(
        horizontal: 12, vertical: 5.5),
  };

  double get _minHeight => switch (size) {
    BadgeSize.xs => 18,
    BadgeSize.sm => 22,
    BadgeSize.md => 26,
    BadgeSize.lg => 32,
  };

  double get _dotSize => switch (size) {
    BadgeSize.xs => 5,
    BadgeSize.sm => 6,
    BadgeSize.md => 7,
    BadgeSize.lg => 8,
  };

  double get _dotOnlySize => switch (size) {
    BadgeSize.xs => 8,
    BadgeSize.sm => 10,
    BadgeSize.md => 12,
    BadgeSize.lg => 16,
  };

  double get _iconSize => switch (size) {
    BadgeSize.xs => 10,
    BadgeSize.sm => 11,
    BadgeSize.md => 12,
    BadgeSize.lg => 14,
  };

  double get _closeSize => switch (size) {
    BadgeSize.xs => 9,
    BadgeSize.sm => 10,
    BadgeSize.md => 11,
    BadgeSize.lg => 12,
  };

  // ── Border radius ──────────────────────────────────────────────────────────

  BorderRadius get _borderRadius => switch (shape) {
    BadgeShape.pill => BorderRadius.circular(9999),
    BadgeShape.rounded => BorderRadius.circular(10),
    BadgeShape.square => BorderRadius.circular(4),
  };

  // ── Colour resolution ──────────────────────────────────────────────────────

  /// Returns [background, textColor, borderColor, shadowColor, dotColor]
  /// for the current [variant].
  _BadgeColors _resolveColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (variant) {
      case BadgeVariant.primary:
        return _BadgeColors(
          gradient: LinearGradient(colors: [
            AppColors.colorPrimaryLight,
            AppColors.colorPrimaryDark,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          text: AppColors.colorPrimaryText,
          border: AppColors.colorPrimaryDark,
          shadow: AppColors.colorPrimaryShadow,
          dot: AppColors.colorPrimaryDark,
        );
      case BadgeVariant.secondary:
        return _BadgeColors(
          gradient: LinearGradient(colors: [
            AppColors.colorSecondaryLight,
            AppColors.colorSecondaryDark,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          text: AppColors.colorSecondaryText,
          border: AppColors.colorSecondaryDark,
          shadow: AppColors.colorSecondaryShadow,
          dot: AppColors.colorSecondaryDark,
        );
      case BadgeVariant.tertiary:
        return _BadgeColors(
          gradient: LinearGradient(colors: [
            AppColors.colorTertiaryLight,
            AppColors.colorTertiaryDark,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          text: AppColors.colorTertiaryText,
          border: AppColors.colorTertiaryDark,
          shadow: AppColors.colorTertiaryShadow,
          dot: AppColors.colorTertiaryDark,
        );
      case BadgeVariant.success:
        return _BadgeColors(
          gradient: LinearGradient(colors: [
            AppColors.colorSuccessLight,
            AppColors.colorSuccessDark,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          text: AppColors.colorSuccessText,
          border: AppColors.colorSuccessDark,
          shadow: AppColors.colorSuccessShadow,
          dot: AppColors.colorSuccessDark,
        );
      case BadgeVariant.warning:
        return _BadgeColors(
          gradient: LinearGradient(colors: [
            AppColors.colorWarningLight,
            AppColors.colorWarningDark,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          text: AppColors.colorWarningText,
          border: AppColors.colorWarningDark,
          shadow: AppColors.colorWarningShadow,
          dot: AppColors.colorWarningDark,
        );
      case BadgeVariant.error:
        return _BadgeColors(
          gradient: LinearGradient(colors: [
            AppColors.colorErrorLight,
            AppColors.colorErrorDark,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          text: AppColors.colorErrorText,
          border: AppColors.colorErrorDark,
          shadow: AppColors.colorErrorShadow,
          dot: AppColors.colorErrorDark,
        );
      case BadgeVariant.info:
        return _BadgeColors(
          gradient: LinearGradient(colors: [
            AppColors.colorInfoLight,
            AppColors.colorInfoDark,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          text: AppColors.colorInfoText,
          border: AppColors.colorInfoDark,
          shadow: AppColors.colorInfoShadow,
          dot: AppColors.colorInfoDark,
        );
      case BadgeVariant.neutral:
        return _BadgeColors(
          gradient: LinearGradient(colors: [
            AppColors.colorNeutral200,
            AppColors.colorNeutral300,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          text: AppColors.colorNeutral500,
          border: AppColors.colorNeutral300,
          shadow: const Color(0x26646E82), // rgba(100,110,130,.15)
          dot: AppColors.colorNeutral400,
        );
      case BadgeVariant.ghost:
        return _BadgeColors(
          background: Colors.transparent,
          text: isDark
              ? AppColors.colorNeutral400
              : AppColors.colorNeutral500,
          border: isDark
              ? AppColors.colorNeutral600
              : AppColors.colorNeutral300,
          shadow: Colors.transparent,
          dot: AppColors.colorNeutral400,
        );
      case BadgeVariant.outline:
        return _BadgeColors(
          background: Colors.transparent,
          text: isDark
              ? AppColors.colorPrimaryLight
              : AppColors.colorPrimaryDark,
          border: isDark
              ? AppColors.colorPrimaryLight
              : AppColors.colorPrimaryDark,
          shadow: Colors.transparent,
          dot: isDark
              ? AppColors.colorPrimaryLight
              : AppColors.colorPrimaryDark,
        );
      case BadgeVariant.flat:
        return _BadgeColors(
          background: Colors.transparent,
          text: isDark
              ? AppColors.colorPrimaryLight
              : AppColors.colorPrimaryDark,
          border: Colors.transparent,
          shadow: Colors.transparent,
          dot: isDark
              ? AppColors.colorPrimaryLight
              : AppColors.colorPrimaryDark,
        );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Dot-only mode: just a coloured circle, no decoration
    if (_isDotOnly) {
      return _DotOnlyBadge(
        size: _dotOnlySize,
        colors: _resolveColors(context),
        semanticLabel: semanticLabel,
      );
    }

    final colors = _resolveColors(context);

    final textStyle = TextStyle(
      fontSize: _fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.03 * _fontSize,
      height: 1,
      color: colors.text,
    );

    Widget content = _buildContent(colors, textStyle);

    if (removable && onRemoved != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          const SizedBox(width: 2),
          _RemoveButton(
            size: _closeSize,
            color: colors.text,
            onTap: onRemoved!,
          ),
        ],
      );
    }

    final hasGradient = colors.gradient != null;

    final decoration = BoxDecoration(
      gradient: hasGradient ? colors.gradient : null,
      color: hasGradient ? null : colors.background,
      borderRadius: _isCountMode && shape == BadgeShape.pill
          ? BorderRadius.circular(9999)
          : _borderRadius,
      border: Border.all(
        color: colors.border,
        width: 1.5,
      ),
      boxShadow: colors.shadow != Colors.transparent
          ? [
        BoxShadow(
          color: colors.shadow,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ]
          : null,
    );

    return Semantics(
      label: semanticLabel ?? label,
      child: Container(
        constraints: BoxConstraints(
          minHeight: _minHeight,
          minWidth: _isCountMode ? _minHeight : 0,
        ),
        padding: _padding,
        decoration: decoration,
        child: content,
      ),
    );
  }

  Widget _buildContent(_BadgeColors colors, TextStyle textStyle) {
    final children = <Widget>[];

    // Inline dot
    if (dot && !_isDotOnly) {
      children.add(
        _InlineDot(size: _dotSize, color: colors.dot),
      );
      children.add(SizedBox(width: _dotSize * 0.6));
    }

    // Left icon
    if (icon != null &&
        iconPosition == BadgeIconPosition.left &&
        !_isCountMode) {
      children.add(Icon(icon, size: _iconSize, color: colors.text));
      children.add(const SizedBox(width: 3));
    }

    // Label / count
    if (_isCountMode) {
      children.add(
        Text(_displayCount, style: textStyle, textAlign: TextAlign.center),
      );
    } else {
      children.add(Text(label, style: textStyle));
    }

    // Right icon
    if (icon != null &&
        iconPosition == BadgeIconPosition.right &&
        !_isCountMode) {
      children.add(const SizedBox(width: 3));
      children.add(Icon(icon, size: _iconSize, color: colors.text));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _DotOnlyBadge extends StatelessWidget {
  const _DotOnlyBadge({
    required this.size,
    required this.colors,
    this.semanticLabel,
  });

  final double size;
  final _BadgeColors colors;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Status indicator',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colors.dot,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _InlineDot extends StatelessWidget {
  const _InlineDot({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({
    required this.size,
    required this.color,
    required this.onTap,
  });

  final double size;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Rimuovi badge',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Icon(
          LucideIcons.x,
          size: size,
          color: color.withOpacity(0.6),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal colour bundle
// ─────────────────────────────────────────────────────────────────────────────

/// Resolved colour set for a given [BadgeVariant] + theme brightness.
class _BadgeColors {
  const _BadgeColors({
    this.gradient,
    this.background = Colors.transparent,
    required this.text,
    required this.border,
    required this.shadow,
    required this.dot,
  });

  final LinearGradient? gradient;
  final Color background;
  final Color text;
  final Color border;
  final Color shadow;
  final Color dot;
}