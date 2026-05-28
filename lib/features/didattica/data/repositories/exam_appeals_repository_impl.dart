import '../../domain/entities/exam_appeal_entity.dart';
import '../../domain/repositories/exam_appeals_repository.dart';
import '../datasources/exam_appeals_mock_datasource.dart';

class ExamAppealsRepositoryImpl implements ExamAppealsRepository {
  const ExamAppealsRepositoryImpl(this._dataSource);

  final ExamAppealsMockDataSource _dataSource;

  @override
  List<ExamAppealEntity> getExamAppeals() {
    return _dataSource.getExamAppeals();
  }
}
