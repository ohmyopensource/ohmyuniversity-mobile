import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/didattica_mock_datasource.dart';
import '../../data/repositories/didattica_repository_impl.dart';
import '../../domain/entities/didattica_exam_course_entity.dart';
import '../../domain/entities/didattica_statistics_entity.dart';
import '../../domain/repositories/didattica_repository.dart';
import '../../domain/usecases/get_didattica_exam_courses_usecase.dart';
import '../../domain/usecases/get_didattica_statistics_usecase.dart';

final didatticaMockDataSourceProvider = Provider<DidatticaMockDataSource>((
  ref,
) {
  return const DidatticaMockDataSource();
});

final didatticaRepositoryProvider = Provider<DidatticaRepository>((ref) {
  return DidatticaRepositoryImpl(ref.watch(didatticaMockDataSourceProvider));
});

final getDidatticaExamCoursesUseCaseProvider =
    Provider<GetDidatticaExamCoursesUseCase>((ref) {
      return GetDidatticaExamCoursesUseCase(
        ref.watch(didatticaRepositoryProvider),
      );
    });

final didatticaExamCoursesProvider = Provider<List<DidatticaExamCourseEntity>>((
  ref,
) {
  return ref.watch(getDidatticaExamCoursesUseCaseProvider).call();
});

final getDidatticaStatisticsUseCaseProvider =
    Provider<GetDidatticaStatisticsUseCase>((ref) {
      return GetDidatticaStatisticsUseCase(
        ref.watch(didatticaRepositoryProvider),
      );
    });

final didatticaStatisticsProvider = Provider<DidatticaStatisticsEntity>((ref) {
  return ref.watch(getDidatticaStatisticsUseCaseProvider).call();
});
