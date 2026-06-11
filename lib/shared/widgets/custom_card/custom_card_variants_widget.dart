import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../custom_avatar/custom_avatar_widget.dart';
import 'custom_card_widget.dart';

// ─────────────────────────────────────────────
// Shared data models
// ─────────────────────────────────────────────

/// Reviewer data for [CardReviewWidget].
class CardReviewer {
  const CardReviewer({
    required this.name,
    required this.university,
    this.avatarSrc,
  });

  final String name;
  final String university;
  final String? avatarSrc;
}

/// Team member data for [CardTeamWidget].
class CardTeamMember {
  const CardTeamMember({
    required this.name,
    required this.role,
    this.avatarSrc,
  });

  final String name;
  final String role;
  final String? avatarSrc;
}

/// Trend indicator for [CardStatWidget].
class StatTrend {
  const StatTrend({required this.direction, required this.value});

  final StatTrendDirection direction;
  final String value;
}

/// Direction of a [StatTrend].
enum StatTrendDirection { up, down, neutral }

/// Status variant for [CardStatusWidget].
enum StatusVariant { success, warning, error, info, neutral }

// ─────────────────────────────────────────────
// Icon box helper
// ─────────────────────────────────────────────

/// Gradient icon box shared across card variants.
class _CardIconBox extends StatelessWidget {
  const _CardIconBox({
    required this.icon,
    required this.variant,
    this.size = 48,
    this.iconSize = 22,
    this.borderRadius,
  });

  final IconData icon;
  final CardVariant variant;
  final double size;
  final double iconSize;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final (gradient, iconColor) = _resolveColors(variant);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? size * 0.25),
      ),
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }

  static (Gradient, Color) _resolveColors(CardVariant v) => switch (v) {
    CardVariant.secondary => (
    LinearGradient(colors: [AppColors.colorSecondaryLight, AppColors.colorSecondaryDark]),
    AppColors.colorSecondaryText,
    ),
    CardVariant.tertiary => (
    LinearGradient(colors: [AppColors.colorTertiaryLight, AppColors.colorTertiaryDark]),
    AppColors.colorTertiaryText,
    ),
    CardVariant.success => (
    LinearGradient(colors: [AppColors.colorSuccessLight, AppColors.colorSuccessDark]),
    AppColors.colorSuccessText,
    ),
    CardVariant.warning => (
    LinearGradient(colors: [AppColors.colorWarningLight, AppColors.colorWarningDark]),
    AppColors.colorWarningText,
    ),
    CardVariant.error => (
    LinearGradient(colors: [AppColors.colorErrorLight, AppColors.colorErrorDark]),
    AppColors.colorErrorText,
    ),
    CardVariant.info => (
    LinearGradient(colors: [AppColors.colorInfoLight, AppColors.colorInfoDark]),
    AppColors.colorInfoText,
    ),
    CardVariant.neutral => (
    LinearGradient(colors: [AppColors.colorNeutral200, AppColors.colorNeutral200]),
    AppColors.colorNeutral500,
    ),
    _ => (
    LinearGradient(colors: [AppColors.colorPrimaryLight, AppColors.colorPrimaryDark]),
    AppColors.colorPrimaryText,
    ),
  };
}

// ─────────────────────────────────────────────
// Status icon box (uses StatusVariant)
// ─────────────────────────────────────────────

class _StatusIconBox extends StatelessWidget {
  const _StatusIconBox({required this.icon, required this.variant});

  final IconData icon;
  final StatusVariant variant;

  @override
  Widget build(BuildContext context) {
    final (gradient, iconColor) = switch (variant) {
      StatusVariant.warning => (
      LinearGradient(colors: [AppColors.colorWarningLight, AppColors.colorWarningDark]),
      AppColors.colorWarningText,
      ),
      StatusVariant.error => (
      LinearGradient(colors: [AppColors.colorErrorLight, AppColors.colorErrorDark]),
      AppColors.colorErrorText,
      ),
      StatusVariant.info => (
      LinearGradient(colors: [AppColors.colorInfoLight, AppColors.colorInfoDark]),
      AppColors.colorInfoText,
      ),
      StatusVariant.neutral => (
      LinearGradient(colors: [AppColors.colorNeutral200, AppColors.colorNeutral200]),
      AppColors.colorNeutral500,
      ),
      StatusVariant.success => (
      LinearGradient(colors: [AppColors.colorSuccessLight, AppColors.colorSuccessDark]),
      AppColors.colorSuccessText,
      ),
    };

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}

// ─────────────────────────────────────────────
// CardSimpleWidget
// ─────────────────────────────────────────────

/// Lightweight card with optional icon, title, body text and projected content.
///
/// ```dart
/// CardSimpleWidget(
///   icon: LucideIcons.bookOpen,
///   title: 'Materiali',
///   body: 'Accedi alle dispense del corso.',
///   variant: CardVariant.primary,
///   hoverable: true,
///   onTap: () {},
/// )
/// ```
class CardSimpleWidget extends StatelessWidget {
  const CardSimpleWidget({
    super.key,
    this.icon,
    this.iconSize = 22,
    this.title,
    this.body,
    this.variant = CardVariant.defaultVariant,
    this.padding = CardPadding.md,
    this.shadow = CardShadow.md,
    this.radius = CardRadius.md,
    this.bordered = true,
    this.hoverable = false,
    this.clickable = false,
    this.accentBar = false,
    this.stretchHeight = false,
    this.darkTheme,
    this.onTap,
    this.child,
  });

  final IconData? icon;
  final double iconSize;
  final String? title;
  final String? body;
  final CardVariant variant;
  final CardPadding padding;
  final CardShadow shadow;
  final CardRadius radius;
  final bool bordered;
  final bool hoverable;
  final bool clickable;
  final bool accentBar;
  final bool stretchHeight;
  final bool? darkTheme;
  final VoidCallback? onTap;

  /// Optional extra content rendered below body text.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isDark =
        darkTheme ?? (Theme.of(context).brightness == Brightness.dark);
    final titleColor =
    isDark ? AppColors.colorNeutral100 : AppColors.colorNeutral900;
    final bodyColor =
    isDark ? AppColors.colorNeutral400 : AppColors.colorNeutral500;

    return CustomCardWidget(
      variant: variant,
      padding: padding,
      shadow: shadow,
      radius: radius,
      bordered: bordered,
      hoverable: hoverable,
      clickable: clickable || onTap != null,
      accentBar: accentBar,
      stretchHeight: stretchHeight,
      darkTheme: darkTheme,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            _CardIconBox(icon: icon!, variant: variant, iconSize: iconSize),
            const SizedBox(height: 12),
          ],
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: titleColor,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
          ],
          if (body != null) ...[
            Text(
              body!,
              style: TextStyle(
                fontSize: 14,
                color: bodyColor,
                height: 1.6,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 8),
            child!,
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CardMinimalWidget
// ─────────────────────────────────────────────

/// Compact horizontal card: optional icon + title + subtitle + projected content.
///
/// ```dart
/// CardMinimalWidget(
///   icon: LucideIcons.calendar,
///   title: 'Prossimo appello',
///   subtitle: '15 Giugno 2025',
///   variant: CardVariant.info,
/// )
/// ```
class CardMinimalWidget extends StatelessWidget {
  const CardMinimalWidget({
    super.key,
    this.icon,
    this.iconSize = 20,
    this.title,
    this.subtitle,
    this.variant = CardVariant.defaultVariant,
    this.padding = CardPadding.md,
    this.shadow = CardShadow.md,
    this.radius = CardRadius.md,
    this.bordered = true,
    this.hoverable = false,
    this.clickable = false,
    this.stretchHeight = false,
    this.darkTheme,
    this.onTap,
    this.child,
  });

  final IconData? icon;
  final double iconSize;
  final String? title;
  final String? subtitle;
  final CardVariant variant;
  final CardPadding padding;
  final CardShadow shadow;
  final CardRadius radius;
  final bool bordered;
  final bool hoverable;
  final bool clickable;
  final bool stretchHeight;
  final bool? darkTheme;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isDark =
        darkTheme ?? (Theme.of(context).brightness == Brightness.dark);
    final titleColor =
    isDark ? AppColors.colorNeutral100 : AppColors.colorNeutral900;
    final subtitleColor =
    isDark ? AppColors.colorNeutral400 : AppColors.colorNeutral500;

    return CustomCardWidget(
      variant: variant,
      padding: padding,
      shadow: shadow,
      radius: radius,
      bordered: bordered,
      hoverable: hoverable,
      clickable: clickable || onTap != null,
      stretchHeight: stretchHeight,
      darkTheme: darkTheme,
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            _CardIconBox(icon: icon!, variant: variant, size: 44, iconSize: iconSize, borderRadius: 10),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      height: 1.3,
                    ),
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                      height: 1.4,
                    ),
                  ),
                ],
                if (child != null) ...[
                  const SizedBox(height: 4),
                  child!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CardStatWidget
// ─────────────────────────────────────────────

/// Statistic card: icon, prefix + value + suffix, label, optional trend.
///
/// ```dart
/// CardStatWidget(
///   value: '28.4',
///   label: 'Media ponderata',
///   suffix: '/30',
///   icon: LucideIcons.graduationCap,
///   trend: StatTrend(direction: StatTrendDirection.up, value: '+0.3'),
///   variant: CardVariant.primary,
///   accentBar: true,
/// )
/// ```
class CardStatWidget extends StatelessWidget {
  const CardStatWidget({
    super.key,
    required this.value,
    required this.label,
    this.prefix,
    this.suffix,
    this.icon,
    this.trend,
    this.variant = CardVariant.defaultVariant,
    this.padding = CardPadding.md,
    this.shadow = CardShadow.md,
    this.radius = CardRadius.md,
    this.bordered = true,
    this.accentBar = false,
    this.stretchHeight = false,
    this.darkTheme,
  });

  final String value;
  final String label;
  final String? prefix;
  final String? suffix;
  final IconData? icon;
  final StatTrend? trend;
  final CardVariant variant;
  final CardPadding padding;
  final CardShadow shadow;
  final CardRadius radius;
  final bool bordered;
  final bool accentBar;
  final bool stretchHeight;
  final bool? darkTheme;

  @override
  Widget build(BuildContext context) {
    final isDark =
        darkTheme ?? (Theme.of(context).brightness == Brightness.dark);
    final valueColor =
    isDark ? AppColors.colorNeutral100 : AppColors.colorNeutral900;
    final metaColor =
    isDark ? AppColors.colorNeutral400 : AppColors.colorNeutral500;

    Color trendColor(StatTrendDirection d) => switch (d) {
      StatTrendDirection.up => AppColors.colorSuccessDark,
      StatTrendDirection.down => AppColors.colorErrorDark,
      StatTrendDirection.neutral => AppColors.colorNeutral400,
    };

    String trendArrow(StatTrendDirection d) => switch (d) {
      StatTrendDirection.up => '↑',
      StatTrendDirection.down => '↓',
      StatTrendDirection.neutral => '→',
    };

    return CustomCardWidget(
      variant: variant,
      padding: padding,
      shadow: shadow,
      radius: radius,
      bordered: bordered,
      accentBar: accentBar,
      stretchHeight: stretchHeight,
      darkTheme: darkTheme,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            _CardIconBox(icon: icon!, variant: variant, size: 40, iconSize: 20, borderRadius: 10),
            const SizedBox(height: 10),
          ],
          // value row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (prefix != null)
                Text(
                  prefix!,
                  style: TextStyle(
                    fontSize: 17.6,
                    fontWeight: FontWeight.w700,
                    color: metaColor,
                  ),
                ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                  height: 1,
                ),
              ),
              if (suffix != null)
                Text(
                  suffix!,
                  style: TextStyle(
                    fontSize: 17.6,
                    fontWeight: FontWeight.w700,
                    color: metaColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: metaColor,
            ),
          ),
          if (trend != null) ...[
            const SizedBox(height: 6),
            Text(
              '${trendArrow(trend!.direction)} ${trend!.value}',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: trendColor(trend!.direction),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CardStatusWidget
// ─────────────────────────────────────────────

/// Status/feedback card with icon, title and description.
/// Always renders with accent bar on the left.
///
/// ```dart
/// CardStatusWidget(
///   statusVariant: StatusVariant.warning,
///   icon: LucideIcons.alertTriangle,
///   title: 'Scadenza imminente',
///   description: 'Hai 3 giorni per pagare le tasse.',
/// )
/// ```
class CardStatusWidget extends StatelessWidget {
  const CardStatusWidget({
    super.key,
    required this.statusVariant,
    this.icon,
    this.title,
    this.description,
    this.padding = CardPadding.md,
    this.shadow = CardShadow.md,
    this.radius = CardRadius.md,
    this.bordered = true,
    this.hoverable = false,
    this.clickable = false,
    this.stretchHeight = false,
    this.darkTheme,
    this.onTap,
    this.child,
  });

  final StatusVariant statusVariant;
  final IconData? icon;
  final String? title;
  final String? description;
  final CardPadding padding;
  final CardShadow shadow;
  final CardRadius radius;
  final bool bordered;
  final bool hoverable;
  final bool clickable;
  final bool stretchHeight;
  final bool? darkTheme;
  final VoidCallback? onTap;
  final Widget? child;

  CardVariant get _cardVariant => switch (statusVariant) {
    StatusVariant.success => CardVariant.success,
    StatusVariant.warning => CardVariant.warning,
    StatusVariant.error => CardVariant.error,
    StatusVariant.info => CardVariant.info,
    StatusVariant.neutral => CardVariant.neutral,
  };

  @override
  Widget build(BuildContext context) {
    final isDark =
        darkTheme ?? (Theme.of(context).brightness == Brightness.dark);
    final titleColor =
    isDark ? AppColors.colorNeutral100 : AppColors.colorNeutral900;
    final descColor =
    isDark ? AppColors.colorNeutral400 : AppColors.colorNeutral500;

    return CustomCardWidget(
      variant: _cardVariant,
      padding: padding,
      shadow: shadow,
      radius: radius,
      bordered: bordered,
      accentBar: true,
      hoverable: hoverable,
      clickable: clickable || onTap != null,
      stretchHeight: stretchHeight,
      darkTheme: darkTheme,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            _StatusIconBox(icon: icon!, variant: statusVariant),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 14.4,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      height: 1.3,
                    ),
                  ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: descColor,
                      height: 1.5,
                    ),
                  ),
                ],
                if (child != null) ...[
                  const SizedBox(height: 8),
                  child!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CardReviewWidget
// ─────────────────────────────────────────────

/// Review / testimonial card with star rating, body text and reviewer info.
///
/// ```dart
/// CardReviewWidget(
///   rating: 4.5,
///   body: "L'app mi ha salvato durante la sessione!",
///   reviewer: CardReviewer(name: 'Marco R.', university: 'Unibo'),
///   verified: true,
/// )
/// ```
class CardReviewWidget extends StatelessWidget {
  const CardReviewWidget({
    super.key,
    required this.rating,
    required this.body,
    required this.reviewer,
    this.verified = false,
    this.showRatingNumber = true,
    this.padding = CardPadding.md,
    this.shadow = CardShadow.md,
    this.radius = CardRadius.md,
    this.bordered = true,
    this.hoverable = false,
    this.stretchHeight = false,
    this.darkTheme,
  });

  /// Rating from 0 to 5. Supports half stars.
  final double rating;
  final String body;
  final CardReviewer reviewer;
  final bool verified;
  final bool showRatingNumber;
  final CardPadding padding;
  final CardShadow shadow;
  final CardRadius radius;
  final bool bordered;
  final bool hoverable;
  final bool stretchHeight;
  final bool? darkTheme;

  List<_StarState> get _stars => List.generate(5, (i) {
    if (i + 1 <= rating.floor()) return _StarState.full;
    if (i < rating) return _StarState.half;
    return _StarState.empty;
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        darkTheme ?? (Theme.of(context).brightness == Brightness.dark);
    final bodyColor =
    isDark ? AppColors.colorNeutral300 : AppColors.colorNeutral600;
    final nameColor =
    isDark ? AppColors.colorNeutral200 : AppColors.colorNeutral900;
    final uniColor = isDark ? AppColors.colorNeutral400 : AppColors.colorNeutral500;
    final ratingNumColor = isDark ? AppColors.colorNeutral400 : AppColors.colorNeutral500;

    return CustomCardWidget(
      padding: padding,
      shadow: shadow,
      radius: radius,
      bordered: bordered,
      hoverable: hoverable,
      stretchHeight: stretchHeight,
      darkTheme: darkTheme,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars
          Row(
            children: [
              ..._stars.map((s) => _StarIcon(state: s)),
              if (showRatingNumber) ...[
                const SizedBox(width: 6),
                Text(
                  '$rating',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: ratingNumColor,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Body
          Flexible(
            child: Text(
              '"$body"',
              style: TextStyle(
                fontSize: 14,
                color: bodyColor,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Reviewer
          Row(
            children: [
              CustomAvatarWidget(
                name: reviewer.name,
                src: reviewer.avatarSrc ?? '',
                variant: AvatarVariant.primary,
                size: AvatarSize.sm,
                shape: AvatarShape.circle,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          reviewer.name,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: nameColor,
                          ),
                        ),
                        if (verified) ...[
                          const SizedBox(width: 6),
                          Text(
                            '✓',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.colorSuccessDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reviewer.university,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: uniColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _StarState { full, half, empty }

class _StarIcon extends StatelessWidget {
  const _StarIcon({required this.state});
  final _StarState state;

  @override
  Widget build(BuildContext context) {
    final color = state == _StarState.empty
        ? AppColors.colorNeutral300
        : AppColors.colorWarningDark;
    return Opacity(
      opacity: state == _StarState.half ? 0.5 : 1,
      child: Text(
        '★',
        style: TextStyle(fontSize: 17.6, color: color),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CardTeamWidget
// ─────────────────────────────────────────────

/// Team member card: avatar, name, role, optional description.
///
/// ```dart
/// CardTeamWidget(
///   member: CardTeamMember(name: 'Giulia M.', role: 'Frontend Developer'),
///   description: 'Appassionata di Flutter e design systems.',
///   hoverable: true,
/// )
/// ```
class CardTeamWidget extends StatelessWidget {
  const CardTeamWidget({
    super.key,
    required this.member,
    this.description,
    this.padding = CardPadding.md,
    this.shadow = CardShadow.md,
    this.radius = CardRadius.md,
    this.bordered = true,
    this.hoverable = false,
    this.stretchHeight = false,
    this.darkTheme,
    this.child,
  });

  final CardTeamMember member;
  final String? description;
  final CardPadding padding;
  final CardShadow shadow;
  final CardRadius radius;
  final bool bordered;
  final bool hoverable;
  final bool stretchHeight;
  final bool? darkTheme;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isDark =
        darkTheme ?? (Theme.of(context).brightness == Brightness.dark);
    final nameColor =
    isDark ? AppColors.colorNeutral100 : AppColors.colorNeutral900;
    final roleColor =
    isDark ? AppColors.colorNeutral400 : AppColors.colorNeutral500;
    final descColor =
    isDark ? AppColors.colorNeutral400 : AppColors.colorNeutral500;

    return CustomCardWidget(
      padding: padding,
      shadow: shadow,
      radius: radius,
      bordered: bordered,
      hoverable: hoverable,
      stretchHeight: stretchHeight,
      darkTheme: darkTheme,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomAvatarWidget(
                name: member.name,
                src: member.avatarSrc ?? '',
                variant: AvatarVariant.primary,
                size: AvatarSize.md,
                shape: AvatarShape.circle,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: nameColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.role,
                      style: TextStyle(fontSize: 12.5, color: roleColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 14),
            Text(
              description!,
              style: TextStyle(
                fontSize: 13.5,
                color: descColor,
                height: 1.6,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 12),
            child!,
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CardNavWidget
// ─────────────────────────────────────────────

/// Navigation card: icon + title + optional subtitle + animated arrow.
/// Always hoverable. Supports tap callback or GoRouter navigation via [onTap].
///
/// ```dart
/// CardNavWidget(
///   icon: LucideIcons.calendarDays,
///   title: 'Piano di studio',
///   subtitle: 'Visualizza il tuo percorso',
///   variant: CardVariant.primary,
///   onTap: () => context.push(AppRoutes.studyPlan),
/// )
/// ```
class CardNavWidget extends StatefulWidget {
  const CardNavWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.variant = CardVariant.defaultVariant,
    this.padding = CardPadding.md,
    this.shadow = CardShadow.md,
    this.radius = CardRadius.md,
    this.bordered = true,
    this.stretchHeight = false,
    this.darkTheme,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final CardVariant variant;
  final CardPadding padding;
  final CardShadow shadow;
  final CardRadius radius;
  final bool bordered;
  final bool stretchHeight;
  final bool? darkTheme;
  final VoidCallback? onTap;

  @override
  State<CardNavWidget> createState() => _CardNavWidgetState();
}

class _CardNavWidgetState extends State<CardNavWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark =
        widget.darkTheme ?? (Theme.of(context).brightness == Brightness.dark);
    final titleColor =
    isDark ? AppColors.colorNeutral100 : AppColors.colorNeutral900;
    final subtitleColor =
    isDark ? AppColors.colorNeutral400 : AppColors.colorNeutral500;
    final arrowColor = _hovered
        ? AppColors.colorPrimaryDark
        : isDark
        ? AppColors.colorNeutral500
        : AppColors.colorNeutral400;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: CustomCardWidget(
        variant: widget.variant,
        padding: widget.padding,
        shadow: widget.shadow,
        radius: widget.radius,
        bordered: widget.bordered,
        hoverable: true,
        clickable: widget.onTap != null,
        stretchHeight: widget.stretchHeight,
        darkTheme: widget.darkTheme,
        onTap: widget.onTap,
        child: Row(
          children: [
            if (widget.icon != null) ...[
              _CardIconBox(
                icon: widget.icon!,
                variant: widget.variant,
                size: 44,
                iconSize: 20,
                borderRadius: 10,
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle!,
                      style: TextStyle(fontSize: 12.8, color: subtitleColor),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedSlide(
              offset: _hovered ? const Offset(0.15, 0) : Offset.zero,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  LucideIcons.arrowRight,
                  key: ValueKey(arrowColor),
                  size: 20,
                  color: arrowColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}