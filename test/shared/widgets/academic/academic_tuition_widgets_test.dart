import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/academic/academic_tuition_widgets.dart';

void main() {
  testWidgets('tuition panel filters unpaid and paid fees', (tester) async {
    final selectedStatuses = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            height: 360,
            child: AcademicTuitionPanel(
              fees: _fees,
              selectedStatus: 0,
              onStatusChanged: selectedStatuses.add,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Prima rata - 2025/2026'), findsOneWidget);
    expect(find.text('Seconda rata - 2025/2026'), findsOneWidget);
    expect(find.text('Saldo finale - 2025/2026'), findsNothing);

    await tester.tap(find.text('Pagate'));
    await tester.pump();

    expect(selectedStatuses, contains(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('tuition tiles, counters and empty state render compactly', (
    tester,
  ) async {
    var tappedCounter = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 260,
            child: Column(
              children: [
                AcademicTuitionFeeTile(fee: _fees.first),
                AcademicTuitionFeeTile(fee: _fees.last),
                SizedBox(
                  height: 110,
                  child: AcademicTuitionCounterTile(
                    unpaidCount: 2,
                    paidCount: 1,
                    onTap: () => tappedCounter = true,
                  ),
                ),
                const AcademicTuitionEmptyState(compact: true),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining('450,00'), findsOneWidget);
    expect(find.textContaining('120,50'), findsOneWidget);
    expect(find.text('Da pagare'), findsOneWidget);
    expect(find.text('Pagate'), findsOneWidget);
    expect(find.textContaining('niente da pagare'), findsOneWidget);

    await tester.tap(find.byType(AcademicTuitionCounterTile));
    await tester.pump();
    expect(tappedCounter, isTrue);
    expect(tester.takeException(), isNull);
  });
}

final _fees = [
  AcademicTuitionFeeData(
    id: 'fee-1',
    title: 'Prima rata',
    amount: 450,
    isPaid: false,
    academicYear: '2025/2026',
    referenceDate: DateTime(2026, 1, 31),
    isOverdue: true,
  ),
  AcademicTuitionFeeData(
    id: 'fee-2',
    title: 'Seconda rata',
    amount: 320,
    isPaid: false,
    academicYear: '2025/2026',
    referenceDate: DateTime(2026, 5, 31),
  ),
  AcademicTuitionFeeData(
    id: 'fee-3',
    title: 'Saldo finale',
    amount: 120.5,
    isPaid: true,
    academicYear: '2025/2026',
    referenceDate: DateTime(2026, 3, 2),
    receiptAvailable: true,
  ),
];
