import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ohmyuniversity/features/orientation/presentation/pages/orientation_summary_page.dart';

void main() {
  testWidgets('orientation summary page shows incomplete profile state', (
    tester,
  ) async {
    var wentBack = false;
    var showedResult = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: OrientationSummaryPage(
            onBack: () => wentBack = true,
            onShowResult: () => showedResult = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Riepilogo risposte'), findsOneWidget);
    expect(find.text('Profilo incompleto'), findsOneWidget);
    expect(find.text('Completa le risposte mancanti'), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.arrowLeft).first);
    expect(wentBack, isTrue);
    expect(showedResult, isFalse);
  });
}
