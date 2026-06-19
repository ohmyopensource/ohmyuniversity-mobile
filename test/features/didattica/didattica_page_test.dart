import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/didattica/presentation/pages/didattica_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('switches between the three internal didattica pages', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DidatticaPage())),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Panoramica'), findsOneWidget);
    expect(find.text('Appelli'), findsOneWidget);
    expect(find.text('Questionari'), findsOneWidget);
    expect(_activeIndex(tester), 0);

    await tester.tap(find.text('Appelli').hitTestable());
    await tester.pump();
    expect(_activeIndex(tester), 1);

    await tester.tap(find.text('Questionari').hitTestable());
    await tester.pump();
    expect(_activeIndex(tester), 2);

    await tester.tap(find.text('Panoramica').hitTestable());
    await tester.pump();
    expect(_activeIndex(tester), 0);
    expect(tester.takeException(), isNull);
  });
}

int _activeIndex(WidgetTester tester) {
  return tester
          .widget<IndexedStack>(
            find.byKey(const Key('didattica-section-stack')),
          )
          .index ??
      -1;
}
