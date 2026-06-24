import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/services/domain/entities/external_services_entity.dart';
import 'package:ohmyuniversity/features/services/presentation/pages/services_page.dart';
import 'package:ohmyuniversity/features/services/presentation/providers/external_services_providers.dart';

void main() {
  testWidgets('shows portal sections and provider-backed cards', (
    tester,
  ) async {
    const services = ExternalServicesEntity(
      universityId: 'UNIMOL',
      universityName: 'Universita degli Studi del Molise',
      moodleUrl: null,
      libraryUrl: null,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          externalServicesProvider.overrideWith((ref) async => services),
        ],
        child: const MaterialApp(home: ServicesPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Portali'), findsWidgets);
    expect(find.text('In evidenza'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('portal-search-field')),
      'moodle',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('moodle-service-card')), findsOneWidget);
    expect(find.text('Didattica'), findsOneWidget);
    expect(find.text('Servizio non configurato'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('portal-search-field')),
      'biblioteca',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('biblioteca-service-card')), findsOneWidget);
    expect(find.text('Didattica'), findsOneWidget);
    expect(find.text('Servizio non configurato'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('portal-search-field')),
      'esse3',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('esse3-service-card')), findsOneWidget);
    expect(find.text('Segreteria'), findsOneWidget);
    expect(find.text('Servizio non configurato'), findsOneWidget);

    expect(find.text('Universita degli Studi del Molise'), findsOneWidget);
  });
}
