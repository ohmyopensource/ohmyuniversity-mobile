import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/custom_text/custom_text_widget.dart';

void main() {
  testWidgets('custom text renders semantic variants', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                text: 'Titolo grande',
                variant: TextVariant.display,
                gradient: true,
              ),
              CustomTextWidget(
                text: 'label uppercase',
                variant: TextVariant.overline,
                color: TextColor.info,
                weight: TextWeight.extraBold,
              ),
              CustomTextWidget(
                text: 'final codice = true',
                variant: TextVariant.code,
                color: TextColor.success,
              ),
              CustomTextWidget(
                text: 'Nota importante',
                variant: TextVariant.blockquote,
                color: TextColor.warning,
                underline: true,
              ),
              CustomTextWidget(
                text: 'Una descrizione molto lunga',
                variant: TextVariant.bodySm,
                color: TextColor.muted,
                italic: true,
                noWrap: true,
                semanticsLabel: 'descrizione compatta',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Titolo grande'), findsOneWidget);
    expect(find.text('LABEL UPPERCASE'), findsOneWidget);
    expect(find.text('final codice = true'), findsOneWidget);
    expect(find.text('Nota importante'), findsOneWidget);
    expect(find.bySemanticsLabel('descrizione compatta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
