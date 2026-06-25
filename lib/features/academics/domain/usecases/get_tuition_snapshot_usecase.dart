import '../entities/tuition_snapshot_entity.dart';
import '../repositories/tuition_repository.dart';

class GetTuitionSnapshotUseCase {
  const GetTuitionSnapshotUseCase(this._repository);

  final TuitionRepository _repository;

  Future<TuitionSnapshotEntity> call() => _repository.getTuitionSnapshot();
}
