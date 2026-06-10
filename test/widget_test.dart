import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/app.dart';

void main() {
  group('App', () {
    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: App(),
        ),
      );

      // @TODO: quick test workaround to change
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}