import '../entities/tuition_snapshot_entity.dart';

abstract interface class TuitionRepository {
  Future<TuitionSnapshotEntity> getTuitionSnapshot();
}
