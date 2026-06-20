import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/didattica/presentation/providers/appeals_controller.dart';
import 'package:ohmyuniversity/features/didattica/presentation/providers/questionnaires_provider.dart';
import 'package:ohmyuniversity/features/didattica/presentation/views/appeals_overview_view.dart';
import 'package:ohmyuniversity/shared/widgets/custom_button/custom_button_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('filters appeals by availability and search query', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(visibleExamBookingsProvider), hasLength(6));

    container
        .read(appealsControllerProvider.notifier)
        .setFilter(AppealsFilter.available);
    expect(container.read(visibleExamBookingsProvider), hasLength(4));

    container.read(appealsControllerProvider.notifier).search('Laura Conti');
    final result = container.read(visibleExamBookingsProvider);
    expect(result, hasLength(1));
    expect(result.single.courseName, 'Sistemi Operativi');
  });

  test('enables bookings only for courses with a completed questionnaire', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(isQuestionnaireCompletedProvider('Analisi Matematica II')),
      isTrue,
    );
    expect(
      container.read(
        isQuestionnaireCompletedProvider('Ingegneria del Software'),
      ),
      isTrue,
    );
    expect(
      container.read(
        isQuestionnaireCompletedProvider('Algoritmi e Strutture Dati'),
      ),
      isFalse,
    );
  });

  testWidgets('is responsive and confirms an eligible booking', (tester) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: AppealsOverviewView())),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Analisi Matematica II');
    await tester.pump();
    expect(find.byKey(const Key('exam-booking-card-e4')), findsOneWidget);
    expect(find.byKey(const Key('exam-booking-card-e1')), findsNothing);
    expect(find.text('12 CFU'), findsOneWidget);
    expect(find.text('L · 12 CFU · Anno 2'), findsNothing);

    final button = find.byKey(const Key('book-exam-e4'));
    await tester.scrollUntilVisible(
      button,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('confirm-exam-booking')), findsOneWidget);
    expect(
      container.read(appealsControllerProvider).bookedIds,
      isNot(contains('e4')),
    );

    await tester.tap(find.byKey(const Key('confirm-exam-booking')));
    await tester.pumpAndSettle();

    expect(container.read(appealsControllerProvider).bookedIds, contains('e4'));
    expect(find.text('Prenotato'), findsNWidgets(2));
    await tester.pump(const Duration(seconds: 5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('locks booking until questionnaire and shows details on demand', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: AppealsOverviewView())),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Algoritmi');
    await tester.pump();

    final bookingButton = tester.widget<CustomButtonWidget>(
      find.byKey(const Key('book-exam-e1')),
    );
    expect(bookingButton.disabled, isTrue);
    expect(bookingButton.label, 'Questionario da compilare');
    expect(find.text('Prof. Mario Bianchi'), findsNothing);
    expect(find.text('Aula A1'), findsNothing);

    await tester.tap(find.byKey(const Key('exam-info-e1')));
    await tester.pumpAndSettle();

    expect(find.text('Dettagli appello'), findsOneWidget);
    expect(find.text('Prof. Mario Bianchi'), findsOneWidget);
    expect(find.text('Aula A1'), findsOneWidget);
    expect(find.text('34 su 80'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the empty state when no exam matches', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: AppealsOverviewView())),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'corso inesistente');
    await tester.pump();

    expect(find.byKey(const Key('appeals-empty-state')), findsOneWidget);
    expect(find.text('0 appelli trovati'), findsOneWidget);
  });
}
