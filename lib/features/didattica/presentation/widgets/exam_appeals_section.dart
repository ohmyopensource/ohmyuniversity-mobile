import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/academic/academic_exam_widgets.dart';
import '../../domain/entities/exam_appeal_entity.dart';
import '../../domain/entities/exam_appeal_month_entity.dart';
import '../providers/exam_appeal_months_provider.dart';
import '../providers/exam_appeals_provider.dart';

class ExamAppealsSection extends ConsumerStatefulWidget {
  const ExamAppealsSection({super.key});

  @override
  ConsumerState<ExamAppealsSection> createState() => _ExamAppealsSectionState();
}

class _ExamAppealsSectionState extends ConsumerState<ExamAppealsSection>
    with TickerProviderStateMixin {
  String? _selectedMonthId;
  int _selectedStatus = 0;

  void _changeMonth(AcademicExamAppealMonthData month) {
    if (month.id == _selectedMonthId) return;

    setState(() {
      _selectedMonthId = month.id;
      _selectedStatus = 0;
    });
  }

  void _changeStatus(int status) {
    if (status == _selectedStatus) return;

    setState(() => _selectedStatus = status);
  }

  @override
  Widget build(BuildContext context) {
    final appeals = ref.watch(examAppealsProvider);
    final months = ref.watch(visibleExamAppealMonthsProvider);
    final selectedMonth = months.where((month) {
      return month.id == _selectedMonthId;
    }).firstOrNull;

    return AcademicExamAppealsPanel(
      months: months.map(_mapMonth).toList(),
      selectedMonth: selectedMonth == null ? null : _mapMonth(selectedMonth),
      selectedStatus: _selectedStatus,
      appeals: appeals.map(_mapAppeal).toList(),
      onMonthChanged: _changeMonth,
      onStatusChanged: _changeStatus,
      onBookingConfirmed: (appeal) {
        // TODO: create and call a reservation use case
        debugPrint('Prenotazione confermata: ${appeal.examName}');
      },
    );
  }

  AcademicExamAppealMonthData _mapMonth(ExamAppealMonthEntity month) {
    return AcademicExamAppealMonthData(month: month.month, year: month.year);
  }

  AcademicExamAppealData _mapAppeal(ExamAppealEntity appeal) {
    return AcademicExamAppealData(
      id: appeal.id,
      examName: appeal.examName,
      month: appeal.month,
      date: appeal.date,
      time: appeal.time,
      isBooked: appeal.isBooked,
      isBookable: appeal.isBookable,
      room: appeal.room,
    );
  }
}
