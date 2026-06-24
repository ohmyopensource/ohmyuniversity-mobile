import 'career_profile_entity.dart';

class AuthSessionEntity {
  const AuthSessionEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.universityId,
    required this.username,
    required this.nome,
    required this.cognome,
    required this.profiles,
  });

  final String accessToken;
  final String refreshToken;
  final String universityId;
  final String username;
  final String nome;
  final String cognome;
  final List<CareerProfileEntity> profiles;

  String get fullName => [
    nome,
    cognome,
  ].where((value) => value.trim().isNotEmpty).join(' ').trim();

  CareerProfileEntity? get activeProfile =>
      profiles.where((profile) => profile.active).firstOrNull ??
      profiles.firstOrNull;
}
