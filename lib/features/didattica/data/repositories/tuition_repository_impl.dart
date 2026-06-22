import '../../domain/entities/tuition_snapshot_entity.dart';
import '../../domain/repositories/tuition_repository.dart';
import '../datasources/tuition_remote_datasource.dart';

class TuitionRepositoryImpl implements TuitionRepository {
  const TuitionRepositoryImpl(this._dataSource);

  final TuitionRemoteDataSource _dataSource;

  @override
  Future<TuitionSnapshotEntity> getTuitionSnapshot() {
    return _dataSource.getTuitionSnapshot();
  }
}
