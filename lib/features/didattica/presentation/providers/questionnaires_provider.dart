import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mocks/questionnaires_mock_data.dart';
import '../../domain/entities/course_questionnaire_entity.dart';
import 'career_data_providers.dart';

final remoteQuestionnairesProvider =
    FutureProvider<List<CourseQuestionnaireEntity>>((ref) {
      return ref.watch(didatticaRemoteDataSourceProvider).getQuestionnaires();
    });

final questionnairesProvider = Provider<List<CourseQuestionnaireEntity>>((ref) {
  return ref
      .watch(remoteQuestionnairesProvider)
      .maybeWhen(
        data: (questionnaires) => questionnaires,
        orElse: () => questionnairesMockData,
      );
});

final pendingQuestionnairesProvider = Provider<List<CourseQuestionnaireEntity>>(
  (ref) {
    return ref
        .watch(questionnairesProvider)
        .where(
          (questionnaire) =>
              questionnaire.status == CourseQuestionnaireStatus.pending,
        )
        .toList(growable: false);
  },
);

final completedQuestionnairesProvider =
    Provider<List<CourseQuestionnaireEntity>>((ref) {
      return ref
          .watch(questionnairesProvider)
          .where(
            (questionnaire) =>
                questionnaire.status == CourseQuestionnaireStatus.completed,
          )
          .toList(growable: false);
    });

final isQuestionnaireCompletedProvider = Provider.family<bool, String>((
  ref,
  courseName,
) {
  return ref
      .watch(questionnairesProvider)
      .any(
        (questionnaire) =>
            questionnaire.courseName == courseName &&
            questionnaire.status == CourseQuestionnaireStatus.completed,
      );
});
