import '../../../../shared/mocks/app_mock_data.dart';
import '../models/exam_appeal_model.dart';

class ExamAppealsMockDataSource {
  const ExamAppealsMockDataSource();

  List<ExamAppealModel> getExamAppeals() {
    return AppMockData.examAppeals.map(_toExamAppealModel).toList();
  }

  ExamAppealModel _toExamAppealModel(MockExamAppealData appeal) {
    return ExamAppealModel(
      id: appeal.id,
      examName: appeal.examName,
      month: appeal.month,
      date: appeal.date,
      time: appeal.time,
      room: appeal.room,
      isBooked: appeal.isBooked,
      isBookable: appeal.isBookable,
    );
  }
}
