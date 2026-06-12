import '../../domain/entities/user_entity.dart';
import '../../../../shared/mocks/app_mock_data.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.university,
  });

  factory UserModel.mock({required String email, String? name}) {
    return UserModel(
      id: AppMockData.mockUserId,
      name: name ?? AppMockData.student.fullName,
      email: email,
      university: AppMockData.student.universityName,
    );
  }
}
