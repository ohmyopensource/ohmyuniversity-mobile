class CareerDataException implements Exception {
  const CareerDataException(this.message);

  final String message;

  @override
  String toString() => message;
}
