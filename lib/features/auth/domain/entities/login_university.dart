class LoginUniversity {
  const LoginUniversity({
    required this.id,
    required this.name,
    required this.shortName,
    required this.emailDomains,
    this.usesEmailLocalPartAsUsername = false,
  });

  final String id;
  final String name;
  final String shortName;
  final List<String> emailDomains;
  final bool usesEmailLocalPartAsUsername;

  bool acceptsEmail(String email) {
    final separatorIndex = email.lastIndexOf('@');
    if (separatorIndex <= 0 || separatorIndex == email.length - 1) {
      return false;
    }

    final domain = email.substring(separatorIndex + 1).toLowerCase();
    return emailDomains.any((allowed) => allowed.toLowerCase() == domain);
  }

  String authenticationUsername(String email) {
    final normalizedEmail = email.trim();
    if (!usesEmailLocalPartAsUsername) return normalizedEmail;

    final separatorIndex = normalizedEmail.lastIndexOf('@');
    return separatorIndex > 0
        ? normalizedEmail.substring(0, separatorIndex)
        : normalizedEmail;
  }
}
