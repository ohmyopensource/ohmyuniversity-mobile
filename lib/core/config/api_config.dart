abstract final class ApiConfig {
  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.ohmyuniversity.app',
  );

  static String get baseUrl {
    final uri = Uri.parse(_baseUrl);
    if (uri.scheme == 'https' || _isLocalDevelopmentHost(uri)) {
      return _baseUrl;
    }

    throw StateError('API_BASE_URL must use HTTPS outside local development.');
  }

  static const timeout = Duration(seconds: 15);

  static bool _isLocalDevelopmentHost(Uri uri) {
    if (uri.scheme != 'http') return false;

    final host = uri.host.toLowerCase();
    if (host == 'localhost' || host == '0.0.0.0' || host == '::1') {
      return true;
    }

    final parts = host.split('.').map(int.tryParse).toList(growable: false);
    if (parts.length != 4 || parts.any((part) => part == null)) return false;

    final first = parts[0]!;
    final second = parts[1]!;

    return first == 10 ||
        first == 127 ||
        (first == 172 && second >= 16 && second <= 31) ||
        (first == 192 && second == 168);
  }
}
