class ServicesException implements Exception {
  const ServicesException(this.message);

  final String message;

  @override
  String toString() => message;
}
