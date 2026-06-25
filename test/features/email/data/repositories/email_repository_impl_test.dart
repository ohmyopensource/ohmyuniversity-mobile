import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/email/data/repositories/email_repository_impl.dart';

void main() {
  test(
    'email mock repository returns authorization URL and inbox messages',
    () async {
      const repository = EmailMockRepository();

      final authorizationUrl = await repository.getAuthorizationUrl();
      final inbox = await repository.getInbox();

      expect(authorizationUrl.scheme, 'https');
      expect(inbox.totalCount, 2);
      expect(inbox.messages, hasLength(2));
      expect(inbox.messages.first.isRead, isFalse);
      expect(inbox.messages.first.hasAttachments, isTrue);
    },
  );
}
