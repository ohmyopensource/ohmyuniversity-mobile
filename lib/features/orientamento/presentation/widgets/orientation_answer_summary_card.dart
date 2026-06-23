import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/orientation_answer_entity.dart';
import '../../domain/entities/orientation_question_entity.dart';
import 'orientation_question_card.dart';

class OrientationAnswerSummaryCard extends StatefulWidget {
  const OrientationAnswerSummaryCard({
    super.key,
    required this.question,
    required this.answer,
    required this.onSelected,
  });

  final OrientationQuestionEntity question;
  final OrientationAnswerEntity? answer;
  final ValueChanged<OrientationOptionEntity> onSelected;

  @override
  State<OrientationAnswerSummaryCard> createState() =>
      _OrientationAnswerSummaryCardState();
}

class _OrientationAnswerSummaryCardState
    extends State<OrientationAnswerSummaryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final answered = widget.answer != null;
    return CustomCardWidget(
      variant: answered ? CardVariant.success : CardVariant.warning,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      clickable: true,
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.question.text,
                      maxLines: _expanded ? 3 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    CustomBadgeWidget(
                      label: widget.answer?.label ?? 'Risposta mancante',
                      variant: answered
                          ? BadgeVariant.success
                          : BadgeVariant.warning,
                      size: BadgeSize.xs,
                      shape: BadgeShape.pill,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                color: AppColors.colorNeutral500,
                size: 18,
              ),
            ],
          ),
          if (_expanded) ...[
            const SizedBox(height: 14),
            OrientationQuestionCard(
              question: widget.question,
              selectedValue: widget.answer?.value,
              onSelected: widget.onSelected,
            ),
          ],
        ],
      ),
    );
  }
}
