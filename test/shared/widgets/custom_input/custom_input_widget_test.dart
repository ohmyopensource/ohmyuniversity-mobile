import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ohmyuniversity/shared/widgets/custom_input/custom_input_widget.dart';

void main() {
  testWidgets('custom input emits text callbacks and clears value', (
    tester,
  ) async {
    String? changed;
    String? submitted;
    var focused = false;
    var blurred = false;
    var cleared = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            child: CustomInputWidget(
              label: 'Email',
              placeholder: 'nome@unimol.it',
              hint: 'Usa la mail istituzionale',
              initialValue: 'old@unimol.it',
              type: InputType.email,
              iconLeft: LucideIcons.mail,
              iconRight: LucideIcons.atSign,
              clearable: true,
              required: true,
              onChanged: (value) => changed = value,
              onSubmitted: (value) => submitted = value,
              onFocus: () => focused = true,
              onBlur: () => blurred = true,
              onCleared: () => cleared = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Usa la mail istituzionale'), findsOneWidget);

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'new@unimol.it');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(focused, isTrue);
    expect(changed, 'new@unimol.it');
    expect(submitted, 'new@unimol.it');

    await tester.tap(find.byIcon(LucideIcons.x).first);
    await tester.pump();

    expect(cleared, isTrue);
    expect(changed, isEmpty);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    expect(blurred, isTrue);
  });

  testWidgets('custom input renders password, textarea and status messages', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            child: Column(
              children: [
                CustomInputWidget(
                  label: 'Password',
                  type: InputType.password,
                  initialValue: 'secret',
                  successMessage: 'Password valida',
                  iconLeft: LucideIcons.lock,
                ),
                CustomInputWidget(
                  label: 'Note',
                  type: InputType.textarea,
                  rows: 3,
                  errorMessage: 'Campo obbligatorio',
                  prefix: '#',
                  suffix: 'CFU',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Password valida'), findsOneWidget);
    expect(find.text('Campo obbligatorio'), findsOneWidget);
    expect(find.text('#'), findsOneWidget);
    expect(find.text('CFU'), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.eye).first);
    await tester.pump();

    expect(find.byIcon(LucideIcons.eyeOff), findsOneWidget);
  });

  testWidgets('custom input select emits selected option and ignores disabled', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            child: CustomInputWidget(
              label: 'Corso',
              type: InputType.select,
              initialValue: 'inf',
              options: const [
                SelectOption(label: 'Informatica', value: 'inf'),
                SelectOption(label: 'Economia', value: 'eco'),
                SelectOption(label: 'Disabilitato', value: 'disabled', disabled: true),
              ],
              onChanged: (value) => selected = value,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Informatica'), findsOneWidget);

    await tester.tap(find.text('Informatica'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Economia').last);
    await tester.pump();

    expect(selected, 'eco');
  });
}
