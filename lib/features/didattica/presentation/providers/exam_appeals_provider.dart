import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/exam_appeals_mock_datasource.dart';
import '../../data/repositories/exam_appeals_repository_impl.dart';
import '../../domain/entities/exam_appeal_entity.dart';
import '../../domain/repositories/exam_appeals_repository.dart';
import '../../domain/usecases/get_exam_appeals_usecase.dart';

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
