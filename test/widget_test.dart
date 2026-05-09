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

      // App boots and at least one widget is in the tree
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}