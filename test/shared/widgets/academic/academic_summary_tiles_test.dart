import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/academic/academic_summary_tiles.dart';

void main() {
  testWidgets('student identity tile flips and career metrics render', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 420,
            child: Row(
              children: [
                Expanded(child: StudentIdentityTile(data: _identity)),
                SizedBox(width: 12),
                Expanded(
                  child: CareerMetricsGrid(
                    arithmeticAverage: '27.1',
                    weightedAverage: '27.8',
                    acquiredCredits: 96,
                    totalCredits: 180,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Mario Rossi'), findsOneWidget);
    expect(find.text('27.1'), findsOneWidget);
    expect(find.text('96/180'), findsOneWidget);

    await tester.tap(find.byType(StudentIdentityTile));
    await tester.pumpAndSettle();

    expect(find.text('RFID RFID-1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('career metric tile handles zero totals', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 240,
            child: CareerMetricsGrid(acquiredCredits: 0, totalCredits: 0),
          ),
        ),
      ),
    );

    expect(find.text('0/0'), findsOneWidget);
    expect(find.text('0 CFU completati su 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

const _identity = StudentIdentityData(
  fullName: 'Mario Rossi',
  studentNumber: '123456',
  universityName: 'Universita Test',
  courseName: 'Informatica',
  badgeId: 'BADGE-1',
  rfid: 'RFID-1',
  honorsCount: 2,
  passedExamCount: 18,
  pendingExamCount: 4,
);
