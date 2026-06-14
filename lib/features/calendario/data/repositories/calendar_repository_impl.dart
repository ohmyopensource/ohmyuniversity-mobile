import '../../domain/entities/calendar_event_entity.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/calendar_mock_datasource.dart';
import '../models/calendar_event_model.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  const CalendarRepositoryImpl(this._dataSource);

  final CalendarMockDataSource _dataSource;

  @override
  Future<List<CalendarEventEntity>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _dataSource.getEvents(startDate: startDate, endDate: endDate);
  }

  @override
  Future<CalendarEventEntity> createEvent(CalendarEventEntity event) {
    return _dataSource.createEvent(CalendarEventModel.fromEntity(event));
  }

  @override
  Future<CalendarEventEntity> updateEvent(CalendarEventEntity event) {
    return _dataSource.updateEvent(CalendarEventModel.fromEntity(event));
  }

  @override
  Future<void> deleteEvent(String eventId) {
    return _dataSource.deleteEvent(eventId);
  }
}
