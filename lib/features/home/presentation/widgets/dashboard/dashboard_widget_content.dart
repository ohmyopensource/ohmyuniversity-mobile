import 'package:flutter/material.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/widgets/academic/academic_exam_widgets.dart';
import '../../../../../shared/widgets/academic/academic_statistics_tiles.dart';
import '../../../../../shared/widgets/academic/academic_summary_tiles.dart';
import '../../../../../shared/widgets/academic/academic_tuition_widgets.dart';
import '../../models/dashboard_widget_option.dart';

class DashboardWidgetContent extends StatelessWidget {
  const DashboardWidgetContent({
    super.key,
    required this.option,
    this.preview = false,
  });

  final DashboardWidgetOption option;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    return switch (option.key) {
      'student' => const StudentIdentityTile(),
      'arithmetic_average' => const CareerMetricTile(
        label: 'Media aritmetica',
        value: '25.5',
      ),
      'weighted_average' => const CareerMetricTile(
        label: 'Media Ponderata',
        value: '25.5',
      ),
      'acquired_credits' => const CareerMetricTile(
        label: 'Cfu acquisiti',
        value: '90/180',
        showProgress: true,
        isWide: true,
      ),
      'graduation_projection' => const GraduationProjectionTile(
        value: 90,
        maxValue: 110,
      ),
      'average_trend' => AverageTrendTile(
        points: [
          AcademicAverageTrendPoint(date: DateTime(2026, 5, 23), value: 30),
          AcademicAverageTrendPoint(date: DateTime(2026, 6, 20), value: 28.8),
          AcademicAverageTrendPoint(date: DateTime(2026, 7, 18), value: 27.2),
          AcademicAverageTrendPoint(date: DateTime(2026, 8, 28), value: 25.5),
        ],
      ),
      'exams' => const _DashboardExamsWidget(),
      'appeals' => const _DashboardAppealsWidget(),
      'tuition_fees' => const _DashboardTuitionWidget(),
      _ => _CompactInfoWidget(
        option: option,
        value: '',
        caption: option.subtitle,
      ),
    };
  }
}

class _DashboardExamsWidget extends StatefulWidget {
  const _DashboardExamsWidget();

  @override
  State<_DashboardExamsWidget> createState() => _DashboardExamsWidgetState();
}

class _DashboardExamsWidgetState extends State<_DashboardExamsWidget> {
  int _selectedYear = 1;
  int _selectedSemester = 0;
  final Map<String, int> _provisionalGrades = {};

  static const _courses = [
    AcademicExamCourseData(
      id: 'fondamenti-informatica',
      year: 1,
      semester: 1,
      name: 'Fondamenti di Informatica',
      code: 'INF/01',
      credits: 9,
      passed: true,
      grade: '30',
    ),
    AcademicExamCourseData(
      id: 'algebra-lineare',
      year: 1,
      semester: 1,
      name: 'Algebra Lineare',
      code: 'MAT/03',
      credits: 6,
      passed: false,
    ),
    AcademicExamCourseData(
      id: 'architettura-elaboratori',
      year: 1,
      semester: 2,
      name: 'Architettura degli Elaboratori',
      code: 'INF/01',
      credits: 9,
      passed: true,
      grade: '27',
    ),
    AcademicExamCourseData(
      id: 'matematica-discreta',
      year: 1,
      semester: 2,
      name: 'Matematica Discreta',
      code: 'MAT/02',
      credits: 6,
      passed: false,
    ),
    AcademicExamCourseData(
      id: 'basi-dati',
      year: 2,
      semester: 1,
      name: 'Basi di Dati',
      code: 'INF/01',
      credits: 9,
      passed: true,
      grade: '30L',
    ),
    AcademicExamCourseData(
      id: 'sistemi-operativi',
      year: 2,
      semester: 1,
      name: 'Sistemi Operativi',
      code: 'INF/01',
      credits: 9,
      passed: false,
    ),
    AcademicExamCourseData(
      id: 'reti-calcolatori',
      year: 3,
      semester: 1,
      name: 'Reti di Calcolatori',
      code: 'INF/01',
      credits: 6,
      passed: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AcademicExamsPanel(
      courses: _courses,
      years: const [1, 2, 3],
      selectedYear: _selectedYear,
      selectedSemester: _selectedSemester,
      provisionalGrades: _provisionalGrades,
      onYearChanged: (year) {
        setState(() {
          _selectedYear = year;
          _selectedSemester = 0;
        });
      },
      onSemesterChanged: (semester) {
        setState(() => _selectedSemester = semester);
      },
      onProvisionalGradeChanged: (courseId, grade) {
        setState(() => _provisionalGrades[courseId] = grade);
      },
    );
  }
}

class _DashboardAppealsWidget extends StatefulWidget {
  const _DashboardAppealsWidget();

  @override
  State<_DashboardAppealsWidget> createState() =>
      _DashboardAppealsWidgetState();
}

class _DashboardAppealsWidgetState extends State<_DashboardAppealsWidget> {
  String? _selectedMonthId;
  int _selectedStatus = 0;

  static const _months = [
    AcademicExamAppealMonthData(month: 6, year: 2026),
    AcademicExamAppealMonthData(month: 7, year: 2026),
    AcademicExamAppealMonthData(month: 9, year: 2026),
  ];

  static final _appeals = [
    AcademicExamAppealData(
      id: 'programmazione-booked',
      examName: 'Programmazione I',
      month: 6,
      date: DateTime(2026, 6, 18),
      time: '09:30',
      isBooked: true,
      room: 'Aula 2',
    ),
    AcademicExamAppealData(
      id: 'analisi-booked',
      examName: 'Analisi Matematica',
      month: 6,
      date: DateTime(2026, 6, 26),
      time: '11:00',
      isBooked: true,
      room: 'Aula Magna',
    ),
    AcademicExamAppealData(
      id: 'basi-dati-open',
      examName: 'Basi di Dati',
      month: 6,
      date: DateTime(2026, 6, 30),
      time: '10:00',
      isBooked: false,
      isBookable: true,
      room: 'Lab 1',
    ),
    AcademicExamAppealData(
      id: 'reti-disabled',
      examName: 'Reti di Calcolatori',
      month: 6,
      date: DateTime(2026, 6, 28),
      time: '15:00',
      isBooked: false,
      isBookable: false,
      room: 'Aula 5',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedMonth = _months.where((month) {
      return month.id == _selectedMonthId;
    }).firstOrNull;

    return AcademicExamAppealsPanel(
      months: _months,
      selectedMonth: selectedMonth,
      selectedStatus: _selectedStatus,
      appeals: _appeals,
      onMonthChanged: (month) {
        setState(() {
          _selectedMonthId = month.id;
          _selectedStatus = 0;
        });
      },
      onStatusChanged: (status) {
        setState(() => _selectedStatus = status);
      },
    );
  }
}

class _DashboardTuitionWidget extends StatefulWidget {
  const _DashboardTuitionWidget();

  @override
  State<_DashboardTuitionWidget> createState() =>
      _DashboardTuitionWidgetState();
}

class _DashboardTuitionWidgetState extends State<_DashboardTuitionWidget> {
  int _selectedStatus = 0;

  static const _fees = [
    AcademicTuitionFeeData(
      id: 'regional-tax',
      title: 'Tassa Regionale',
      amount: 150,
      isPaid: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AcademicTuitionPanel(
      fees: _fees,
      selectedStatus: _selectedStatus,
      onStatusChanged: (status) {
        setState(() => _selectedStatus = status);
      },
    );
  }
}

class _CompactInfoWidget extends StatelessWidget {
  const _CompactInfoWidget({
    required this.option,
    required this.value,
    required this.caption,
  });

  final DashboardWidgetOption option;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AcademicSummaryTiles.tileColor,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: option.accentBackgroundColor.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(option.icon, color: AppColors.textPrimary, size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.58),
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          if (value.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
