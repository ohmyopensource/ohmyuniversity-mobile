import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/academic_exam_course_entity.dart';
import '../../domain/entities/academic_statistics_entity.dart';
import 'career_provider.dart';

final academicExamCoursesProvider = Provider<List<AcademicExamCourseEntity>>((
  ref,
) {
  return ref.watch(careerProvider).courses;
});

final academicStatisticsProvider = Provider<AcademicStatisticsEntity>((ref) {
  return ref.watch(careerStatisticsProvider);
});
