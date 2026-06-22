import '../entities/email_inbox_entity.dart';
import '../repositories/email_repository.dart';

class GetEmailInboxUseCase {
  const GetEmailInboxUseCase(this._repository);

  final EmailRepository _repository;

  Future<EmailInboxEntity> call() {
    return _repository.getInbox();
  }
}
