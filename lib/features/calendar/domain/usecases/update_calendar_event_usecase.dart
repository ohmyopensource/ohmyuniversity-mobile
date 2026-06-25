import '../../../../core/usecases/usecase.dart';
import '../entities/calendar_event_entity.dart';
import '../repositories/calendar_repository.dart';

class UpdateCalendarEventUseCase
    implements UseCase<CalendarEventEntity, CalendarEventEntity> {
  const UpdateCalendarEventUseCase(this._repository);

  final CalendarRepository _repository;

  @override
  Future<CalendarEventEntity> call(CalendarEventEntity params) {
    return _repository.updateEvent(params);
  }
}
