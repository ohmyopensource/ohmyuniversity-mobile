import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../domain/entities/didattica_course_type.dart';
import '../../domain/entities/didattica_exam_course_entity.dart';

Future<void> showCourseDetailsSheet({
  required BuildContext context,
  required DidatticaExamCourseEntity course,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _CourseDetailsSheet(course: course),
  );
}

class _CourseDetailsSheet extends StatelessWidget {
  const _CourseDetailsSheet({required this.course});

  final DidatticaExamCourseEntity course;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.86,
      minChildSize: 0.52,
      maxChildSize: 0.94,
      builder: (context, scrollController) => Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.colorNeutral300,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 14, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.colorNeutral900,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${course.code} · ${course.credits} CFU',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.colorNeutral500,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomButtonWidget(
                    icon: LucideIcons.x,
                    iconOnly: true,
                    ariaLabel: 'Chiudi informazioni corso',
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.sm,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.colorNeutral200),
            Expanded(
              child: ListView(
                key: const Key('course-details-list'),
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                children: [
                  _CourseBadges(course: course),
                  const SizedBox(height: 20),
                  _CourseMetadata(course: course),
                  if (course.prerequisites.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _PrerequisitesCard(prerequisites: course.prerequisites),
                  ],
                  if (course.cfuBreakdown.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    _CfuProgram(course: course),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseBadges extends StatelessWidget {
  const _CourseBadges({required this.course});

  final DidatticaExamCourseEntity course;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        CustomBadgeWidget(
          label: course.courseType == DidatticaCourseType.elective
              ? 'A scelta'
              : 'Obbligatorio',
          variant: course.courseType == DidatticaCourseType.elective
              ? BadgeVariant.secondary
              : BadgeVariant.neutral,
          size: BadgeSize.sm,
        ),
        if (course.isPropaedeutic)
          const CustomBadgeWidget(
            label: 'Propedeutico',
            icon: LucideIcons.lock,
            variant: BadgeVariant.info,
            size: BadgeSize.sm,
          ),
        if (course.passed)
          CustomBadgeWidget(
            label: course.grade ?? 'Superato',
            icon: LucideIcons.check,
            variant: BadgeVariant.success,
            size: BadgeSize.sm,
          ),
      ],
    );
  }
}

class _CourseMetadata extends StatelessWidget {
  const _CourseMetadata({required this.course});

  final DidatticaExamCourseEntity course;

  @override
  Widget build(BuildContext context) {
    final details = [
      ('Lingua', course.language, LucideIcons.languages),
      (
        'Periodo didattico',
        _periodLabel(course.semester),
        LucideIcons.calendar,
      ),
      ('Durata', '${course.durationHours} ore', LucideIcons.clock),
      (
        'Frequenza',
        course.attendanceMandatory ? 'Obbligatoria' : 'Non obbligatoria',
        LucideIcons.users,
      ),
      ('Settore disciplinare', course.scientificSector, LucideIcons.bookOpen),
      ('Sede', course.location, LucideIcons.mapPin),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final columns = constraints.maxWidth >= 560 ? 3 : 2;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final detail in details)
              SizedBox(
                width: width,
                child: _MetadataTile(
                  label: detail.$1,
                  value: detail.$2,
                  icon: detail.$3,
                ),
              ),
          ],
        );
      },
    );
  }

  String _periodLabel(int semester) {
    return semester == 1 ? 'Primo semestre' : 'Secondo semestre';
  }
}

class _MetadataTile extends StatelessWidget {
  const _MetadataTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 78),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.colorNeutral100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.colorPrimaryDark),
          const SizedBox(height: 7),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.colorNeutral400,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.colorNeutral600,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrerequisitesCard extends StatelessWidget {
  const _PrerequisitesCard({required this.prerequisites});

  final List<String> prerequisites;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.colorInfoLight.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Esami propedeutici richiesti',
            style: TextStyle(
              color: AppColors.colorInfoText,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            prerequisites.join(', '),
            style: const TextStyle(
              color: AppColors.colorInfoText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CfuProgram extends StatelessWidget {
  const _CfuProgram({required this.course});

  final DidatticaExamCourseEntity course;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PROGRAMMA PER CFU',
          style: TextStyle(
            color: AppColors.colorNeutral400,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 10),
        for (final item in course.cfuBreakdown) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBadgeWidget(
                label: 'CFU ${item.cfuNumber}',
                variant: BadgeVariant.neutral,
                size: BadgeSize.xs,
                shape: BadgeShape.rounded,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.description,
                  style: const TextStyle(
                    color: AppColors.colorNeutral500,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
        ],
      ],
    );
  }
}
