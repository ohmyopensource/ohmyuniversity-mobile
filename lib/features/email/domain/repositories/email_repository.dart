import '../entities/email_inbox_entity.dart';

abstract interface class EmailRepository {
  Future<Uri> getAuthorizationUrl();

  Future<EmailInboxEntity> getInbox();
}
