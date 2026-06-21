import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/didattica_exam_course_entity.dart';
import '../../domain/entities/didattica_statistics_entity.dart';
import 'career_provider.dart';

final didatticaExamCoursesProvider = Provider<List<DidatticaExamCourseEntity>>((
  ref,
) {
  return ref.watch(careerProvider).courses;
});

final didatticaStatisticsProvider = Provider<DidatticaStatisticsEntity>((ref) {
  return ref.watch(careerStatisticsProvider);
});
