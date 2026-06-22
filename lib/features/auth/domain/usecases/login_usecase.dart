import '../../../../core/usecases/usecase.dart';
import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({
    required this.universityId,
    required this.username,
    required this.password,
  });

  final String universityId;
  final String username;
  final String password;
}

class LoginUseCase implements UseCase<AuthSessionEntity, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AuthSessionEntity> call(LoginParams params) {
    return _repository.login(
      universityId: params.universityId,
      username: params.username,
      password: params.password,
    );
  }
}
