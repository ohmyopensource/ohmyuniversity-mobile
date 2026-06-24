import 'dart:convert';

// features: image / initials / icon fallback, ring, status dot,
// size variants, shape variants, color variants, clickable, dark theme.

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';

// ─── Types ───────────────────────────────────────────────────────────────────

/// Available size scale for the avatar component.
enum AvatarSize { xs, sm, md, lg, xl, xxl }

/// Shape variants for the avatar container.
enum AvatarShape { circle, rounded, square }

/// Color variant used for fallback background and optional ring styling.
enum AvatarVariant {
  primary,
  secondary,
  tertiary,
  success,
  warning,
  error,
  info,
  neutral,
}

/// Presence/status indicator displayed as overlay dot.
enum AvatarDotStatus { online, offline, busy, away, none }

/// Ring thickness level.
enum AvatarRingSize { sm, md, lg }

// ─── Widget ──────────────────────────────────────────────────────────────────

/// Avatar widget with image / initials / icon fallback strategies,
/// optional ring wrapper and status dot indicator.
///
/// Usage:
/// ```dart
/// CustomAvatarWidget(
///   name: 'Mario Rossi',
///   size: AvatarSize.md,
///   variant: AvatarVariant.primary,
///   dotStatus: AvatarDotStatus.online,
/// )
/// ```
class CustomAvatarWidget extends StatefulWidget {
  const CustomAvatarWidget({
    super.key,
    this.src,
    this.alt,
    this.name,
    this.size = AvatarSize.md,
    this.shape = AvatarShape.circle,
    this.variant = AvatarVariant.primary,
    this.darkTheme = false,
    this.showRing = false,
    this.ringSize = AvatarRingSize.md,
    this.ringColor,
    this.ringGap = true,
    this.dotStatus = AvatarDotStatus.none,
    this.clickable = false,
    this.ariaLabel,
    this.onTap,
  });

  /// Image URL. Falls back to initials or icon if null / load error.
  final String? src;

  /// Accessibility label. Falls back to [name] then 'Avatar'.
  final String? alt;

  /// User display name — used for initials generation.
  final String? name;

  final AvatarSize size;
  final AvatarShape shape;
  final AvatarVariant variant;

  /// Enables dark-theme styling (dot border, neutral variant).
  final bool darkTheme;

  /// Wraps the avatar in an outer ring border.
  final bool showRing;

  /// Thickness of the ring border.
  final AvatarRingSize ringSize;

  /// Overrides the ring colour with an explicit [Color].
  final Color? ringColor;

  /// Adds padding between avatar and ring border.
  final bool ringGap;

  /// Presence/status dot shown in the bottom-right corner.
  final AvatarDotStatus dotStatus;

  /// When true the avatar responds to taps with a scale + ink effect.
  final bool clickable;

  /// Explicit semantic label for accessibility.
  final String? ariaLabel;

  /// Callback fired on tap (only when [clickable] is true).
  final VoidCallback? onTap;

  @override
  State<CustomAvatarWidget> createState() => _CustomAvatarWidgetState();
}

class _CustomAvatarWidgetState extends State<CustomAvatarWidget> {
  bool _imgError = false;

  // ── Derived state ───────────────────────────────────────────────────────

  bool get _showImage =>
      widget.src != null && widget.src!.isNotEmpty && !_imgError;
  bool get _showInitials => !_showImage && (widget.name?.isNotEmpty ?? false);

  String get _initials {
    final n = widget.name?.trim() ?? '';
    if (n.isEmpty) return '';
    final parts = n.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  // ── Dimension maps ──────────────────────────────────────────────────────

  double get _dimension => const {
    AvatarSize.xs: 24.0,
    AvatarSize.sm: 32.0,
    AvatarSize.md: 40.0,
    AvatarSize.lg: 52.0,
    AvatarSize.xl: 68.0,
    AvatarSize.xxl: 88.0,
  }[widget.size]!;

  double get _fontSize => const {
    AvatarSize.xs: 9.0,
    AvatarSize.sm: 10.0,
    AvatarSize.md: 13.0,
    AvatarSize.lg: 16.0,
    AvatarSize.xl: 21.0,
    AvatarSize.xxl: 27.0,
  }[widget.size]!;

  double get _iconSize => const {
    AvatarSize.xs: 12.0,
    AvatarSize.sm: 16.0,
    AvatarSize.md: 20.0,
    AvatarSize.lg: 26.0,
    AvatarSize.xl: 32.0,
    AvatarSize.xxl: 40.0,
  }[widget.size]!;

  // ── Shape ───────────────────────────────────────────────────────────────

  BorderRadius get _borderRadius => switch (widget.shape) {
    AvatarShape.circle => BorderRadius.circular(_dimension / 2),
    AvatarShape.rounded => BorderRadius.circular(10),
    AvatarShape.square => BorderRadius.circular(4),
  };

  // ── Variant colours ─────────────────────────────────────────────────────

  ({Color light, Color dark, Color text}) get _variantColors {
    if (widget.darkTheme && widget.variant == AvatarVariant.neutral) {
      return (
        light: AppColors.colorNeutral600,
        dark: AppColors.colorNeutral500,
        text: AppColors.colorNeutral200,
      );
    }
    return switch (widget.variant) {
      AvatarVariant.primary => (
        light: AppColors.colorPrimaryLight,
        dark: AppColors.colorPrimaryDark,
        text: AppColors.colorPrimaryText,
      ),
      AvatarVariant.secondary => (
        light: AppColors.colorSecondaryLight,
        dark: AppColors.colorSecondaryDark,
        text: AppColors.colorSecondaryText,
      ),
      AvatarVariant.tertiary => (
        light: AppColors.colorTertiaryLight,
        dark: AppColors.colorTertiaryDark,
        text: AppColors.colorTertiaryText,
      ),
      AvatarVariant.success => (
        light: AppColors.colorSuccessLight,
        dark: AppColors.colorSuccessDark,
        text: AppColors.colorSuccessText,
      ),
      AvatarVariant.warning => (
        light: AppColors.colorWarningLight,
        dark: AppColors.colorWarningDark,
        text: AppColors.colorWarningText,
      ),
      AvatarVariant.error => (
        light: AppColors.colorErrorLight,
        dark: AppColors.colorErrorDark,
        text: AppColors.colorErrorText,
      ),
      AvatarVariant.info => (
        light: AppColors.colorInfoLight,
        dark: AppColors.colorInfoDark,
        text: AppColors.colorInfoText,
      ),
      AvatarVariant.neutral => (
        light: AppColors.colorNeutral200,
        dark: AppColors.colorNeutral300,
        text: AppColors.colorNeutral500,
      ),
    };
  }

  Color get _ringDefaultColor => switch (widget.variant) {
    AvatarVariant.primary => AppColors.colorPrimaryDark,
    AvatarVariant.secondary => AppColors.colorSecondaryDark,
    AvatarVariant.tertiary => AppColors.colorTertiaryDark,
    AvatarVariant.success => AppColors.colorSuccessDark,
    AvatarVariant.warning => AppColors.colorWarningDark,
    AvatarVariant.error => AppColors.colorErrorDark,
    AvatarVariant.info => AppColors.colorInfoDark,
    AvatarVariant.neutral => AppColors.colorNeutral400,
  };

  // ── Status dot ──────────────────────────────────────────────────────────

  Color get _dotColor => switch (widget.dotStatus) {
    AvatarDotStatus.online => AppColors.colorSuccessDark,
    AvatarDotStatus.offline => AppColors.colorNeutral400,
    AvatarDotStatus.busy => AppColors.colorErrorDark,
    AvatarDotStatus.away => AppColors.colorWarningDark,
    AvatarDotStatus.none => Colors.transparent,
  };

  double get _dotSize => const {
    AvatarSize.xs: 6.0,
    AvatarSize.sm: 8.0,
    AvatarSize.md: 10.0,
    AvatarSize.lg: 13.0,
    AvatarSize.xl: 16.0,
    AvatarSize.xxl: 20.0,
  }[widget.size]!;

  double get _dotBorderWidth => const {
    AvatarSize.xs: 1.5,
    AvatarSize.sm: 2.0,
    AvatarSize.md: 2.0,
    AvatarSize.lg: 2.0,
    AvatarSize.xl: 2.5,
    AvatarSize.xxl: 3.0,
  }[widget.size]!;

  Color get _dotBorderColor =>
      widget.darkTheme ? AppColors.colorNeutral900 : Colors.white;

  // ── Ring wrapper ────────────────────────────────────────────────────────

  ({double border, double padding}) get _ringSizes => switch (widget.ringSize) {
    AvatarRingSize.sm => (border: 2.0, padding: 2.0),
    AvatarRingSize.md => (border: 3.0, padding: 3.0),
    AvatarRingSize.lg => (border: 4.0, padding: 3.0),
  };

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final avatar = _buildAvatar();
    if (widget.showRing) return _buildRingWrap(avatar);
    return avatar;
  }

  Widget _buildAvatar() {
    final colors = _variantColors;
    final size = _dimension;
    final semanticLabel = widget.ariaLabel ?? widget.name ?? 'Avatar';

    Widget content = SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Avatar body ──────────────────────────────────────────────
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: _showImage
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.light, colors.dark],
                    ),
              borderRadius: _borderRadius,
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildFallbackContent(colors.text),
          ),

          // ── Status dot ───────────────────────────────────────────────
          if (widget.dotStatus != AvatarDotStatus.none)
            Positioned(
              bottom: widget.size == AvatarSize.xs ? -1 : 0,
              right: widget.size == AvatarSize.xs ? -1 : 0,
              child: Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: _dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _dotBorderColor,
                    width: _dotBorderWidth,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    // ── Clickable wrapper ──────────────────────────────────────────────
    if (widget.clickable) {
      content = Semantics(
        label: semanticLabel,
        button: true,
        child: Material(
          color: Colors.transparent,
          borderRadius: _borderRadius,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: _borderRadius,
            hoverColor: Colors.black.withValues(alpha: 0.08),
            splashColor: Colors.black.withValues(alpha: 0.12),
            child: content,
          ),
        ),
      );
    } else {
      content = Semantics(label: semanticLabel, child: content);
    }

    return content;
  }

  /// Renders the inner content: image, initials, or icon.
  Widget _buildFallbackContent(Color textColor) {
    if (_showImage) {
      final src = widget.src!;
      if (src.startsWith('data:image/')) {
        final commaIndex = src.indexOf(',');
        if (commaIndex != -1) {
          return Image.memory(
            base64Decode(src.substring(commaIndex + 1)),
            width: _dimension,
            height: _dimension,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          );
        }
      }

      return Image.network(
        src,
        width: _dimension,
        height: _dimension,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _imgError = true);
          });
          return const SizedBox.shrink();
        },
      );
    }
    if (_showInitials) {
      return Center(
        child: Text(
          _initials,
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.03 * _fontSize,
            height: 1,
            color: textColor,
          ),
        ),
      );
    }

    // Icon fallback
    return Center(
      child: Icon(
        LucideIcons.userRound,
        size: _iconSize,
        color: textColor.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildRingWrap(Widget avatar) {
    final rs = _ringSizes;
    final ringColor = widget.ringColor ?? _ringDefaultColor;
    final bgColor = widget.darkTheme ? const Color(0xFF1A2030) : Colors.white;

    return Container(
      padding: EdgeInsets.all(widget.ringGap ? rs.padding : 0),
      decoration: BoxDecoration(
        shape: widget.shape == AvatarShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: widget.shape != AvatarShape.circle ? _borderRadius : null,
        border: Border.all(color: ringColor, width: rs.border),
        color: bgColor,
      ),
      child: avatar,
    );
  }
}
