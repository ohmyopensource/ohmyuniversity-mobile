import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/orientation/data/orientation_static_data.dart';
import 'package:ohmyuniversity/features/orientation/presentation/providers/orientation_providers.dart';

void main() {
  ProviderContainer container() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('starts from the first topic with no saved answers', () {
    final ref = container();

    expect(ref.read(activeOrientationTopicIndexProvider), 0);
    expect(ref.read(activeOrientationTopicProvider).id, 'corso');
    expect(ref.read(orientationAnsweredCountProvider), 0);
    expect(ref.read(orientationCompletionProvider), 0);
    expect(ref.read(orientationIsCompleteProvider), isFalse);
    expect(ref.read(orientationResultProvider), isNull);
  });

  test('keeps topic navigation inside the available range', () {
    final ref = container();
    final controller = ref.read(orientationControllerProvider.notifier);

    controller.previousTopic();
    expect(ref.read(activeOrientationTopicIndexProvider), 0);

    controller.setActiveTopic(OrientationStaticData.topics.length - 1);
    expect(
      ref.read(activeOrientationTopicProvider).id,
      OrientationStaticData.topics.last.id,
    );

    controller.nextTopic();
    expect(
      ref.read(activeOrientationTopicIndexProvider),
      OrientationStaticData.topics.length - 1,
    );
  });

  test('saves, replaces and clears answers without duplicating progress', () {
    final ref = container();
    final controller = ref.read(orientationControllerProvider.notifier);

    controller.saveAnswer(
      questionId: 'corso-area',
      topicId: 'corso',
      value: 'ingegneria',
      label: 'Ingegneria & Informatica',
    );

    expect(ref.read(orientationAnsweredCountProvider), 1);
    expect(
      ref.read(orientationAnswersProvider)['corso-area']?.value,
      'ingegneria',
    );

    controller.saveAnswer(
      questionId: 'corso-area',
      topicId: 'corso',
      value: 'scientifica',
      label: 'Scientifica',
    );

    expect(ref.read(orientationAnsweredCountProvider), 1);
    expect(
      ref.read(orientationAnswersProvider)['corso-area']?.value,
      'scientifica',
    );

    controller.clearAnswer('corso-area');
    expect(ref.read(orientationAnswersProvider), isEmpty);
  });

  test(
    'produces a result only after all orientation questions are answered',
    () {
      final ref = container();
      final controller = ref.read(orientationControllerProvider.notifier);

      expect(ref.read(orientationResultProvider), isNull);

      for (final topic in OrientationStaticData.topics) {
        for (final question in topic.questions) {
          final option = question.options.first;
          controller.saveAnswer(
            questionId: question.id,
            topicId: topic.id,
            value: option.value,
            label: option.label,
          );
        }
      }

      final result = ref.read(orientationResultProvider);

      expect(ref.read(orientationIsCompleteProvider), isTrue);
      expect(ref.read(orientationCompletionProvider), 1);
      expect(result, isNotNull);
      expect(result!.topAreas, hasLength(3));
      expect(result.dominantArea.label, isNotEmpty);
    },
  );

  test('toggles the question stage between content and questions', () {
    final ref = container();
    final controller = ref.read(orientationQuestionStageProvider.notifier);

    expect(ref.read(orientationQuestionStageProvider), isFalse);

    controller.showQuestions();
    expect(ref.read(orientationQuestionStageProvider), isTrue);

    controller.showContent();
    expect(ref.read(orientationQuestionStageProvider), isFalse);
  });
}
