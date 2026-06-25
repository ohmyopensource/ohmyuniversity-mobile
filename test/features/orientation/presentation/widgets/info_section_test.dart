import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ohmyuniversity/features/orientation/presentation/widgets/info_section.dart';

void main() {
  testWidgets('orientation info widgets render text and timeline states', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              InfoSection(
                icon: LucideIcons.bookOpen,
                title: 'Come funziona',
                body: 'Una breve spiegazione per orientarsi.',
              ),
              StatHighlight(
                value: '92%',
                label: 'Studenti soddisfatti',
                color: Colors.green,
              ),
              TimelineStep(
                index: 1,
                title: 'Scegli area',
                body: 'Confronta corsi e requisiti.',
              ),
              TimelineStep(
                index: 2,
                title: 'Invia domanda',
                body: 'Completa la procedura.',
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Come funziona'), findsOneWidget);
    expect(find.text('92%'), findsOneWidget);
    expect(find.text('Scegli area'), findsOneWidget);
    expect(find.text('Invia domanda'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}
