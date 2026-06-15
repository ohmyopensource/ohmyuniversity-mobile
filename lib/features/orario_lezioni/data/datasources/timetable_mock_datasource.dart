import '../../../../shared/mocks/app_mock_data.dart';
import '../models/timetable_model.dart';

class TimetableMockDataSource {
  const TimetableMockDataSource();

  List<TimetableModel> getStudentTimetables() {
    return AppMockData.timetableDocuments.map(TimetableModel.fromMock).toList();
  }
}
