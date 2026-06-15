import '../../domain/entities/timetable_document_entity.dart';
import '../../domain/repositories/timetable_repository.dart';
import '../datasources/timetable_mock_datasource.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  const TimetableRepositoryImpl(this._dataSource);

  final TimetableMockDataSource _dataSource;

  @override
  List<TimetableDocumentEntity> getStudentTimetables() {
    return List<TimetableDocumentEntity>.unmodifiable(
      _dataSource.getStudentTimetables(),
    );
  }
}
