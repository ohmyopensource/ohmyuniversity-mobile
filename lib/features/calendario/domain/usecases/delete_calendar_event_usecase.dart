import '../../../../core/usecases/usecase.dart';
import '../repositories/calendar_repository.dart';

class DeleteCalendarEventUseCase implements UseCase<void, String> {
  const DeleteCalendarEventUseCase(this._repository);

  final CalendarRepository _repository;

  @override
  Future<void> call(String params) {
    return _repository.deleteEvent(params);
  }
}
