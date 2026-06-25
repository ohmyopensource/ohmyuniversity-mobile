import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/custom_toast/custom_toast_model.dart';
import 'package:ohmyuniversity/shared/widgets/custom_toast/custom_toast_service.dart';
import 'package:ohmyuniversity/shared/widgets/custom_toast/custom_toast_widget.dart';

void main() {
  testWidgets('toast container renders variants and dismisses items', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                SizedBox.expand(),
                ToastContainerWidget(),
              ],
            ),
          ),
        ),
      ),
    );

    final service = container.read(toastServiceProvider.notifier);
    final successId = service.success(
        'Operazione completata',
        options: const ToastOptions(
          title: 'Successo',
          position: ToastPosition.topRight,
          duration: Duration(seconds: 5),
        ),
      );
    service.error(
        'Errore di salvataggio',
        options: const ToastOptions(
          title: 'Errore',
          position: ToastPosition.bottomCenter,
          duration: Duration.zero,
        ),
      );

    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Successo'), findsOneWidget);
    expect(find.text('Operazione completata'), findsOneWidget);
    expect(find.text('Errore'), findsOneWidget);

    service.dismiss(successId);
    await tester.pump(const Duration(milliseconds: 400));

    expect(container.read(toastServiceProvider), hasLength(1));
    service.dismissAll();
    await tester.pump(const Duration(milliseconds: 20));
    expect(tester.takeException(), isNull);
  });
}
