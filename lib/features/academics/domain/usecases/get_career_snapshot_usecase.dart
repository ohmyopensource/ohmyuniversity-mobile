import '../entities/career_snapshot_entity.dart';
import '../repositories/academic_repository.dart';

class GetCareerSnapshotUseCase {
  const GetCareerSnapshotUseCase(this._repository);

  final AcademicRepository _repository;

  Future<CareerSnapshotEntity> call() => _repository.getCareerSnapshot();
}
