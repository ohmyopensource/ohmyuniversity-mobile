import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<UserEntity> call(LoginParams params) {
    return _repository.login(email: params.email, password: params.password);
  }
}
