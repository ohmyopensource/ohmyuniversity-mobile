import 'package:ohmyuniversity/features/didattica/data/datasources/didattica_mock_datasource.dart';
import 'package:ohmyuniversity/features/didattica/domain/entities/career_snapshot_entity.dart';
import 'package:ohmyuniversity/features/didattica/domain/services/didattica_statistics_calculator.dart';

CareerSnapshotEntity buildCareerTestSnapshot() {
  final courses = const DidatticaMockDataSource().getExamCourses();
  return CareerSnapshotEntity(
    courses: courses,
    statistics: const DidatticaStatisticsCalculator().calculate(courses),
  );
}
