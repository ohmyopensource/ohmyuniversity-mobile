class ExternalServicesEntity {
  const ExternalServicesEntity({
    required this.universityId,
    required this.universityName,
    required this.moodleUrl,
    required this.libraryUrl,
  });

  final String universityId;
  final String universityName;
  final Uri? moodleUrl;
  final Uri? libraryUrl;
}
