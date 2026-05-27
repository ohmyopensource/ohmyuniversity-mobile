class NetworkException implements Exception {
  const NetworkException([this.message = 'Errore di rete']);
  final String message;
}

class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;
}

class AuthException implements Exception {
  const AuthException([this.message = 'Non autorizzato']);
  final String message;
}

class ParseException implements Exception {
  const ParseException([this.message = 'Errore parsing']);
  final String message;
}
