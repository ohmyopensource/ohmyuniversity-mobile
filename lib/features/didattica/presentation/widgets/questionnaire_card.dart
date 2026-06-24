import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/course_questionnaire_entity.dart';
import '../utils/exam_booking_formatters.dart';

class QuestionnaireCard extends StatelessWidget {
  const QuestionnaireCard({
    super.key,
    required this.questionnaire,
    this.onFill,
  });

  final CourseQuestionnaireEntity questionnaire;
  final VoidCallback? onFill;

  bool get _completed =>
      questionnaire.status == CourseQuestionnaireStatus.completed;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      key: Key('questionnaire-card-${questionnaire.id}'),
      variant: _completed ? CardVariant.neutral : CardVariant.warning,
      padding: CardPadding.sm,
      shadow: _completed ? CardShadow.none : CardShadow.sm,
      radius: CardRadius.lg,
      accentBar: !_completed,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _completed
                        ? AppColors.colorSuccessLight
                        : AppColors.colorWarningLight,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    _completed
                        ? LucideIcons.clipboardCheck
                        : LucideIcons.clipboardList,
                    size: 17,
                    color: _completed
                        ? AppColors.colorSuccessDark
                        : AppColors.colorWarningDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questionnaire.courseName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.colorNeutral900,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        questionnaire.professor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.colorNeutral500,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_completed) ...[
                  const SizedBox(width: 8),
                  const CustomBadgeWidget(
                    label: 'Completato',
                    variant: BadgeVariant.success,
                    size: BadgeSize.xs,
                    dot: true,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              questionnaire.type,
              style: const TextStyle(
                color: AppColors.colorNeutral500,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                Icon(
                  _completed ? LucideIcons.circleCheck : LucideIcons.clock3,
                  size: 13,
                  color: _completed
                      ? AppColors.colorSuccessDark
                      : AppColors.colorWarningDark,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _dateLabel,
                    style: TextStyle(
                      color: _completed
                          ? AppColors.colorSuccessDark
                          : AppColors.colorWarningDark,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (!_completed) ...[
              const SizedBox(height: 12),
              CustomButtonWidget(
                key: Key('fill-questionnaire-${questionnaire.id}'),
                label: 'Compila questionario',
                icon: LucideIcons.clipboardPen,
                variant: ButtonVariant.warning,
                size: ButtonSize.sm,
                fullWidth: true,
                onPressed: onFill,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String get _dateLabel {
    if (_completed) {
      return 'Compilato il ${formatExamDate(questionnaire.completedAt!)}';
    }
    return 'Scadenza: ${formatExamDate(questionnaire.deadline!)}';
  }
}
