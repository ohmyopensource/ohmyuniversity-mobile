class TimetableException implements Exception {
  const TimetableException(this.message);

  final String message;

  @override
  String toString() => message;
}
