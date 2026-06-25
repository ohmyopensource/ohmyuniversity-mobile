import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_toast/custom_toast_service.dart';
import '../../domain/entities/course_questionnaire_entity.dart';
import '../providers/questionnaires_provider.dart';
import '../widgets/questionnaire_card.dart';

class QuestionnairesView extends ConsumerWidget {
  const QuestionnairesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingQuestionnairesProvider);
    final completed = ref.watch(completedQuestionnairesProvider);

    return ListView(
      key: const Key('questionnaires-overview-list'),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 112),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          'Questionari',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.colorNeutral900,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Compila le valutazioni della didattica richieste prima di prenotare gli esami.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.colorNeutral500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(
          icon: LucideIcons.clipboardList,
          title: 'Da compilare',
          count: pending.length,
          variant: BadgeVariant.warning,
          color: AppColors.colorWarningDark,
        ),
        const SizedBox(height: 10),
        if (pending.isEmpty)
          const _AllCompletedCard()
        else
          ..._cards(
            pending,
            onFill: (questionnaire) => ref
                .read(toastServiceProvider.notifier)
                .info(
                  'Il questionario per ${questionnaire.courseName} sarà disponibile tramite il portale ESSE3.',
                ),
          ),
        const SizedBox(height: 12),
        _SectionHeader(
          icon: LucideIcons.clipboardCheck,
          title: 'Compilati',
          count: completed.length,
          variant: BadgeVariant.success,
          color: AppColors.colorSuccessDark,
        ),
        const SizedBox(height: 10),
        ..._cards(completed),
        const SizedBox(height: 4),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.info, size: 13, color: AppColors.colorNeutral400),
            SizedBox(width: 7),
            Expanded(
              child: Text(
                'I questionari compilati non possono essere modificati. La compilazione è obbligatoria per prenotare gli appelli associati.',
                style: TextStyle(
                  color: AppColors.colorNeutral400,
                  fontSize: 11,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Iterable<Widget> _cards(
    List<CourseQuestionnaireEntity> questionnaires, {
    ValueChanged<CourseQuestionnaireEntity>? onFill,
  }) {
    return questionnaires.map(
      (questionnaire) => Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: QuestionnaireCard(
          questionnaire: questionnaire,
          onFill: onFill == null ? null : () => onFill(questionnaire),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.count,
    required this.variant,
    required this.color,
  });

  final IconData icon;
  final String title;
  final int count;
  final BadgeVariant variant;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 7),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.colorNeutral900,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 8),
        CustomBadgeWidget(count: count, variant: variant, size: BadgeSize.xs),
      ],
    );
  }
}

class _AllCompletedCard extends StatelessWidget {
  const _AllCompletedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.colorSuccessLight.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(
            LucideIcons.clipboardCheck,
            size: 19,
            color: AppColors.colorSuccessDark,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Hai compilato tutti i questionari disponibili.',
              style: TextStyle(
                color: AppColors.colorSuccessText,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
