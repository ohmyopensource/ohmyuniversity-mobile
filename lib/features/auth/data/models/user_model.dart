import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.university,
  });

  factory UserModel.mock({required String email, String name = 'Mario Rossi'}) {
    return UserModel(
      id: 'mock-user-1',
      name: name,
      email: email,
      university: 'Universita degli Studi del Molise',
    );
  }
}
