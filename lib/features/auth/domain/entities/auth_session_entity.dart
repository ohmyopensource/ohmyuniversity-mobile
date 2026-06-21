import 'career_profile_entity.dart';

class AuthSessionEntity {
  const AuthSessionEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.profiles,
  });

  final String accessToken;
  final String refreshToken;
  final String username;
  final List<CareerProfileEntity> profiles;

  CareerProfileEntity? get activeProfile =>
      profiles.where((profile) => profile.active).firstOrNull ??
      profiles.firstOrNull;
}
