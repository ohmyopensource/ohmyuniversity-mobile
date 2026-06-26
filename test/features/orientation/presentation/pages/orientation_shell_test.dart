import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/orientation/presentation/pages/orientation_shell.dart';

void main() {
  testWidgets('orientation shell renders navigation and progress controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OrientationShell(
          title: 'Scegli il corso',
          currentIndex: 1,
          totalCount: 3,
          child: Center(child: Text('Dettaglio argomento')),
        ),
      ),
    );

    expect(find.text('Scegli il corso'), findsOneWidget);
    expect(find.text('Dettaglio argomento'), findsOneWidget);
    expect(find.text('<= Arg.Prec'), findsOneWidget);
    expect(find.text('Arg.Succ =>'), findsOneWidget);
    expect(find.text('Torna ad Orientamento'), findsOneWidget);
  });
}
