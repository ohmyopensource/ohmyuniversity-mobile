import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/exam_appeal_month_entity.dart';
import '../../domain/usecases/get_visible_exam_appeal_months_usecase.dart';
import 'exam_appeals_provider.dart';

final examAppealCurrentDateProvider = Provider<DateTime>((ref) {
  return DateTime.now();
});

final getVisibleExamAppealMonthsUseCaseProvider =
    Provider<GetVisibleExamAppealMonthsUseCase>((ref) {
      return const GetVisibleExamAppealMonthsUseCase();
    });

final visibleExamAppealMonthsProvider = Provider<List<ExamAppealMonthEntity>>((
  ref,
) {
  return ref
      .watch(getVisibleExamAppealMonthsUseCaseProvider)
      .call(
        appeals: ref.watch(examAppealsProvider),
        currentDate: ref.watch(examAppealCurrentDateProvider),
      );
});
