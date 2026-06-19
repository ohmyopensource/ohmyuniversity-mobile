import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/didattica_course_type.dart';
import '../../domain/entities/didattica_exam_course_entity.dart';
import '../providers/career_provider.dart';
import 'course_details_sheet.dart';
import 'grade_simulation_sheet.dart';

class CareerExamCard extends ConsumerWidget {
  const CareerExamCard({
    super.key,
    required this.course,
    required this.simulatedGrade,
  });

  final DidatticaExamCourseEntity course;
  final String? simulatedGrade;

  Future<void> _openSimulator(BuildContext context, WidgetRef ref) async {
    final result = await showGradeSimulationSheet(
      context: context,
      courseName: course.name,
      currentGrade: simulatedGrade,
    );
    if (!context.mounted || result == null) return;
    ref
        .read(careerProvider.notifier)
        .setSimulatedGrade(course.id, result == 'remove' ? null : result);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomCardWidget(
      key: Key('career-exam-${course.id}'),
      padding: CardPadding.none,
      shadow: CardShadow.none,
      radius: CardRadius.md,
      child: SizedBox(
        height: 64,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final statusWidth = (constraints.maxWidth * 0.38).clamp(
              92.0,
              132.0,
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppColors.colorNeutral900,
                                fontWeight: FontWeight.w800,
                                height: 1.05,
                              ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.colorNeutral400,
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: statusWidth,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: _ExamStatusActions(
                        course: course,
                        simulatedGrade: simulatedGrade,
                        onSimulate: () => _openSimulator(context, ref),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  CustomButtonWidget(
                    key: Key('course-info-${course.id}'),
                    icon: LucideIcons.info,
                    iconOnly: true,
                    ariaLabel: 'Informazioni su ${course.name}',
                    variant: ButtonVariant.outline,
                    size: ButtonSize.xs,
                    onPressed: () {
                      showCourseDetailsSheet(context: context, course: course);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String get _subtitle {
    final prefix = course.courseType == DidatticaCourseType.elective
        ? 'A scelta · '
        : '';
    return '$prefix${course.code} · ${course.credits} CFU';
  }
}

class _ExamStatusActions extends StatelessWidget {
  const _ExamStatusActions({
    required this.course,
    required this.simulatedGrade,
    required this.onSimulate,
  });

  final DidatticaExamCourseEntity course;
  final String? simulatedGrade;
  final VoidCallback onSimulate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (course.isPropaedeutic) ...[
          const CustomBadgeWidget(
            label: 'Propedeutico',
            icon: LucideIcons.lock,
            variant: BadgeVariant.info,
            size: BadgeSize.xs,
            shape: BadgeShape.rounded,
          ),
          const SizedBox(width: 5),
        ],
        if (course.passed)
          CustomBadgeWidget(
            label: course.grade ?? 'Superato',
            icon: LucideIcons.check,
            variant: BadgeVariant.success,
            size: BadgeSize.sm,
            shape: BadgeShape.rounded,
          )
        else ...[
          if (simulatedGrade != null) ...[
            CustomBadgeWidget(
              label: '~$simulatedGrade',
              variant: BadgeVariant.secondary,
              size: BadgeSize.sm,
              shape: BadgeShape.rounded,
            ),
            const SizedBox(width: 5),
          ],
          CustomButtonWidget(
            key: Key('simulate-${course.id}'),
            icon: LucideIcons.pencil,
            iconOnly: true,
            ariaLabel: simulatedGrade == null
                ? 'Simula voto'
                : 'Modifica voto simulato',
            variant: simulatedGrade == null
                ? ButtonVariant.ghost
                : ButtonVariant.secondary,
            size: ButtonSize.xs,
            onPressed: onSimulate,
          ),
        ],
      ],
    );
  }
}
