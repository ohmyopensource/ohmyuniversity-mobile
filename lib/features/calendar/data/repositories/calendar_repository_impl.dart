import '../../domain/entities/calendar_event_entity.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/calendar_mock_datasource.dart';
import '../datasources/calendar_remote_datasource.dart';
import '../models/calendar_event_model.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  const CalendarRepositoryImpl(
    this._remoteDataSource,
    this._mockDataSource, {
    required bool useMock,
  }) : _useMock = useMock;

  final CalendarRemoteDataSource _remoteDataSource;
  final CalendarMockDataSource _mockDataSource;
  final bool _useMock;

  @override
  Future<List<CalendarEventEntity>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _useMock
        ? _mockDataSource.getEvents(startDate: startDate, endDate: endDate)
        : _remoteDataSource.getEvents(startDate: startDate, endDate: endDate);
  }

  @override
  Future<CalendarEventEntity> createEvent(CalendarEventEntity event) {
    final model = CalendarEventModel.fromEntity(event);
    return _useMock
        ? _mockDataSource.createEvent(model)
        : _remoteDataSource.createEvent(model);
  }

  @override
  Future<CalendarEventEntity> updateEvent(CalendarEventEntity event) {
    final model = CalendarEventModel.fromEntity(event);
    return _useMock
        ? _mockDataSource.updateEvent(model)
        : _remoteDataSource.updateEvent(model);
  }

  @override
  Future<void> deleteEvent(String eventId) {
    return _useMock
        ? _mockDataSource.deleteEvent(eventId)
        : _remoteDataSource.deleteEvent(eventId);
  }
}
