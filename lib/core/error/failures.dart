sealed class Failure {
  const Failure({required this.message});
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Errore di rete. Controlla la connessione.',
  });
}

final class ServerFailure extends Failure {
  const ServerFailure({required super.message, this.statusCode});
  final int? statusCode;
}

final class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Sessione scaduta. Effettua nuovamente il login.',
  });
}

final class ParseFailure extends Failure {
  const ParseFailure({super.message = 'Errore nel formato dei dati ricevuti.'});
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Si \u00E8 verificato un errore inatteso.',
  });
}
