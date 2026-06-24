class CalendarException implements Exception {
  const CalendarException(this.message);

  final String message;

  @override
  String toString() => message;
}
