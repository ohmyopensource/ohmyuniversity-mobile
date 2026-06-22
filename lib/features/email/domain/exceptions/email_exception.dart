class EmailException implements Exception {
  const EmailException(this.message);

  final String message;

  @override
  String toString() => message;
}

class EmailAccountNotConnectedException extends EmailException {
  const EmailAccountNotConnectedException()
    : super('Collega la tua email istituzionale per visualizzare la posta.');
}
