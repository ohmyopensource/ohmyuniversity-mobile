import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/custom_modal/custom_modal_widget.dart';

void main() {
  testWidgets('custom modal opens and closes from its controller', (
    tester,
  ) async {
    final controller = CustomModalController();
    CloseReason? closeReason;
    var opened = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomModalWidget(
            controller: controller,
            title: 'Dettaglio appello',
            subtitle: 'Aula e docente',
            footer: const Text('Footer azioni'),
            onOpened: () => opened = true,
            onClosed: (reason) => closeReason = reason,
            child: const Text('Contenuto modal'),
          ),
        ),
      ),
    );

    expect(controller.isOpen, isFalse);
    expect(find.text('Contenuto modal'), findsNothing);

    controller.open();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(controller.isOpen, isTrue);
    expect(opened, isTrue);
    expect(find.text('Dettaglio appello'), findsOneWidget);
    expect(find.text('Aula e docente'), findsOneWidget);
    expect(find.text('Contenuto modal'), findsOneWidget);
    expect(find.text('Footer azioni'), findsOneWidget);

    controller.close(CloseReason.programmatic);
    await tester.pump(const Duration(milliseconds: 320));

    expect(controller.isOpen, isFalse);
    expect(closeReason, CloseReason.programmatic);
    expect(find.text('Contenuto modal'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('persistent modal ignores backdrop close', (tester) async {
    final controller = CustomModalController();
    CloseReason? closeReason;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomModalWidget(
            controller: controller,
            type: ModalType.drawerBottom,
            title: 'Sheet persistente',
            persistent: true,
            onClosed: (reason) => closeReason = reason,
            child: const Text('Non chiudere'),
          ),
        ),
      ),
    );

    controller.open();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    await tester.tapAt(const Offset(8, 8));
    await tester.pump(const Duration(milliseconds: 450));

    expect(controller.isOpen, isTrue);
    expect(closeReason, isNull);
    expect(find.text('Non chiudere'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
