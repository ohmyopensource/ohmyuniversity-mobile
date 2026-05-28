import '../../domain/entities/didattica_exam_course_entity.dart';
import '../../domain/entities/didattica_statistics_entity.dart';
import '../../domain/repositories/didattica_repository.dart';
import '../datasources/didattica_mock_datasource.dart';

class DidatticaRepositoryImpl implements DidatticaRepository {
  const DidatticaRepositoryImpl(this._dataSource);

  final DidatticaMockDataSource _dataSource;

  @override
  List<DidatticaExamCourseEntity> getExamCourses() {
    return _dataSource.getExamCourses();
  }

  @override
  DidatticaStatisticsEntity getStatistics() {
    return _dataSource.getStatistics();
  }
}
