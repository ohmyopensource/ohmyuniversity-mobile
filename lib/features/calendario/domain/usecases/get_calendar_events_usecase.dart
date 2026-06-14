import '../../../../core/usecases/usecase.dart';
import '../entities/calendar_event_entity.dart';
import '../repositories/calendar_repository.dart';

class GetCalendarEventsParams {
  const GetCalendarEventsParams({this.startDate, this.endDate});

  final DateTime? startDate;
  final DateTime? endDate;
}

class GetCalendarEventsUseCase
    implements UseCase<List<CalendarEventEntity>, GetCalendarEventsParams> {
  const GetCalendarEventsUseCase(this._repository);

  final CalendarRepository _repository;

  @override
  Future<List<CalendarEventEntity>> call(GetCalendarEventsParams params) {
    return _repository.getEvents(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
