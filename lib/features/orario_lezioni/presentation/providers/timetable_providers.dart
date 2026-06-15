import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/timetable_mock_datasource.dart';
import '../../data/repositories/timetable_repository_impl.dart';
import '../../domain/entities/timetable_document_entity.dart';
import '../../domain/repositories/timetable_repository.dart';
import '../../domain/usecases/get_student_timetables_usecase.dart';

final timetableMockDataSourceProvider = Provider<TimetableMockDataSource>((
  ref,
) {
  return const TimetableMockDataSource();
});

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepositoryImpl(ref.watch(timetableMockDataSourceProvider));
});

final getStudentTimetablesUseCaseProvider =
    Provider<GetStudentTimetablesUseCase>((ref) {
      return GetStudentTimetablesUseCase(
        ref.watch(timetableRepositoryProvider),
      );
    });

final studentTimetablesProvider = Provider<List<TimetableDocumentEntity>>((
  ref,
) {
  return ref.watch(getStudentTimetablesUseCaseProvider).call();
});
