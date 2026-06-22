import '../../domain/entities/external_services_entity.dart';

class ExternalServicesModel extends ExternalServicesEntity {
  const ExternalServicesModel({
    required super.universityId,
    required super.universityName,
    required super.moodleUrl,
    required super.libraryUrl,
  });

  factory ExternalServicesModel.fromJson(Map<String, dynamic> json) {
    return ExternalServicesModel(
      universityId: json['universityId'] as String? ?? '',
      universityName: json['name'] as String? ?? '',
      moodleUrl: _parseUrl(json['moodleUrl']),
      libraryUrl: _parseUrl(json['libraryUrl']),
    );
  }

  static Uri? _parseUrl(Object? value) {
    final text = value as String?;
    if (text == null || text.trim().isEmpty) return null;
    final uri = Uri.tryParse(text.trim());
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) return null;
    return uri;
  }
}
