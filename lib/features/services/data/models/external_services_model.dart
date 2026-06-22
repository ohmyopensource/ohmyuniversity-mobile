import '../../domain/entities/external_services_entity.dart';

class ExternalServicesModel extends ExternalServicesEntity {
  const ExternalServicesModel({
    required super.universityId,
    required super.universityName,
    required super.moodleUrl,
    required super.libraryUrl,
    super.studentPortalUrl,
  });

  factory ExternalServicesModel.fromJson(Map<String, dynamic> json) {
    final universityId = json['universityId'] as String? ?? '';
    final isUnimol = universityId.trim().toUpperCase() == 'UNIMOL';
    return ExternalServicesModel(
      universityId: universityId,
      universityName: json['name'] as String? ?? '',
      moodleUrl: isUnimol
          ? Uri.parse('https://learn.unimol.it/')
          : _parseUrl(json['moodleUrl']),
      libraryUrl: isUnimol
          ? Uri.parse('https://www3.unimol.it/biblioteche/home')
          : _parseUrl(json['libraryUrl']),
      studentPortalUrl: _deriveStudentPortalUrl(universityId),
    );
  }

  static Uri? _parseUrl(Object? value) {
    final text = value as String?;
    if (text == null || text.trim().isEmpty) return null;
    final uri = Uri.tryParse(text.trim());
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) return null;
    return uri;
  }

  static Uri? _deriveStudentPortalUrl(Object? universityId) {
    final id = (universityId as String?)?.trim().toLowerCase() ?? '';
    if (id.isEmpty || !RegExp(r'^[a-z0-9-]+$').hasMatch(id)) return null;
    return Uri.https('$id.esse3.cineca.it', '/Home.do');
  }
}
