import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/orientation/presentation/widgets/orientation_card.dart';

void main() {
  testWidgets('orientation card renders its child with custom padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OrientationCard(
            padding: EdgeInsets.all(12),
            child: Text('Contenuto orientamento'),
          ),
        ),
      ),
    );

    expect(find.text('Contenuto orientamento'), findsOneWidget);
    expect(find.byType(OrientationCard), findsOneWidget);
  });
}
