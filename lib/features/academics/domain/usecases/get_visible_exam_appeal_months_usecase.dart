import '../entities/exam_appeal_entity.dart';
import '../entities/exam_appeal_month_entity.dart';

class GetVisibleExamAppealMonthsUseCase {
  const GetVisibleExamAppealMonthsUseCase();

  static const _standardSessionMonths = [6, 7, 9, 10];
  static const _winterSessionMonths = [1, 2];
  static const _sessionOrder = [6, 7, 9, 10, 1, 2];

  List<ExamAppealMonthEntity> call({
    required List<ExamAppealEntity> appeals,
    DateTime? currentDate,
  }) {
    final now = currentDate ?? DateTime.now();
    final sessionYear = _sessionYearFor(now);
    final canShowWinterSession = !now.isBefore(DateTime(sessionYear, 12));
    final visibleMonths = <ExamAppealMonthEntity>{};

    for (final appeal in appeals) {
      final appealYear = appeal.date.year;
      final appealMonth = appeal.date.month;
      final isStandardSessionAppeal =
          appealYear == sessionYear &&
          _standardSessionMonths.contains(appealMonth);
      final isWinterSessionAppeal =
          canShowWinterSession &&
          appealYear == sessionYear + 1 &&
          _winterSessionMonths.contains(appealMonth);

      if (isStandardSessionAppeal || isWinterSessionAppeal) {
        visibleMonths.add(
          ExamAppealMonthEntity(month: appealMonth, year: appealYear),
        );
      }
    }

    return visibleMonths.toList()..sort(_compareSessionMonths);
  }

  int _sessionYearFor(DateTime currentDate) {
    if (currentDate.month <= 2) return currentDate.year - 1;
    return currentDate.year;
  }

  int _compareSessionMonths(
    ExamAppealMonthEntity first,
    ExamAppealMonthEntity second,
  ) {
    final firstIndex = _sessionOrder.indexOf(first.month);
    final secondIndex = _sessionOrder.indexOf(second.month);

    if (firstIndex == -1 && secondIndex == -1) {
      final yearComparison = first.year.compareTo(second.year);
      if (yearComparison != 0) return yearComparison;
      return first.month.compareTo(second.month);
    }
    if (firstIndex == -1) return 1;
    if (secondIndex == -1) return -1;

    return firstIndex.compareTo(secondIndex);
  }
}
