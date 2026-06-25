import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/email/data/models/email_inbox_model.dart';

void main() {
  test('email inbox model maps complete payloads', () {
    final model = EmailInboxModel.fromJson({
      'totalCount': 4,
      'messages': [
        {
          'id': 'msg-1',
          'subject': 'Esame confermato',
          'fromName': 'Segreteria',
          'fromAddress': 'segreteria@unimol.it',
          'receivedAt': '2026-06-25T09:30:00Z',
          'isRead': true,
          'hasAttachments': true,
          'preview': 'La prenotazione e confermata.',
        },
      ],
    });

    expect(model.totalCount, 4);
    expect(model.messages.single.id, 'msg-1');
    expect(model.messages.single.subject, 'Esame confermato');
    expect(model.messages.single.receivedAt, DateTime.parse('2026-06-25T09:30:00Z'));
    expect(model.messages.single.isRead, isTrue);
    expect(model.messages.single.hasAttachments, isTrue);
  });

  test('email inbox model tolerates missing and malformed values', () {
    final model = EmailInboxModel.fromJson({
      'messages': [
        {
          'receivedAt': 'not-a-date',
        },
        'ignored',
      ],
    });

    expect(model.totalCount, 2);
    expect(model.messages, hasLength(1));
    expect(model.messages.single.id, isEmpty);
    expect(model.messages.single.subject, 'Nessun oggetto');
    expect(model.messages.single.receivedAt, isNull);
    expect(model.messages.single.isRead, isFalse);
    expect(model.messages.single.preview, isEmpty);
  });
}
