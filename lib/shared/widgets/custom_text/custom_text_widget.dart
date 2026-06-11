import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────────────────

/// Typography scale — maps to Angular `TextVariant`.
enum TextVariant {
  display,
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  bodyLg,
  body,
  bodySm,
  caption,
  label,
  overline,
  code,
  blockquote,
}

/// Semantic colour token — maps to Angular `TextColor`.
enum TextColor {
  defaultColor,
  muted,
  subtle,
  primary,
  secondary,
  tertiary,
  success,
  warning,
  error,
  info,
  white,
  inherit,
}

/// Font weight override — maps to Angular `TextWeight`.
enum TextWeight {
  normal,
  medium,
  semibold,
  bold,
  extraBold,
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────────────────────

/// Standardised typography widget — use this everywhere instead of raw [Text].
///
/// Direct Flutter migration of `CustomTextComponent` (Angular).
///
/// ### Usage
/// ```dart
/// CustomTextWidget(text: 'Titolo', variant: TextVariant.h2)
///
/// CustomTextWidget(
///   text: 'Media ponderata',
///   variant: TextVariant.label,
///   color: TextColor.muted,
///   weight: TextWeight.bold,
/// )
///
/// CustomTextWidget(
///   text: 'OhMyUniversity!',
///   variant: TextVariant.display,
///   gradient: true,
/// )
///
/// CustomTextWidget(
///   text: 'Descrizione lunga che si tronca',
///   variant: TextVariant.body,
///   maxLines: 2,
///   overflow: TextOverflow.ellipsis,
/// )
/// ```
class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({
    super.key,
    required this.text,
    this.variant = TextVariant.body,
    this.color = TextColor.defaultColor,
    this.weight,
    this.align,
    this.italic = false,
    this.underline = false,
    this.gradient = false,
    this.noWrap = false,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.semanticsLabel,
  });

  /// The text content to render.
  final String text;

  /// Typography scale variant.
  final TextVariant variant;

  /// Semantic colour token.
  final TextColor color;

  /// Optional font weight override.
  final TextWeight? weight;

  /// Optional text alignment.
  final TextAlign? align;

  /// Applies italic styling.
  final bool italic;

  /// Applies underline decoration.
  final bool underline;

  /// Renders text with a gradient fill (light → dark of the colour token).
  /// Only works on solid variants (not `code` or `blockquote`).
  final bool gradient;

  /// Prevents line wrapping — equivalent to CSS `white-space: nowrap`.
  final bool noWrap;

  /// Limits visible lines — equivalent to CSS `-webkit-line-clamp`.
  final int? maxLines;

  /// Overflow behaviour. Defaults to [TextOverflow.ellipsis] when
  /// [maxLines] is set.
  final TextOverflow? overflow;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// Semantic label for screen readers.
  final String? semanticsLabel;

  // ── Style resolution ───────────────────────────────────────────────────────

  _VariantTokens _variantTokens(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (variant) {
      case TextVariant.display:
        return _VariantTokens(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          height: 1.1,
          letterSpacing: -0.03 * 48,
          defaultColor: isDark
              ? AppColors.colorNeutral100
              : AppColors.textPrimary,
        );
      case TextVariant.h1:
        return _VariantTokens(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: -0.025 * 36,
          defaultColor: isDark
              ? AppColors.colorNeutral100
              : AppColors.textPrimary,
        );
      case TextVariant.h2:
        return _VariantTokens(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.02 * 28,
          defaultColor: isDark
              ? AppColors.colorNeutral100
              : AppColors.textPrimary,
        );
      case TextVariant.h3:
        return _VariantTokens(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: -0.015 * 24,
          defaultColor: isDark
              ? AppColors.colorNeutral100
              : AppColors.textPrimary,
        );
      case TextVariant.h4:
        return _VariantTokens(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.3,
          letterSpacing: -0.01 * 20,
          defaultColor: isDark
              ? AppColors.colorNeutral100
              : AppColors.textPrimary,
        );
      case TextVariant.h5:
        return _VariantTokens(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          height: 1.35,
          letterSpacing: -0.005 * 17,
          defaultColor: isDark
              ? AppColors.colorNeutral100
              : AppColors.textPrimary,
        );
      case TextVariant.h6:
        return _VariantTokens(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 1.4,
          letterSpacing: 0,
          defaultColor: isDark
              ? AppColors.colorNeutral100
              : AppColors.textPrimary,
        );
      case TextVariant.bodyLg:
        return _VariantTokens(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.7,
          letterSpacing: 0,
          defaultColor: isDark
              ? AppColors.colorNeutral300
              : AppColors.colorNeutral500,
        );
      case TextVariant.body:
        return _VariantTokens(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.6,
          letterSpacing: 0,
          defaultColor: isDark
              ? AppColors.colorNeutral300
              : AppColors.colorNeutral600,
        );
      case TextVariant.bodySm:
        return _VariantTokens(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.55,
          letterSpacing: 0,
          defaultColor: isDark
              ? AppColors.colorNeutral300
              : AppColors.colorNeutral500,
        );
      case TextVariant.caption:
        return _VariantTokens(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.01 * 11,
          defaultColor: isDark
              ? AppColors.colorNeutral500
              : AppColors.colorNeutral400,
        );
      case TextVariant.label:
        return _VariantTokens(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.4,
          letterSpacing: 0.01 * 12,
          defaultColor: isDark
              ? AppColors.colorNeutral400
              : AppColors.colorNeutral600,
        );
      case TextVariant.overline:
        return _VariantTokens(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1.4,
          letterSpacing: 0.1 * 10,
          uppercase: true,
          defaultColor: isDark
              ? AppColors.colorNeutral500
              : AppColors.colorNeutral400,
        );
      case TextVariant.code:
        return _VariantTokens(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.6,
          letterSpacing: -0.01 * 13,
          isCode: true,
          defaultColor: isDark
              ? AppColors.colorErrorLight
              : AppColors.colorErrorDark,
        );
      case TextVariant.blockquote:
        return _VariantTokens(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.7,
          letterSpacing: 0,
          isBlockquote: true,
          italic: true,
          defaultColor: isDark
              ? AppColors.colorNeutral400
              : AppColors.colorNeutral500,
        );
    }
  }

  Color _resolveColor(TextColor token, bool isDark) {
    switch (token) {
      case TextColor.defaultColor:
        return Colors.transparent; // handled by variant default
      case TextColor.muted:
        return isDark
            ? AppColors.colorNeutral400
            : AppColors.colorNeutral500;
      case TextColor.subtle:
        return isDark
            ? AppColors.colorNeutral500
            : AppColors.colorNeutral400;
      case TextColor.primary:
        return AppColors.colorPrimaryDark;
      case TextColor.secondary:
        return AppColors.colorSecondaryDark;
      case TextColor.tertiary:
        return AppColors.colorTertiaryDark;
      case TextColor.success:
        return AppColors.colorSuccessDark;
      case TextColor.warning:
        return AppColors.colorWarningDark;
      case TextColor.error:
        return AppColors.colorErrorDark;
      case TextColor.info:
        return AppColors.colorInfoDark;
      case TextColor.white:
        return Colors.white;
      case TextColor.inherit:
        return Colors.transparent; // caller wraps with DefaultTextStyle
    }
  }

  List<Color> _gradientColors(TextColor token) {
    switch (token) {
      case TextColor.secondary:
        return [AppColors.colorSecondaryLight, AppColors.colorSecondaryDark];
      case TextColor.tertiary:
        return [AppColors.colorTertiaryLight, AppColors.colorTertiaryDark];
      case TextColor.success:
        return [AppColors.colorSuccessLight, AppColors.colorSuccessDark];
      case TextColor.warning:
        return [AppColors.colorWarningLight, AppColors.colorWarningDark];
      case TextColor.error:
        return [AppColors.colorErrorLight, AppColors.colorErrorDark];
      case TextColor.info:
        return [AppColors.colorInfoLight, AppColors.colorInfoDark];
      default:
        return [AppColors.colorPrimaryLight, AppColors.colorPrimaryDark];
    }
  }

  FontWeight _resolveWeight(TextWeight w) => switch (w) {
    TextWeight.normal => FontWeight.w400,
    TextWeight.medium => FontWeight.w500,
    TextWeight.semibold => FontWeight.w600,
    TextWeight.bold => FontWeight.w700,
    TextWeight.extraBold => FontWeight.w800,
  };

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = _variantTokens(context);

    final resolvedColor = color == TextColor.defaultColor ||
        color == TextColor.inherit
        ? tokens.defaultColor
        : _resolveColor(color, isDark);

    final fontWeight =
    weight != null ? _resolveWeight(weight!) : tokens.fontWeight;

    final fontStyle =
    (italic || tokens.italic) ? FontStyle.italic : FontStyle.normal;

    final decoration =
    underline ? TextDecoration.underline : TextDecoration.none;

    final effectiveMaxLines = noWrap ? 1 : maxLines;
    final effectiveOverflow = effectiveMaxLines != null
        ? (overflow ?? TextOverflow.ellipsis)
        : overflow;

    final displayText =
    tokens.uppercase ? text.toUpperCase() : text;

    // ── Code variant ────────────────────────────────────────────────────────
    if (tokens.isCode) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 1.5),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.colorNeutral600
              : AppColors.colorNeutral100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isDark
                ? AppColors.colorNeutral500
                : AppColors.colorNeutral200,
          ),
        ),
        child: Text(
          displayText,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: tokens.fontSize,
            fontWeight: fontWeight,
            height: tokens.height,
            letterSpacing: tokens.letterSpacing,
            color: resolvedColor,
            fontStyle: fontStyle,
            decoration: decoration,
            decorationThickness: 1.5,
          ),
          textAlign: align,
          maxLines: effectiveMaxLines,
          overflow: effectiveOverflow,
          softWrap: softWrap,
          semanticsLabel: semanticsLabel,
        ),
      );
    }

    // ── Blockquote variant ───────────────────────────────────────────────────
    if (tokens.isBlockquote) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.colorPrimaryLight
                    : AppColors.colorPrimaryDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: tokens.fontSize,
                  fontWeight: fontWeight,
                  height: tokens.height,
                  letterSpacing: tokens.letterSpacing,
                  color: resolvedColor,
                  fontStyle: FontStyle.italic,
                  decoration: decoration,
                  decorationThickness: 1.5,
                ),
                textAlign: align,
                maxLines: effectiveMaxLines,
                overflow: effectiveOverflow,
                softWrap: softWrap,
                semanticsLabel: semanticsLabel,
              ),
            ),
          ],
        ),
      );
    }

    // ── Gradient variant ─────────────────────────────────────────────────────
    if (gradient) {
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          colors: _gradientColors(color),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: tokens.fontSize,
            fontWeight: fontWeight,
            height: tokens.height,
            letterSpacing: tokens.letterSpacing,
            color: Colors.white, // ShaderMask replaces this
            fontStyle: fontStyle,
            decoration: decoration,
            decorationThickness: 1.5,
          ),
          textAlign: align,
          maxLines: effectiveMaxLines,
          overflow: effectiveOverflow,
          softWrap: softWrap,
          semanticsLabel: semanticsLabel,
        ),
      );
    }

    // ── Standard text ────────────────────────────────────────────────────────
    return Text(
      displayText,
      style: TextStyle(
        fontSize: tokens.fontSize,
        fontWeight: fontWeight,
        height: tokens.height,
        letterSpacing: tokens.letterSpacing,
        color: resolvedColor,
        fontStyle: fontStyle,
        decoration: decoration,
        decorationThickness: 1.5,
      ),
      textAlign: align,
      maxLines: effectiveMaxLines,
      overflow: effectiveOverflow,
      softWrap: softWrap,
      semanticsLabel: semanticsLabel,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal token bundle
// ─────────────────────────────────────────────────────────────────────────────

class _VariantTokens {
  const _VariantTokens({
    required this.fontSize,
    required this.fontWeight,
    required this.height,
    required this.letterSpacing,
    required this.defaultColor,
    this.uppercase = false,
    this.italic = false,
    this.isCode = false,
    this.isBlockquote = false,
  });

  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final double letterSpacing;
  final Color defaultColor;
  final bool uppercase;
  final bool italic;
  final bool isCode;
  final bool isBlockquote;
}