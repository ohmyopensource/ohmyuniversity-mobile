import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_mock_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthMockDataSource _dataSource;

  @override
  Future<UserEntity> login({required String university}) {
    return _dataSource.login(university: university);
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
