import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/mocks/app_mock_data.dart';
import '../../../../../shared/widgets/academic/academic_exam_widgets.dart';
import '../../../../../shared/widgets/academic/academic_statistics_tiles.dart';
import '../../../../../shared/widgets/academic/academic_summary_tiles.dart';
import '../../../../../shared/widgets/academic/academic_tuition_widgets.dart';
import '../../../../calendario/presentation/providers/calendar_providers.dart';
import '../../models/dashboard_widget_option.dart';
import 'dashboard_calendar_widgets.dart';

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
        value: AppMockData.dashboardArithmeticAverage,
        showTrendBadge: true,
        trend: CareerMetricTrend.up,
      ),
      'weighted_average' => const CareerMetricTile(
        label: 'Media Ponderata',
        value: AppMockData.dashboardWeightedAverage,
        showTrendBadge: true,
        trend: CareerMetricTrend.down,
      ),
      'average_pair' => const CareerAveragePairTile(
        arithmeticAverage: AppMockData.dashboardArithmeticAverage,
        weightedAverage: AppMockData.dashboardWeightedAverage,
      ),
      'acquired_credits' => const CareerMetricTile(
        label: 'Cfu acquisiti',
        value: AppMockData.dashboardCreditsValue,
        showProgress: true,
        isWide: true,
        progressValue: AppMockData.dashboardCreditsProgress,
        progressCaption: AppMockData.dashboardCreditsCaption,
      ),
      'acquired_credits_compact' => const CareerMetricTile(
        label: 'Cfu acquisiti',
        value: AppMockData.dashboardCreditsValue,
        showProgress: true,
        isWide: true,
      ),
      'graduation_projection' => const GraduationProjectionTile(
        value: AppMockData.graduationProjection,
        maxValue: AppMockData.graduationProjectionMax,
      ),
      'average_trend' => AverageTrendTile(
        points: AppMockData.averageTrend
            .map(_toAcademicAverageTrendPoint)
            .toList(growable: false),
      ),
      'calendar_agenda' ||
      'calendar_day' ||
      'calendar_two_day' => const _DashboardCalendarWidget(),
      'exams' => const _DashboardExamsWidget(),
      'appeals' => const _DashboardAppealsWidget(),
      'tuition_fees' => const _DashboardTuitionWidget(),
      'tuition_fees_compact' => _DashboardTuitionCompactWidget(
        preview: preview,
      ),
      _ => _CompactInfoWidget(
        option: option,
        value: '',
        caption: option.subtitle,
      ),
    };
  }
}

AcademicAverageTrendPoint _toAcademicAverageTrendPoint(
  MockAverageTrendPointData point,
) {
  return AcademicAverageTrendPoint(date: point.date, value: point.value);
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

  static final _courses = AppMockData.dashboardExamCourses
      .map(_toAcademicExamCourseData)
      .toList(growable: false);

  static AcademicExamCourseData _toAcademicExamCourseData(
    MockExamCourseData course,
  ) {
    return AcademicExamCourseData(
      id: course.id,
      year: course.year,
      semester: course.semester,
      name: course.name,
      code: course.code,
      credits: course.credits,
      passed: course.passed,
      grade: course.grade,
    );
  }

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

  static final _months = AppMockData.dashboardAppealMonths
      .map(_toAcademicExamAppealMonthData)
      .toList(growable: false);

  static final _appeals = AppMockData.dashboardExamAppeals
      .map(_toAcademicExamAppealData)
      .toList(growable: false);

  static AcademicExamAppealMonthData _toAcademicExamAppealMonthData(
    MockExamAppealMonthData month,
  ) {
    return AcademicExamAppealMonthData(month: month.month, year: month.year);
  }

  static AcademicExamAppealData _toAcademicExamAppealData(
    MockExamAppealData appeal,
  ) {
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

class _DashboardCalendarWidget extends ConsumerWidget {
  const _DashboardCalendarWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(calendarClockProvider).value ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventsAsync = ref.watch(homeCalendarEventsProvider);

    return eventsAsync.when(
      data: (events) =>
          DashboardCalendarAgendaWidget(date: today, events: events),
      loading: () =>
          DashboardCalendarAgendaWidget(date: today, events: const []),
      error: (_, _) =>
          DashboardCalendarAgendaWidget(date: today, events: const []),
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

  static final _fees = AppMockData.tuitionFees
      .map(_toAcademicTuitionFeeData)
      .toList(growable: false);

  static AcademicTuitionFeeData _toAcademicTuitionFeeData(
    MockTuitionFeeData fee,
  ) {
    return AcademicTuitionFeeData(
      id: fee.id,
      title: fee.title,
      amount: fee.amount,
      isPaid: fee.isPaid,
      academicYear: fee.academicYear,
      referenceDate: fee.referenceDate,
      isOverdue: fee.isOverdue,
      receiptAvailable: fee.receiptAvailable,
    );
  }

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

class _DashboardTuitionCompactWidget extends StatelessWidget {
  const _DashboardTuitionCompactWidget({required this.preview});

  final bool preview;

  static final _fees = AppMockData.tuitionFees
      .map(_DashboardTuitionWidgetState._toAcademicTuitionFeeData)
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    final paidCount = _fees.where((fee) => fee.isPaid).length;
    final unpaidCount = _fees.length - paidCount;

    return AcademicTuitionCounterTile(
      unpaidCount: unpaidCount,
      paidCount: paidCount,
      onTap: preview
          ? null
          : () => context.pushNamed(AppRoutes.didatticaTuitionFeesName),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AcademicSummaryTiles.tileColor.withValues(alpha: 0.36),
            Colors.white.withValues(alpha: 0.96),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.colorWarningLight.withValues(alpha: 0.42),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorWarningShadow.withValues(alpha: 0.08),
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
