import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/email/domain/entities/email_inbox_entity.dart';
import 'package:ohmyuniversity/features/email/domain/exceptions/email_exception.dart';
import 'package:ohmyuniversity/features/email/presentation/pages/email_inbox_page.dart';
import 'package:ohmyuniversity/features/email/presentation/providers/email_providers.dart';

void main() {
  testWidgets('renders institutional email messages from the inbox provider', (
    tester,
  ) async {
    final inbox = EmailInboxEntity(
      totalCount: 1,
      messages: [
        EmailSummaryEntity(
          id: 'mail-1',
          subject: 'Bando borsa di studio',
          senderName: 'Segreteria studenti',
          senderAddress: 'segreteria@unimol.it',
          receivedAt: DateTime(2026, 6, 20, 9),
          isRead: false,
          hasAttachments: true,
          preview: 'Consulta la documentazione allegata.',
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [emailInboxProvider.overrideWith((ref) async => inbox)],
        child: const MaterialApp(home: EmailInboxPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('email-inbox-list')), findsOneWidget);
    expect(find.text('Segreteria studenti'), findsOneWidget);
    expect(find.text('Bando borsa di studio'), findsOneWidget);
    expect(find.text('Allegati'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the connect flow when the email account is not linked', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          emailInboxProvider.overrideWith((ref) {
            throw const EmailAccountNotConnectedException();
          }),
        ],
        child: const MaterialApp(home: EmailInboxPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Collega la tua email'), findsOneWidget);
    expect(find.byKey(const Key('connect-email-button')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
