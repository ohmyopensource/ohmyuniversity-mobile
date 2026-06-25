import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/app_drawer.dart';

void main() {
  testWidgets('app drawer renders navigation groups and expands sections', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 390,
              height: 1100,
              child: AppDrawer(notificationCount: 3),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Notifiche'), findsOneWidget);
    expect(find.text('Agenda'), findsOneWidget);
    expect(find.text('Orario Lezioni'), findsOneWidget);
    expect(find.text('Email istituzionale'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.text('Trasporti'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Raggiungi'), findsOneWidget);
    expect(find.text('Prenotazione navette'), findsOneWidget);

    await tester.ensureVisible(find.text('Portali'));
    expect(find.text('Portali'), findsOneWidget);

    await tester.ensureVisible(find.text('Segreteria'));
    await tester.tap(find.text('Segreteria'));
    await tester.pumpAndSettle();

    expect(find.text('Tasse da pagare'), findsOneWidget);
    expect(find.text('Borse di studio'), findsOneWidget);
    expect(find.text('Bandi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
