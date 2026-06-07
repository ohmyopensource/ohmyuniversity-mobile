import '../models/user_model.dart';

class AuthMockDataSource {
  bool _authenticated = false;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _authenticated = true;
    return UserModel.mock(email: email);
  }

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _authenticated = true;
    return UserModel.mock(email: email, name: '$firstName $lastName');
  }

  Future<void> logout() async {
    _authenticated = false;
  }

  Future<bool> isAuthenticated() async {
    return _authenticated;
  }
}
