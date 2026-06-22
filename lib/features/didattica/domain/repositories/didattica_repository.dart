import '../entities/career_snapshot_entity.dart';

abstract interface class DidatticaRepository {
  Future<CareerSnapshotEntity> getCareerSnapshot();
}
