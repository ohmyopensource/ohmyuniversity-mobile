import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/exam_appeal_entity.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/exam_appeal_months_provider.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/exam_appeals_provider.dart';

void main() {
  test(
    'visible exam appeal months use overridden appeals and current date',
    () {
      final container = ProviderContainer(
        overrides: [
          examAppealCurrentDateProvider.overrideWithValue(
            DateTime(2026, 12, 1),
          ),
          examAppealsProvider.overrideWithValue([
            _appeal(id: 'june', month: 6, date: DateTime(2026, 6, 18)),
            _appeal(id: 'february', month: 2, date: DateTime(2027, 2, 3)),
            _appeal(id: 'old', month: 5, date: DateTime(2026, 5, 10)),
          ]),
        ],
      );
      addTearDown(container.dispose);

      final months = container.read(visibleExamAppealMonthsProvider);

      expect(months.map((month) => month.month), [6, 2]);
      expect(months.map((month) => month.year), [2026, 2027]);
    },
  );
}

ExamAppealEntity _appeal({
  required String id,
  required int month,
  required DateTime date,
}) {
  return ExamAppealEntity(
    id: id,
    examName: 'Programmazione',
    month: month,
    date: date,
    time: '09:00',
    isBooked: false,
  );
}
