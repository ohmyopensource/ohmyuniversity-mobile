import '../entities/career_snapshot_entity.dart';
import '../repositories/didattica_repository.dart';

class GetCareerSnapshotUseCase {
  const GetCareerSnapshotUseCase(this._repository);

  final DidatticaRepository _repository;

  Future<CareerSnapshotEntity> call() => _repository.getCareerSnapshot();
}
