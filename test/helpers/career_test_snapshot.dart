import 'package:ohmyuniversity/features/academics/data/datasources/academic_mock_datasource.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/career_snapshot_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/services/academic_statistics_calculator.dart';

CareerSnapshotEntity buildCareerTestSnapshot() {
  final courses = const AcademicMockDataSource().getExamCourses();
  return CareerSnapshotEntity(
    courses: courses,
    statistics: const AcademicStatisticsCalculator().calculate(courses),
  );
}
