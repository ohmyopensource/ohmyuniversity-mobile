import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_mock_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthMockDataSource _dataSource;

  @override
  Future<UserEntity> login({required String email, required String password}) {
    return _dataSource.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return _dataSource.logout();
  }

  @override
  Future<bool> isAuthenticated() {
    return _dataSource.isAuthenticated();
  }
}
