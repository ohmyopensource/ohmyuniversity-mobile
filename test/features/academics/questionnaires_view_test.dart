import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/data/mocks/questionnaires_mock_data.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/questionnaires_provider.dart';
import 'package:ohmyuniversity/features/academics/presentation/views/questionnaires_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('separates pending and completed questionnaires', () {
    final container = ProviderContainer(overrides: _questionnaireOverrides);
    addTearDown(container.dispose);

    expect(container.read(pendingQuestionnairesProvider), hasLength(3));
    expect(container.read(completedQuestionnairesProvider), hasLength(3));
  });

  testWidgets('renders the web questionnaire structure at 320 px', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: _questionnaireOverrides,
        child: MaterialApp(home: Scaffold(body: QuestionnairesView())),
      ),
    );
    await tester.pump();

    expect(find.text('Da compilare'), findsOneWidget);
    expect(find.byKey(const Key('questionnaire-card-q1')), findsOneWidget);
    expect(find.text('Compila questionario'), findsWidgets);

    final completedCard = find.byKey(const Key('questionnaire-card-q3'));
    await tester.scrollUntilVisible(
      completedCard,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(completedCard, findsOneWidget);
    expect(find.text('Compilati'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses the prototype toast when filling a questionnaire', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _questionnaireOverrides,
        child: MaterialApp(home: Scaffold(body: QuestionnairesView())),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('fill-questionnaire-q1')));
    await tester.pump(const Duration(seconds: 5));
    expect(tester.takeException(), isNull);
  });
}

final _questionnaireOverrides = [
  remoteQuestionnairesProvider.overrideWith(
    (ref) async => questionnairesMockData,
  ),
];
