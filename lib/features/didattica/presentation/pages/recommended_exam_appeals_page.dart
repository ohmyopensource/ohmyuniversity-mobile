import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../shared/widgets/custom_text/custom_text_widget.dart';
import '../../domain/entities/didattica_exam_course_entity.dart';
import '../../domain/entities/recommended_exam_appeal_entity.dart';
import '../providers/exam_appeals_provider.dart';
import '../providers/exam_courses_provider.dart';

class RecommendedExamAppealsPage extends ConsumerWidget {
  const RecommendedExamAppealsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(recommendedExamAppealsProvider);
    final passedCourses =
        ref
            .watch(didatticaExamCoursesProvider)
            .where((course) => course.passed)
            .toList()
          ..sort(_comparePassedCourses);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Appelli consigliati')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
        physics: const BouncingScrollPhysics(),
        children: [
          const _RecommendationIntroCard(),
          const SizedBox(height: 16),
          _SectionHeader(
            icon: LucideIcons.clipboardCheck,
            title: 'Da valutare',
            count: recommendations.length,
          ),
          const SizedBox(height: 10),
          if (recommendations.isEmpty)
            const _EmptyRecommendationsCard()
          else
            for (var index = 0; index < recommendations.length; index++) ...[
              _RecommendedAppealCard(
                recommendation: recommendations[index],
                position: index + 1,
              ),
              if (index != recommendations.length - 1)
                const SizedBox(height: 9),
            ],
          const SizedBox(height: 22),
          _SectionHeader(
            icon: LucideIcons.checkCircle,
            title: 'Esami superati',
            count: passedCourses.length,
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < passedCourses.length; index++) ...[
            _PassedCourseCard(course: passedCourses[index]),
            if (index != passedCourses.length - 1) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }

  int _comparePassedCourses(
    DidatticaExamCourseEntity first,
    DidatticaExamCourseEntity second,
  ) {
    final firstDate =
        first.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final secondDate =
        second.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

    return secondDate.compareTo(firstDate);
  }
}

class _RecommendationIntroCard extends StatelessWidget {
  const _RecommendationIntroCard();

  @override
  Widget build(BuildContext context) {
    return const CustomCardWidget(
      variant: CardVariant.neutral,
      padding: CardPadding.sm,
      shadow: CardShadow.none,
      radius: CardRadius.lg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBubble(
            icon: LucideIcons.sparkles,
            backgroundColor: AppColors.colorPrimaryLight,
            iconColor: AppColors.colorPrimaryDark,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: 'Priorita automatica',
                  variant: TextVariant.label,
                  weight: TextWeight.extraBold,
                ),
                SizedBox(height: 3),
                CustomTextWidget(
                  text:
                      'Esami mancanti ordinati dal minor numero di CFU al maggiore.',
                  variant: TextVariant.caption,
                  color: TextColor.muted,
                  weight: TextWeight.semibold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.count,
  });

  final IconData icon;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.textPrimary),
        const SizedBox(width: 8),
        Expanded(
          child: CustomTextWidget(
            text: title,
            variant: TextVariant.h6,
            weight: TextWeight.extraBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _CountBadge(count: count),
      ],
    );
  }
}

class _RecommendedAppealCard extends StatelessWidget {
  const _RecommendedAppealCard({
    required this.recommendation,
    required this.position,
  });

  final RecommendedExamAppealEntity recommendation;
  final int position;

  @override
  Widget build(BuildContext context) {
    final course = recommendation.course;
    final status = _AppealStatus.from(recommendation);

    return _SideAccentCard(
      accentColor: status.foregroundColor,
      accentWidth: 6,
      padding: const EdgeInsets.fromLTRB(16, 9, 10, 9),
      child: Row(
        children: [
          _PriorityBadge(position: position),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextWidget(
                  text: course.name,
                  variant: TextVariant.bodySm,
                  weight: TextWeight.extraBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 5,
                  children: [
                    _CreditsBadge(credits: course.credits),
                    _StatusBadge(status: status),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final _AppealStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 116, maxWidth: 156),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: status.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: status.foregroundColor),
          const SizedBox(width: 5),
          Flexible(
            child: CustomTextWidget(
              text: status.label,
              variant: TextVariant.caption,
              color: status.textColor,
              weight: TextWeight.extraBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              noWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _PassedCourseCard extends StatelessWidget {
  const _PassedCourseCard({required this.course});

  final DidatticaExamCourseEntity course;

  @override
  Widget build(BuildContext context) {
    return _SideAccentCard(
      accentColor: AppColors.colorSuccessDark,
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      child: Row(
        children: [
          const _IconBubble(
            icon: LucideIcons.checkCircle,
            backgroundColor: AppColors.colorSuccessLight,
            iconColor: AppColors.colorSuccessDark,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextWidget(
                  text: course.name,
                  variant: TextVariant.bodySm,
                  weight: TextWeight.extraBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                CustomTextWidget(
                  text: '${course.code} - ${course.credits} CFU',
                  variant: TextVariant.caption,
                  color: TextColor.muted,
                  weight: TextWeight.semibold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            constraints: const BoxConstraints(minWidth: 34),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.colorSuccessLight.withValues(alpha: 0.34),
              borderRadius: BorderRadius.circular(999),
            ),
            child: CustomTextWidget(
              text: course.grade ?? '-',
              variant: TextVariant.caption,
              weight: TextWeight.extraBold,
              color: TextColor.success,
              noWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SideAccentCard extends StatelessWidget {
  const _SideAccentCard({
    required this.accentColor,
    required this.child,
    required this.padding,
    this.accentWidth = 5,
  });

  final Color accentColor;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double accentWidth;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.defaultVariant,
      padding: CardPadding.none,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: accentWidth,
              child: ColoredBox(color: accentColor),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

class _EmptyRecommendationsCard extends StatelessWidget {
  const _EmptyRecommendationsCard();

  @override
  Widget build(BuildContext context) {
    return const CustomCardWidget(
      variant: CardVariant.neutral,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      child: Column(
        children: [
          Icon(
            LucideIcons.checkCircle,
            size: 32,
            color: AppColors.colorSuccessDark,
          ),
          SizedBox(height: 10),
          CustomTextWidget(
            text: 'Nessun appello da suggerire',
            variant: TextVariant.h6,
            weight: TextWeight.extraBold,
            align: TextAlign.center,
          ),
          SizedBox(height: 5),
          CustomTextWidget(
            text: 'Non ci sono esami mancanti nel piano attuale.',
            variant: TextVariant.bodySm,
            color: TextColor.muted,
            weight: TextWeight.semibold,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.position});

  final int position;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.colorPrimaryLight.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: AppColors.colorPrimaryDark.withValues(alpha: 0.12),
        ),
      ),
      child: CustomTextWidget(
        text: '$position',
        variant: TextVariant.caption,
        weight: TextWeight.extraBold,
        color: TextColor.primary,
      ),
    );
  }
}

class _CreditsBadge extends StatelessWidget {
  const _CreditsBadge({required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 50),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.colorWarningLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: CustomTextWidget(
        text: '$credits CFU',
        variant: TextVariant.caption,
        color: TextColor.warning,
        weight: TextWeight.extraBold,
        noWrap: true,
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.colorPrimaryLight.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(999),
      ),
      child: CustomTextWidget(
        text: '$count',
        variant: TextVariant.caption,
        color: TextColor.primary,
        weight: TextWeight.extraBold,
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 17, color: iconColor),
    );
  }
}

class _AppealStatus {
  const _AppealStatus({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.textColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final TextColor textColor;

  static _AppealStatus from(RecommendedExamAppealEntity recommendation) {
    if (recommendation.isBookable) {
      return _bookable;
    }
    if (recommendation.isBooked) {
      return _booked;
    }
    if (recommendation.hasAppeal) {
      return _notBookable;
    }
    return _missing;
  }

  static final _bookable = _AppealStatus(
    label: 'Prenotabile',
    icon: LucideIcons.calendarDays,
    backgroundColor: AppColors.colorPrimaryLight.withValues(alpha: 0.42),
    borderColor: AppColors.colorPrimaryDark.withValues(alpha: 0.12),
    foregroundColor: AppColors.colorPrimaryDark,
    textColor: TextColor.primary,
  );

  static final _booked = _AppealStatus(
    label: 'Prenotato',
    icon: LucideIcons.checkCircle,
    backgroundColor: AppColors.colorSuccessLight.withValues(alpha: 0.36),
    borderColor: AppColors.colorSuccessDark.withValues(alpha: 0.12),
    foregroundColor: AppColors.colorSuccessDark,
    textColor: TextColor.success,
  );

  static final _notBookable = _AppealStatus(
    label: 'Non prenotabile',
    icon: LucideIcons.calendarOff,
    backgroundColor: AppColors.colorWarningLight.withValues(alpha: 0.34),
    borderColor: AppColors.colorWarningDark.withValues(alpha: 0.12),
    foregroundColor: AppColors.colorWarningDark,
    textColor: TextColor.warning,
  );

  static final _missing = _AppealStatus(
    label: 'Nessun appello',
    icon: LucideIcons.calendarOff,
    backgroundColor: AppColors.colorNeutral100,
    borderColor: AppColors.colorNeutral200,
    foregroundColor: AppColors.colorNeutral400,
    textColor: TextColor.muted,
  );
}
