import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/orientation/presentation/pages/topics/common_mistakes_page.dart';

void main() {
  testWidgets('common mistakes page renders mistakes and bottom actions', (
    tester,
  ) async {
    var backToTopics = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ErroriComuniPage(
            activeIndex: 5,
            totalTopics: 6,
            answeredCount: 8,
            totalCount: 12,
            onPrevious: () {},
            onNext: () {},
            onBackToTopics: () => backToTopics = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ErroriComuniPage), findsOneWidget);
    expect(find.textContaining('Macro-area'), findsOneWidget);
    expect(backToTopics, isFalse);
  });
}
