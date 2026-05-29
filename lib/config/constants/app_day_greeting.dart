abstract final class AppDayGreeting {
  static const morning = 'Buongiorno';
  static const afternoon = 'Buon pomeriggio';
  static const evening = 'Buona sera';

  static String resolve([DateTime? dateTime]) {
    final hour = (dateTime ?? DateTime.now()).hour;

    if (hour >= 5 && hour < 13) return morning;
    if (hour >= 13 && hour < 18) return afternoon;

    return evening;
  }
}
