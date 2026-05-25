/// Contratto base per tutti i Use Case del domain layer.
///
/// [Result] ÃƒÂ¨ il tipo di ritorno del use case.
/// [Params] sono i parametri di input (usa [NoParams] se non ce ne sono).
abstract interface class UseCase<Result, Params> {
  Future<Result> call(Params params);
}

/// Usato quando un use case non richiede parametri.
final class NoParams {
  const NoParams();
}
