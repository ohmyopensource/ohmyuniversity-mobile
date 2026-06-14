abstract final class CalendarDateLabels {
  static const _months = [
    'Gen',
    'Feb',
    'Mar',
    'Apr',
    'Mag',
    'Giu',
    'Lug',
    'Ago',
    'Set',
    'Ott',
    'Nov',
    'Dic',
  ];

  static const _weekdays = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];

  static String monthYear(DateTime date) {
    final year = date.year.toString().substring(2);
    return '${_months[date.month - 1]} $year';
  }

  static String weekday(DateTime date) {
    return _weekdays[date.weekday - 1];
  }

  static String dayMonth(DateTime date) {
    return '${date.day} ${_months[date.month - 1]}';
  }

  static String hour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  static String duration(DateTime startDate, DateTime endDate) {
    final minutes = endDate.difference(startDate).inMinutes;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      return '${hours}h ${remainingMinutes}m';
    }

    if (hours > 0) return '${hours}h';

    return '${remainingMinutes}m';
  }

  static String eventTimeRange(DateTime startDate, DateTime endDate) {
    return '${time(startDate)}-${time(endDate)}';
  }

  static String time(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
