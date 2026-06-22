import '../repositories/email_repository.dart';

class GetEmailAuthorizationUrlUseCase {
  const GetEmailAuthorizationUrlUseCase(this._repository);

  final EmailRepository _repository;

  Future<Uri> call() {
    return _repository.getAuthorizationUrl();
  }
}
