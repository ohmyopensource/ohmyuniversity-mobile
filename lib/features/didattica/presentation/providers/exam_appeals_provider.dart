import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/exam_appeals_mock_datasource.dart';
import '../../data/repositories/exam_appeals_repository_impl.dart';
import '../../domain/entities/exam_appeal_entity.dart';
import '../../domain/entities/recommended_exam_appeal_entity.dart';
import '../../domain/repositories/exam_appeals_repository.dart';
import '../../domain/usecases/get_exam_appeals_usecase.dart';
import '../../domain/usecases/get_recommended_exam_appeals_usecase.dart';
import 'exam_courses_provider.dart';

final examAppealsMockDataSourceProvider = Provider<ExamAppealsMockDataSource>((
  ref,
) {
  return const ExamAppealsMockDataSource();
});

final examAppealsRepositoryProvider = Provider<ExamAppealsRepository>((ref) {
  return ExamAppealsRepositoryImpl(
    ref.watch(examAppealsMockDataSourceProvider),
  );
});

final getExamAppealsUseCaseProvider = Provider<GetExamAppealsUseCase>((ref) {
  return GetExamAppealsUseCase(ref.watch(examAppealsRepositoryProvider));
});

final examAppealsProvider = Provider<List<ExamAppealEntity>>((ref) {
  return ref.watch(getExamAppealsUseCaseProvider).call();
});

final getRecommendedExamAppealsUseCaseProvider =
    Provider<GetRecommendedExamAppealsUseCase>((ref) {
      return const GetRecommendedExamAppealsUseCase();
    });

final recommendedExamAppealsProvider =
    Provider<List<RecommendedExamAppealEntity>>((ref) {
      return ref
          .watch(getRecommendedExamAppealsUseCaseProvider)
          .call(
            courses: ref.watch(didatticaExamCoursesProvider),
            appeals: ref.watch(examAppealsProvider),
          );
    });
