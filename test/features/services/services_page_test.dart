import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/services/domain/entities/external_services_entity.dart';
import 'package:ohmyuniversity/features/services/presentation/pages/services_page.dart';
import 'package:ohmyuniversity/features/services/presentation/providers/external_services_providers.dart';

void main() {
  testWidgets('shows Moodle and library from the provider', (tester) async {
    const services = ExternalServicesEntity(
      universityId: 'UNIMOL',
      universityName: 'Università degli Studi del Molise',
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

    expect(find.byKey(const Key('moodle-service-card')), findsOneWidget);
    expect(find.byKey(const Key('library-service-card')), findsOneWidget);
    expect(
      find.byKey(const Key('student-portal-service-card')),
      findsOneWidget,
    );
    expect(find.text('Università degli Studi del Molise'), findsOneWidget);
    expect(find.text('Servizio non configurato'), findsNWidgets(3));
  });
}
