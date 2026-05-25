import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.university,
  });

  factory UserModel.mock({required String university}) {
    return UserModel(
      id: 'mock-user-1',
      name: 'Mario Rossi',
      email: 'mario.rossi@studenti.unimi.it',
      university: university,
    );
  }
}
