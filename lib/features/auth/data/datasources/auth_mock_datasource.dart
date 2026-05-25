import '../models/user_model.dart';

class AuthMockDataSource {
  bool _authenticated = false;

  Future<UserModel> login({required String university}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _authenticated = true;
    return UserModel.mock(university: university);
  }

  Future<void> logout() async {
    _authenticated = false;
  }

  Future<bool> isAuthenticated() async {
    return _authenticated;
  }
}
