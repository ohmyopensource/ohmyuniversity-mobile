import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../providers/orientation_providers.dart';
import '../widgets/orientation_answer_summary_card.dart';

class OrientationSummaryPage extends ConsumerWidget {
  const OrientationSummaryPage({
    super.key,
    required this.onBack,
    required this.onShowResult,
  });

  final VoidCallback onBack;
  final VoidCallback onShowResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(orientationTopicsProvider);
    final answers = ref.watch(orientationAnswersProvider);
    final answeredCount = ref.watch(orientationAnsweredCountProvider);
    final totalCount = ref.watch(orientationTotalQuestionsProvider);
    final complete = ref.watch(orientationIsCompleteProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        title: const Text('Riepilogo risposte'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 110),
        physics: const BouncingScrollPhysics(),
        children: [
          CustomCardWidget(
            variant: complete ? CardVariant.success : CardVariant.warning,
            padding: CardPadding.md,
            shadow: CardShadow.sm,
            radius: CardRadius.lg,
            bordered: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  complete ? LucideIcons.circleCheck : LucideIcons.circleAlert,
                  color: complete
                      ? AppColors.colorSuccessText
                      : AppColors.colorWarningText,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complete ? 'Profilo completo' : 'Profilo incompleto',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        complete
                            ? 'Hai risposto a tutte le domande. Il risultato è pronto.'
                            : 'Completa le domande mancanti prima di vedere il risultato.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.colorNeutral600,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomBadgeWidget(
                  label: '$answeredCount/$totalCount',
                  variant: complete
                      ? BadgeVariant.success
                      : BadgeVariant.warning,
                  size: BadgeSize.sm,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final topic in topics) ...[
            Text(
              topic.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 9),
            for (final question in topic.questions) ...[
              OrientationAnswerSummaryCard(
                question: question,
                answer: answers[question.id],
                onSelected: (option) => ref
                    .read(orientationControllerProvider.notifier)
                    .saveAnswer(
                      questionId: question.id,
                      topicId: topic.id,
                      value: option.value,
                      label: option.label,
                    ),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 12),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.colorNeutral200)),
          ),
          child: CustomButtonWidget(
            label: complete
                ? 'Vedi il tuo risultato'
                : 'Completa le risposte mancanti',
            icon: LucideIcons.sparkles,
            fullWidth: true,
            disabled: !complete,
            onPressed: onShowResult,
          ),
        ),
      ),
    );
  }
}
