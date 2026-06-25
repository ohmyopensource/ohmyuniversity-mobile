import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/orientation/presentation/pages/topics/university_life_page.dart';

void main() {
  testWidgets('university life page renders workload sections', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: VitaUniversitariaPage(
            activeIndex: 3,
            totalTopics: 6,
            answeredCount: 4,
            totalCount: 12,
            onPrevious: () {},
            onNext: () {},
            onBackToTopics: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Orari e impegno'), findsWidgets);
    expect(find.text('Come si distribuisce la settimana'), findsOneWidget);
    expect(find.text('Lezioni'), findsOneWidget);
    expect(find.text('Studio individuale'), findsOneWidget);
  });
}
