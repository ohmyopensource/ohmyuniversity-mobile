/// Gerarchia degli errori del domain layer.
/// I repository convertono le eccezioni tecniche in Failure tipizzate.
sealed class Failure {
  const Failure({required this.message});
  final String message;
}

/// Errore di rete (no connection, timeout, ecc.)
final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Errore di rete. Controlla la connessione.'});
}

/// Risposta HTTP con status code di errore (4xx, 5xx)
final class ServerFailure extends Failure {
  const ServerFailure({required super.message, this.statusCode});
  final int? statusCode;
}

/// Errore di autenticazione (token scaduto, non autorizzato)
final class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Sessione scaduta. Effettua nuovamente il login.'});
}

/// Errore di parsing / formato dati inatteso
final class ParseFailure extends Failure {
  const ParseFailure({super.message = 'Errore nel formato dei dati ricevuti.'});
}

/// Errore generico / inaspettato
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'Si è verificato un errore inatteso.'});
}