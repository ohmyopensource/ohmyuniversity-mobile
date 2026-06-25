import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/academic/academic_statistics_tiles.dart';

void main() {
  testWidgets('academic statistics tiles render projection and trend labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            child: Column(
              children: [
                const GraduationProjectionTile(value: 102.75, maxValue: 110),
                AverageTrendTile(
                  points: [
                    AcademicAverageTrendPoint(
                      date: DateTime(2026, 1, 15),
                      value: 24.5,
                    ),
                    AcademicAverageTrendPoint(
                      date: DateTime(2026, 6, 20),
                      value: 27.2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('PROIEZIONE DI LAUREA'), findsOneWidget);
    expect(find.text('102.75'), findsOneWidget);
    expect(find.text('/ 110'), findsOneWidget);
    expect(find.text('ANDAMENTO MEDIA'), findsOneWidget);
    expect(find.text('15 Gen 2026'), findsOneWidget);
    expect(find.text('20 Giu 2026'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('average trend tile handles empty points', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            height: 220,
            child: AverageTrendTile(points: []),
          ),
        ),
      ),
    );

    expect(find.text('ANDAMENTO MEDIA'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
