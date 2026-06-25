import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/orientation/presentation/pages/orientation_page.dart';
import 'package:ohmyuniversity/features/orientation/presentation/providers/orientation_providers.dart';
import 'package:ohmyuniversity/shared/widgets/custom_toast/custom_toast_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens the guide, shows questions and saves an answer', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: OrientationPage()),
      ),
    );
    await tester.pump();

    expect(find.text('Inizia la guida'), findsOneWidget);

    await tester.tap(find.text('Inizia la guida'));
    await tester.pumpAndSettle();

    expect(find.text('Scegli il corso adatto a te'), findsWidgets);
    expect(find.text('Vai alle domande'), findsOneWidget);

    await tester.tap(find.text('Vai alle domande'));
    await tester.pumpAndSettle();

    expect(find.text('Ora tocca a te'), findsOneWidget);
    expect(find.textContaining('Quale area di studio'), findsOneWidget);

    await tester.tap(find.text('Scientifica').last);
    await tester.pump();

    final answers = container.read(orientationAnswersProvider);
    expect(answers['corso-area']?.value, 'scientifica');
    expect(container.read(orientationAnsweredCountProvider), 1);
    expect(
      container.read(toastServiceProvider).last.message,
      'Risposta salvata',
    );

    container.read(toastServiceProvider.notifier).dismissAll();
  });
}
