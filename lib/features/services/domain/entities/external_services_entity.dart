class ExternalServicesEntity {
  const ExternalServicesEntity({
    required this.universityId,
    required this.universityName,
    required this.moodleUrl,
    required this.libraryUrl,
    this.studentPortalUrl,
  });

  final String universityId;
  final String universityName;
  final Uri? moodleUrl;
  final Uri? libraryUrl;
  final Uri? studentPortalUrl;
}
