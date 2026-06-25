import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/orientation_static_data.dart';
import '../../domain/entities/orientation_answer_entity.dart';
import '../../domain/entities/orientation_result_entity.dart';
import '../../domain/entities/orientation_topic_entity.dart';
import '../../domain/services/orientation_scoring_service.dart';

class OrientationState {
  const OrientationState({this.activeTopicIndex = 0, this.answers = const {}});

  final int activeTopicIndex;
  final Map<String, OrientationAnswerEntity> answers;

  OrientationState copyWith({
    int? activeTopicIndex,
    Map<String, OrientationAnswerEntity>? answers,
  }) {
    return OrientationState(
      activeTopicIndex: activeTopicIndex ?? this.activeTopicIndex,
      answers: answers ?? this.answers,
    );
  }
}

class OrientationController extends Notifier<OrientationState> {
  @override
  OrientationState build() => const OrientationState();

  void setActiveTopic(int index) {
    if (index < 0 || index >= OrientationStaticData.topics.length) return;
    state = state.copyWith(activeTopicIndex: index);
  }

  void saveAnswer({
    required String questionId,
    required String topicId,
    required String value,
    required String label,
  }) {
    state = state.copyWith(
      answers: Map.unmodifiable({
        ...state.answers,
        questionId: OrientationAnswerEntity(
          questionId: questionId,
          topicId: topicId,
          value: value,
          label: label,
        ),
      }),
    );
  }

  void clearAnswer(String questionId) {
    final answers = Map<String, OrientationAnswerEntity>.from(state.answers)
      ..remove(questionId);
    state = state.copyWith(answers: Map.unmodifiable(answers));
  }

  void reset() => state = const OrientationState();

  void nextTopic() => setActiveTopic(state.activeTopicIndex + 1);

  void previousTopic() => setActiveTopic(state.activeTopicIndex - 1);
}

final orientationControllerProvider =
    NotifierProvider<OrientationController, OrientationState>(
      OrientationController.new,
    );

class OrientationQuestionStageController extends Notifier<bool> {
  @override
  bool build() => false;

  void showQuestions() => state = true;

  void showContent() => state = false;
}

final orientationQuestionStageProvider =
    NotifierProvider<OrientationQuestionStageController, bool>(
      OrientationQuestionStageController.new,
    );

final orientationTopicsProvider = Provider<List<OrientationTopicEntity>>((ref) {
  return OrientationStaticData.topics;
});

final activeOrientationTopicIndexProvider = Provider<int>((ref) {
  return ref.watch(orientationControllerProvider).activeTopicIndex;
});

final activeOrientationTopicProvider = Provider<OrientationTopicEntity>((ref) {
  final topics = ref.watch(orientationTopicsProvider);
  final index = ref.watch(activeOrientationTopicIndexProvider);
  return topics[index];
});

final orientationAnswersProvider =
    Provider<Map<String, OrientationAnswerEntity>>((ref) {
      return ref.watch(orientationControllerProvider).answers;
    });

final orientationAnsweredCountProvider = Provider<int>((ref) {
  return ref.watch(orientationAnswersProvider).length;
});

final orientationTotalQuestionsProvider = Provider<int>((ref) {
  return ref
      .watch(orientationTopicsProvider)
      .fold(0, (total, topic) => total + topic.questions.length);
});

final orientationCompletionProvider = Provider<double>((ref) {
  final total = ref.watch(orientationTotalQuestionsProvider);
  if (total == 0) return 0;
  return (ref.watch(orientationAnsweredCountProvider) / total).clamp(0, 1);
});

final orientationIsCompleteProvider = Provider<bool>((ref) {
  return ref.watch(orientationAnsweredCountProvider) ==
      ref.watch(orientationTotalQuestionsProvider);
});

final orientationResultProvider = Provider<OrientationResultEntity?>((ref) {
  if (!ref.watch(orientationIsCompleteProvider)) return null;
  return const OrientationScoringService().calculate(
    ref.watch(orientationAnswersProvider).values,
  );
});
