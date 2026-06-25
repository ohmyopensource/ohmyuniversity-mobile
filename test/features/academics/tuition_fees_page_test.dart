import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/academics/domain/entities/tuition_fee_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/tuition_snapshot_entity.dart';
import 'package:ohmyuniversity/features/academics/presentation/pages/tuition_fees_page.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/tuition_providers.dart';

void main() {
  testWidgets('renders real tuition snapshot responsively', (tester) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tuitionSnapshotProvider.overrideWith(
            (ref) async => TuitionSnapshotEntity(
              status: 'GIALLO',
              totalDue: 450,
              fees: [
                TuitionFeeEntity(
                  id: '1',
                  title: 'Prima rata',
                  amount: 450,
                  isPaid: true,
                  isOverdue: false,
                  receiptAvailable: true,
                  academicYear: 'A.A. 2025/2026',
                  referenceDate: DateTime(2025, 10, 15),
                ),
                TuitionFeeEntity(
                  id: '2',
                  title: 'Seconda rata',
                  amount: 450,
                  isPaid: false,
                  isOverdue: true,
                  receiptAvailable: false,
                  academicYear: 'A.A. 2025/2026',
                  referenceDate: DateTime(2026, 4, 30),
                ),
              ],
            ),
          ),
        ],
        child: const MaterialApp(home: TuitionFeesPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pagato'.toUpperCase()), findsOneWidget);
    expect(find.text('Da pagare'.toUpperCase()), findsOneWidget);
    expect(find.textContaining('Prima rata'), findsOneWidget);
    expect(find.textContaining('Seconda rata'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
