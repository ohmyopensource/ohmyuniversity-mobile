import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/widgets/academic/academic_exam_widgets.dart';
import '../../../../../shared/widgets/academic/academic_summary_tiles.dart';
import '../../../../../shared/widgets/academic/academic_tuition_widgets.dart';
import '../../../../calendario/presentation/providers/calendar_providers.dart';
import '../../../../didattica/presentation/providers/appeals_controller.dart';
import '../../../../didattica/presentation/providers/career_provider.dart';
import '../../../../didattica/presentation/providers/tuition_providers.dart';
import '../../../../didattica/domain/entities/tuition_fee_entity.dart';
import '../../../../didattica/domain/entities/didattica_exam_course_entity.dart';
import '../../models/dashboard_widget_option.dart';
import 'dashboard_calendar_widgets.dart';
import 'home_appeals_widget.dart';
import 'home_career_widgets.dart';

class DashboardWidgetContent extends ConsumerWidget {
  const DashboardWidgetContent({
    super.key,
    required this.option,
    this.preview = false,
  });

  final DashboardWidgetOption option;
  final bool preview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(careerStatisticsProvider);

    return switch (option.key) {
      'student' => const StudentIdentityTile(),
      'arithmetic_average' => CareerMetricTile(
        label: 'Media aritmetica',
        value: statistics.arithmeticAverage.toStringAsFixed(1),
        showTrendBadge: true,
        trend: CareerMetricTrend.up,
        whiteSurface: true,
      ),
      'weighted_average' => CareerMetricTile(
        label: 'Media Ponderata',
        value: statistics.weightedAverage.toStringAsFixed(1),
        showTrendBadge: true,
        trend: CareerMetricTrend.down,
        whiteSurface: true,
      ),
      'average_pair' => CareerAveragePairTile(
        arithmeticAverage: statistics.arithmeticAverage.toStringAsFixed(1),
        weightedAverage: statistics.weightedAverage.toStringAsFixed(1),
        whiteSurface: true,
      ),
      'acquired_credits' => HomeCareerProgressWidget(
        acquiredCredits: statistics.acquiredCredits,
        totalCredits: statistics.totalCredits,
      ),
      'acquired_credits_compact' => HomeCareerProgressWidget(
        acquiredCredits: statistics.acquiredCredits,
        totalCredits: statistics.totalCredits,
        compact: true,
      ),
      'graduation_projection' => HomeGraduationProjectionWidget(
        value: statistics.projectedGraduationScore,
      ),
      'graduation_base' => HomeCareerMetricWidget(
        label: 'Base di laurea',
        value: statistics.graduationBase.toStringAsFixed(0),
        suffix: '/110',
        icon: LucideIcons.graduationCap,
        color: AppColors.colorSuccessDark,
      ),
      'honors' => HomeCareerMetricWidget(
        label: 'Lodi ottenute',
        value: '${statistics.honorsCount}',
        icon: LucideIcons.sparkles,
        color: AppColors.colorWarningDark,
      ),
      'grade_history' => HomeCareerHistoryWidget(
        title: 'Storico voti',
        points: statistics.gradeHistory,
        color: AppColors.colorPrimaryDark,
      ),
      'average_trend' => HomeCareerHistoryWidget(
        title: 'Storico media ponderata',
        points: statistics.averageTrend,
        color: AppColors.colorSecondaryDark,
      ),
      'calendar_agenda' ||
      'calendar_day' ||
      'calendar_two_day' => const _DashboardCalendarWidget(),
      'exams' => const _DashboardExamsWidget(),
      'appeals' => HomeAppealsWidget(
        appeals: ref.watch(allExamBookingsProvider),
      ),
      'tuition_fees' => _DashboardTuitionWidget(preview: preview),
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

class _DashboardExamsWidget extends ConsumerStatefulWidget {
  const _DashboardExamsWidget();

  @override
  ConsumerState<_DashboardExamsWidget> createState() =>
      _DashboardExamsWidgetState();
}

class _DashboardExamsWidgetState extends ConsumerState<_DashboardExamsWidget> {
  int _selectedYear = 1;
  int _selectedSemester = 0;
  final Map<String, int> _provisionalGrades = {};

  static AcademicExamCourseData _toAcademicExamCourseData(
    DidatticaExamCourseEntity course,
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
    final careerState = ref.watch(careerProvider);
    if (careerState.isLoading) {
      return const _DashboardAsyncState(isLoading: true);
    }
    if (careerState.errorMessage != null) {
      return const _DashboardAsyncState(isLoading: false);
    }
    final courses = careerState.courses
        .map(_toAcademicExamCourseData)
        .toList(growable: false);
    final years = courses.map((course) => course.year).toSet().toList()..sort();
    if (years.isEmpty) {
      return const Center(child: Text('Nessun esame disponibile'));
    }
    final effectiveYear = years.contains(_selectedYear)
        ? _selectedYear
        : years.first;

    return AcademicExamsPanel(
      compact: true,
      courses: courses,
      years: years,
      selectedYear: effectiveYear,
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

class _DashboardTuitionWidget extends ConsumerStatefulWidget {
  const _DashboardTuitionWidget({required this.preview});

  final bool preview;

  @override
  ConsumerState<_DashboardTuitionWidget> createState() =>
      _DashboardTuitionWidgetState();
}

class _DashboardTuitionWidgetState
    extends ConsumerState<_DashboardTuitionWidget> {
  int _selectedStatus = 0;

  static AcademicTuitionFeeData _toAcademicTuitionFeeData(
    TuitionFeeEntity fee,
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
    if (widget.preview) {
      return _buildPanel(const []);
    }
    return ref
        .watch(tuitionSnapshotProvider)
        .when(
          data: (snapshot) => _buildPanel(
            snapshot.fees
                .map(_toAcademicTuitionFeeData)
                .toList(growable: false),
          ),
          loading: () => const _DashboardAsyncState(isLoading: true),
          error: (_, _) => const _DashboardAsyncState(isLoading: false),
        );
  }

  Widget _buildPanel(List<AcademicTuitionFeeData> fees) {
    return AcademicTuitionPanel(
      fees: fees,
      selectedStatus: _selectedStatus,
      onStatusChanged: (status) => setState(() => _selectedStatus = status),
    );
  }
}

class _DashboardTuitionCompactWidget extends ConsumerWidget {
  const _DashboardTuitionCompactWidget({required this.preview});

  final bool preview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (preview) return _buildCounter(context, const []);

    return ref
        .watch(tuitionSnapshotProvider)
        .when(
          data: (snapshot) => _buildCounter(context, snapshot.fees),
          loading: () => const _DashboardAsyncState(isLoading: true),
          error: (_, _) => const _DashboardAsyncState(isLoading: false),
        );
  }

  Widget _buildCounter(BuildContext context, List<TuitionFeeEntity> fees) {
    final paidCount = fees.where((fee) => fee.isPaid).length;
    return AcademicTuitionCounterTile(
      unpaidCount: fees.length - paidCount,
      paidCount: paidCount,
      onTap: preview
          ? null
          : () => context.pushNamed(AppRoutes.didatticaTuitionFeesName),
    );
  }
}

class _DashboardAsyncState extends StatelessWidget {
  const _DashboardAsyncState({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(LucideIcons.cloudOff, color: AppColors.colorNeutral400),
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
