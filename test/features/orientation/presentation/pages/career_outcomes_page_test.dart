import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/orientation/presentation/pages/topics/career_outcomes_page.dart';

void main() {
  testWidgets('career outcomes page renders charts and navigation actions', (
    tester,
  ) async {
    var previous = false;
    var next = false;
    var back = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: SbocchiLavorativiPage(
            activeIndex: 4,
            totalTopics: 6,
            answeredCount: 3,
            totalCount: 12,
            onPrevious: () => previous = true,
            onNext: () => next = true,
            onBackToTopics: () => back = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sbocchi lavorativi'), findsWidgets);
    expect(find.text('Occupazione a 1 anno dalla laurea'), findsOneWidget);

    await tester.tap(find.textContaining('Indietro').first);
    await tester.pump();
    expect(previous || next || back, isTrue);
  });
}
