import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/tuition_fee_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/tuition_snapshot_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/repositories/tuition_repository.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/tuition_providers.dart';

void main() {
  test(
    'tuition snapshot provider resolves data through the configured repository',
    () async {
      final container = ProviderContainer(
        overrides: [
          tuitionRepositoryProvider.overrideWithValue(_FakeRepository()),
        ],
      );
      addTearDown(container.dispose);

      final snapshot = await container.read(tuitionSnapshotProvider.future);

      expect(snapshot.status, 'GREEN');
      expect(snapshot.fees.single.title, 'Prima rata');
      expect(container.read(getTuitionSnapshotUseCaseProvider), isNotNull);
    },
  );
}

class _FakeRepository implements TuitionRepository {
  @override
  Future<TuitionSnapshotEntity> getTuitionSnapshot() async {
    return TuitionSnapshotEntity(
      status: 'GREEN',
      totalDue: 120,
      fees: [
        TuitionFeeEntity(
          id: 'fee-1',
          title: 'Prima rata',
          amount: 120,
          isPaid: false,
          isOverdue: false,
          receiptAvailable: false,
          referenceDate: DateTime(2026, 6, 25),
        ),
      ],
    );
  }
}
