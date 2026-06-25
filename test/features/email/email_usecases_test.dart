import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/email/domain/entities/email_inbox_entity.dart';
import 'package:ohmyuniversity/features/email/domain/repositories/email_repository.dart';
import 'package:ohmyuniversity/features/email/domain/usecases/get_email_authorization_url_usecase.dart';
import 'package:ohmyuniversity/features/email/domain/usecases/get_email_inbox_usecase.dart';

void main() {
  test('email use cases return repository data', () async {
    final repository = _EmailRepositoryFake();

    final inbox = await GetEmailInboxUseCase(repository).call();
    final authUrl = await GetEmailAuthorizationUrlUseCase(repository).call();

    expect(inbox.totalCount, 1);
    expect(inbox.messages.single.subject, 'Benvenuto');
    expect(authUrl.host, 'example.com');
  });
}

class _EmailRepositoryFake implements EmailRepository {
  @override
  Future<Uri> getAuthorizationUrl() async {
    return Uri.parse('https://example.com/email-auth');
  }

  @override
  Future<EmailInboxEntity> getInbox() async {
    return EmailInboxEntity(
      totalCount: 1,
      messages: [
        EmailSummaryEntity(
          id: 'message-1',
          subject: 'Benvenuto',
          senderName: 'Segreteria',
          senderAddress: 'segreteria@example.com',
          receivedAt: DateTime(2026, 6, 25),
          isRead: false,
          hasAttachments: true,
          preview: 'Il tuo account e attivo.',
        ),
      ],
    );
  }
}
