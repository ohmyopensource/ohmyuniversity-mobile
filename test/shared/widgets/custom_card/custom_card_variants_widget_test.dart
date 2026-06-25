import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ohmyuniversity/shared/widgets/custom_card/custom_card_variants_widget.dart';
import 'package:ohmyuniversity/shared/widgets/custom_card/custom_card_widget.dart';

void main() {
  testWidgets('renders the public card variants and tap callbacks', (
    tester,
  ) async {
    var simpleTapped = false;
    var statusTapped = false;
    var navTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                CardSimpleWidget(
                  icon: LucideIcons.bookOpen,
                  title: 'Materiali',
                  body: 'Dispense e risorse',
                  variant: CardVariant.primary,
                  onTap: () => simpleTapped = true,
                ),
                const CardMinimalWidget(
                  icon: LucideIcons.calendar,
                  title: 'Appello',
                  subtitle: 'Domani',
                  variant: CardVariant.info,
                ),
                const CardStatWidget(
                  value: '28.4',
                  label: 'Media ponderata',
                  suffix: '/30',
                  icon: LucideIcons.graduationCap,
                  trend: StatTrend(
                    direction: StatTrendDirection.up,
                    value: '+0.3',
                  ),
                ),
                CardStatusWidget(
                  statusVariant: StatusVariant.warning,
                  icon: LucideIcons.triangleAlert,
                  title: 'Scadenza',
                  description: 'Pagamento vicino',
                  onTap: () => statusTapped = true,
                ),
                const CardReviewWidget(
                  rating: 4.5,
                  body: 'Molto utile durante la sessione.',
                  reviewer: CardReviewer(
                    name: 'Marco R.',
                    university: 'UNIMOL',
                  ),
                  verified: true,
                ),
                const CardTeamWidget(
                  member: CardTeamMember(
                    name: 'Giulia M.',
                    role: 'Frontend',
                  ),
                  description: 'Flutter e design system.',
                ),
                CardNavWidget(
                  icon: LucideIcons.arrowRight,
                  title: 'Apri portali',
                  subtitle: 'Servizi studenti',
                  onTap: () => navTapped = true,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Materiali'), findsOneWidget);
    expect(find.text('Media ponderata'), findsOneWidget);
    expect(find.text('Scadenza'), findsOneWidget);
    expect(find.text('Marco R.'), findsOneWidget);
    expect(find.text('Giulia M.'), findsOneWidget);

    await tester.tap(find.text('Materiali'));
    await tester.tap(find.text('Scadenza'));
    await tester.ensureVisible(find.text('Apri portali'));
    await tester.tap(find.text('Apri portali'));
    await tester.pump();

    expect(simpleTapped, isTrue);
    expect(statusTapped, isTrue);
    expect(navTapped, isTrue);
    expect(tester.takeException(), isNull);
  });
}
