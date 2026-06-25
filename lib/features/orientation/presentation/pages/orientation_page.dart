import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../providers/orientation_providers.dart';
import '../widgets/orientation_progress_bar.dart';
import '../widgets/orientation_topic_card.dart';
import 'orientation_result_page.dart';
import 'orientation_summary_page.dart';
import 'orientation_topic_detail_page.dart';
import 'topics/common_mistakes_page.dart';
import 'topics/career_outcomes_page.dart';
import 'topics/university_life_page.dart';

enum _OrientationView { topics, topic, summary, result }

class OrientationPage extends ConsumerStatefulWidget {
  const OrientationPage({super.key});

  @override
  ConsumerState<OrientationPage> createState() => _OrientationPageState();
}

class _OrientationPageState extends ConsumerState<OrientationPage> {
  _OrientationView _view = _OrientationView.topics;

  @override
  Widget build(BuildContext context) {
    final topics = ref.watch(orientationTopicsProvider);
    final answers = ref.watch(orientationAnswersProvider);
    final answeredCount = ref.watch(orientationAnsweredCountProvider);
    final totalCount = ref.watch(orientationTotalQuestionsProvider);
    final progress = ref.watch(orientationCompletionProvider);
    final activeIndex = ref.watch(activeOrientationTopicIndexProvider);
    final showQuestions = ref.watch(orientationQuestionStageProvider);

    if (_view == _OrientationView.topic) {
      final topic = topics[activeIndex];
      void onPrevious() =>
          ref.read(orientationControllerProvider.notifier).previousTopic();
      void onNext() =>
          ref.read(orientationControllerProvider.notifier).nextTopic();
      void onBackToTopics() => setState(() => _view = _OrientationView.topics);
      void onComplete() => setState(() => _view = _OrientationView.summary);

      if (showQuestions) {
        return OrientationTopicDetailPage(
          topic: topic,
          activeIndex: activeIndex,
          totalTopics: topics.length,
          answeredCount: answeredCount,
          totalCount: totalCount,
          onPrevious: onPrevious,
          onNext: onNext,
          onBackToTopics: onBackToTopics,
          onComplete: onComplete,
        );
      }

      switch (topic.id) {
        case 'vita':
          return VitaUniversitariaPage(
            activeIndex: activeIndex,
            totalTopics: topics.length,
            answeredCount: answeredCount,
            totalCount: totalCount,
            onPrevious: onPrevious,
            onNext: onNext,
            onBackToTopics: onBackToTopics,
          );
        case 'sbocchi':
          return SbocchiLavorativiPage(
            activeIndex: activeIndex,
            totalTopics: topics.length,
            answeredCount: answeredCount,
            totalCount: totalCount,
            onPrevious: onPrevious,
            onNext: onNext,
            onBackToTopics: onBackToTopics,
          );
        case 'errori':
          return ErroriComuniPage(
            activeIndex: activeIndex,
            totalTopics: topics.length,
            answeredCount: answeredCount,
            totalCount: totalCount,
            onPrevious: onPrevious,
            onNext: onNext,
            onBackToTopics: onBackToTopics,
          );
        default:
          return OrientationTopicDetailPage(
            topic: topic,
            activeIndex: activeIndex,
            totalTopics: topics.length,
            answeredCount: answeredCount,
            totalCount: totalCount,
            onPrevious: onPrevious,
            onNext: onNext,
            onBackToTopics: onBackToTopics,
            onComplete: onComplete,
          );
      }
    }

    if (_view == _OrientationView.summary) {
      return OrientationSummaryPage(
        onBack: () => setState(() => _view = _OrientationView.topics),
        onShowResult: () => setState(() => _view = _OrientationView.result),
      );
    }

    if (_view == _OrientationView.result) {
      final result = ref.watch(orientationResultProvider);
      if (result != null) {
        return OrientationResultPage(
          result: result,
          onBack: () => setState(() => _view = _OrientationView.summary),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.goNamed(AppRoutes.loginName),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        title: const Text('Orientamento'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 40),
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              'Costruisci una scelta più consapevole',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Rispondi alle domande essenziali su corso, vita universitaria, lavoro e budget.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.colorNeutral500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            OrientationProgressBar(
              answeredCount: answeredCount,
              totalCount: totalCount,
              progress: progress,
            ),
            const SizedBox(height: 14),
            CustomButtonWidget(
              label: answeredCount == 0 ? 'Inizia la guida' : 'Vedi riepilogo',
              icon: LucideIcons.arrowRight,
              iconPosition: ButtonIconPosition.right,
              fullWidth: true,
              onPressed: () {
                if (answeredCount == 0) {
                  ref
                      .read(orientationQuestionStageProvider.notifier)
                      .showContent();
                }
                setState(
                  () => _view = answeredCount == 0
                      ? _OrientationView.topic
                      : _OrientationView.summary,
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Argomenti',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < topics.length; index++) ...[
              OrientationTopicCard(
                topic: topics[index],
                answeredCount: answers.values
                    .where((answer) => answer.topicId == topics[index].id)
                    .length,
                onTap: () {
                  ref
                      .read(orientationControllerProvider.notifier)
                      .setActiveTopic(index);
                  ref
                      .read(orientationQuestionStageProvider.notifier)
                      .showContent();
                  setState(() => _view = _OrientationView.topic);
                },
              ),
              if (index != topics.length - 1) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
