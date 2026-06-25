import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/providers/network_providers.dart';
import '../../data/datasources/timetable_mock_datasource.dart';
import '../../data/datasources/timetable_remote_datasource.dart';
import '../../data/repositories/timetable_repository_impl.dart';
import '../../domain/entities/timetable_document_entity.dart';
import '../../domain/exceptions/timetable_exception.dart';
import '../../domain/repositories/timetable_repository.dart';
import '../../domain/usecases/get_student_timetables_usecase.dart';

final timetableMockDataSourceProvider = Provider<TimetableMockDataSource>((
  ref,
) {
  return const TimetableMockDataSource();
});

final timetableRemoteDataSourceProvider = Provider<TimetableRemoteDataSource>((
  ref,
) {
  return TimetableRemoteDataSource(ref.watch(apiDioProvider));
});

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepositoryImpl(
    ref.watch(timetableRemoteDataSourceProvider),
    ref.watch(timetableMockDataSourceProvider),
    useMock: const bool.fromEnvironment('USE_MOCK_TIMETABLES'),
  );
});

final getStudentTimetablesUseCaseProvider =
    Provider<GetStudentTimetablesUseCase>((ref) {
      return GetStudentTimetablesUseCase(
        ref.watch(timetableRepositoryProvider),
      );
    });

final studentTimetablesProvider = FutureProvider<List<TimetableDocumentEntity>>(
  (ref) async {
    final session = await ref.watch(authLocalDataSourceProvider).readSession();
    final profile = session?.activeProfile;
    final universityId = profile?.universityId.trim();
    final courseName = profile?.courseName.trim();

    if (universityId == null ||
        universityId.isEmpty ||
        courseName == null ||
        courseName.isEmpty) {
      throw const TimetableException(
        'Accedi nuovamente per consultare gli orari.',
      );
    }

    return ref
        .watch(getStudentTimetablesUseCaseProvider)
        .call(universityId: universityId, courseName: courseName);
  },
);
