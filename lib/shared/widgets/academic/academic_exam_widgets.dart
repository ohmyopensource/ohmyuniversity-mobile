import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_pagination/custom_pagination_widget.dart';
import '../../../../shared/widgets/custom_tab/custom_tab_widget.dart';
import '../../../../shared/widgets/custom_text/custom_text_widget.dart';
import '../../../../shared/widgets/custom_toast/custom_toast_service.dart';
import '../custom_card/custom_card_variants_widget.dart';
import '../custom_card/custom_card_widget.dart';
import '../custom_toast/custom_toast_model.dart';

// ─── Data models ──────────────────────────────────────────────────────────────

class AcademicExamCourseData {
  const AcademicExamCourseData({
    required this.id,
    required this.year,
    required this.semester,
    required this.name,
    required this.code,
    required this.credits,
    required this.passed,
    this.grade,
  });

  final String id;
  final int year;
  final int semester;
  final String name;
  final String code;
  final int credits;
  final bool passed;
  final String? grade;
}

class AcademicExamAppealMonthData {
  const AcademicExamAppealMonthData({required this.month, required this.year});

  final int month;
  final int year;

  String get id => '$year-$month';
}

class AcademicExamAppealData {
  const AcademicExamAppealData({
    required this.id,
    required this.examName,
    required this.month,
    required this.date,
    required this.time,
    required this.isBooked,
    this.isBookable = false,
    this.room,
  });

  final String id;
  final String examName;
  final int month;
  final DateTime date;
  final String time;
  final bool isBooked;
  final bool isBookable;
  final String? room;
}

// ─── AcademicExamsPanel ───────────────────────────────────────────────────────

class AcademicExamsPanel extends StatelessWidget {
  const AcademicExamsPanel({
    super.key,
    required this.courses,
    required this.years,
    required this.selectedYear,
    required this.selectedSemester,
    required this.provisionalGrades,
    required this.onYearChanged,
    required this.onSemesterChanged,
    required this.onProvisionalGradeChanged,
  });

  final List<AcademicExamCourseData> courses;
  final List<int> years;
  final int selectedYear;
  final int selectedSemester;
  final Map<String, int> provisionalGrades;
  final ValueChanged<int> onYearChanged;
  final ValueChanged<int> onSemesterChanged;
  final void Function(String courseId, int grade) onProvisionalGradeChanged;

  @override
  Widget build(BuildContext context) {
    final visibleCourses = courses
        .where(
          (c) => c.year == selectedYear && c.semester == selectedSemester + 1,
    )
        .toList();

    final yearTabs = years
        .map((y) => TabItem(id: '$y', label: 'Anno $y'))
        .toList();

    const semesterTabs = [
      TabItem(id: '0', label: 'Primo semestre'),
      TabItem(id: '1', label: 'Secondo semestre'),
    ];

    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEEFDFF),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTabWidget(
              tabs: yearTabs,
              activeTab: '$selectedYear',
              tabStyle: TabStyle.pill,
              variant: TabVariant.primary,
              size: TabSize.sm,
              fullWidth: years.length <= 3,
              onTabChange: (id) => onYearChanged(int.parse(id)),
            ),
            const SizedBox(height: 10),
            CustomTabWidget(
              tabs: semesterTabs,
              activeTab: '$selectedSemester',
              tabStyle: TabStyle.pill,
              variant: TabVariant.primary,
              size: TabSize.sm,
              fullWidth: true,
              onTabChange: (id) => onSemesterChanged(int.parse(id)),
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < visibleCourses.length; i++) ...[
              AcademicExamCourseTile(
                course: visibleCourses[i],
                provisionalGrade: provisionalGrades[visibleCourses[i].id],
                onProvisionalGradeChanged: onProvisionalGradeChanged,
              ),
              if (i != visibleCourses.length - 1) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── AcademicExamAppealsPanel ─────────────────────────────────────────────────

class AcademicExamAppealsPanel extends StatefulWidget {
  const AcademicExamAppealsPanel({
    super.key,
    required this.months,
    required this.selectedMonth,
    required this.selectedStatus,
    required this.appeals,
    required this.onMonthChanged,
    required this.onStatusChanged,
    this.onBookingConfirmed,
  });

  static const blueSurface = Color(0xFFEEFDFF);

  final List<AcademicExamAppealMonthData> months;
  final AcademicExamAppealMonthData? selectedMonth;
  final int selectedStatus;
  final List<AcademicExamAppealData> appeals;
  final ValueChanged<AcademicExamAppealMonthData> onMonthChanged;
  final ValueChanged<int> onStatusChanged;

  /// Called when the user confirms the booking of an appeal.
  final ValueChanged<AcademicExamAppealData>? onBookingConfirmed;

  @override
  State<AcademicExamAppealsPanel> createState() =>
      _AcademicExamAppealsPanelState();
}

class _AcademicExamAppealsPanelState extends State<AcademicExamAppealsPanel> {
  static const _pageSize = 3;
  int _currentPage = 1;
  int _slideDirection = 1;

  @override
  void didUpdateWidget(AcademicExamAppealsPanel old) {
    super.didUpdateWidget(old);
    if (old.selectedMonth?.id != widget.selectedMonth?.id ||
        old.selectedStatus != widget.selectedStatus) {
      setState(() {
        _currentPage = 1;
        _slideDirection = 1;
      });
    }
  }

  List<AcademicExamAppealData> _filteredAppeals(
      AcademicExamAppealMonthData selectedMonth,
      ) {
    final showBooked = widget.selectedStatus == 0;
    return widget.appeals
        .where(
          (a) =>
      a.month == selectedMonth.month &&
          a.date.year == selectedMonth.year &&
          a.isBooked == showBooked,
    )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  void _goToPage(int page, {required int direction}) {
    setState(() {
      _slideDirection = direction;
      _currentPage = page;
    });
  }

  String _monthLabel(int month) => switch (month) {
    1 => 'Gennaio',
    2 => 'Febbraio',
    6 => 'Giugno',
    7 => 'Luglio',
    9 => 'Settembre',
    10 => 'Ottobre',
    _ => 'Mese $month',
  };

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedMonth =
        widget.selectedMonth ??
            (widget.months.isNotEmpty ? widget.months.first : null);

    final allAppeals = effectiveSelectedMonth == null
        ? <AcademicExamAppealData>[]
        : _filteredAppeals(effectiveSelectedMonth);

    final totalItems = allAppeals.length;
    final totalPages = (totalItems / _pageSize).ceil().clamp(1, 999);

    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, totalItems);
    final pageAppeals = totalItems == 0
        ? <AcademicExamAppealData>[]
        : allAppeals.sublist(startIndex, endIndex);

    final showPagination = totalItems > _pageSize;

    final monthTabs = widget.months
        .map((m) => TabItem(id: m.id, label: _monthLabel(m.month)))
        .toList();

    const statusTabs = [
      TabItem(id: '0', label: 'Appelli prenotati'),
      TabItem(id: '1', label: 'Appelli in apertura'),
    ];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: showPagination
          ? (details) {
        const threshold = 80.0;
        final vx = details.primaryVelocity ?? 0;
        if (vx < -threshold && _currentPage < totalPages) {
          _goToPage(_currentPage + 1, direction: 1);
        } else if (vx > threshold && _currentPage > 1) {
          _goToPage(_currentPage - 1, direction: -1);
        }
      }
          : null,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
          decoration: BoxDecoration(
            color: AcademicExamAppealsPanel.blueSurface,
            borderRadius: BorderRadius.circular(19),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (monthTabs.isNotEmpty)
                CustomTabWidget(
                  tabs: monthTabs,
                  activeTab: effectiveSelectedMonth?.id ?? '',
                  tabStyle: TabStyle.pill,
                  variant: TabVariant.primary,
                  size: TabSize.sm,
                  fullWidth: widget.months.length <= 3,
                  onTabChange: (id) {
                    final month =
                    widget.months.firstWhere((m) => m.id == id);
                    widget.onMonthChanged(month);
                  },
                ),
              const SizedBox(height: 10),
              CustomTabWidget(
                tabs: statusTabs,
                activeTab: '${widget.selectedStatus}',
                tabStyle: TabStyle.pill,
                variant: TabVariant.primary,
                size: TabSize.sm,
                fullWidth: true,
                onTabChange: (id) => widget.onStatusChanged(int.parse(id)),
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final isIncoming = child.key == ValueKey(_currentPage);
                  final beginOffset = isIncoming
                      ? Offset(_slideDirection.toDouble(), 0)
                      : Offset(-_slideDirection.toDouble(), 0);
                  return ClipRect(
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: beginOffset,
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },
                child: _AppealPageContent(
                  key: ValueKey(_currentPage),
                  pageAppeals: pageAppeals,
                  onBookAppeal: widget.onBookingConfirmed != null
                      ? (appeal) => _showBookingModal(context, appeal)
                      : null,
                ),
              ),
              if (showPagination) ...[
                const SizedBox(height: 14),
                CustomPaginationWidget(
                  totalItems: totalItems,
                  pageSize: _pageSize,
                  currentPage: _currentPage,
                  style: PaginationStyle.dots,
                  variant: PaginationVariant.primary,
                  size: PaginationSize.sm,
                  showPageSizeSelector: false,
                  showInfo: false,
                  showFirstLast: false,
                  showJumpToPage: false,
                  onPageChange: (page) => _goToPage(
                    page,
                    direction: page > _currentPage ? 1 : -1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Booking modal ────────────────────────────────────────────────────────────

  void _showBookingModal(BuildContext context, AcademicExamAppealData appeal) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (dialogContext) => UncontrolledProviderScope(
        container: ProviderScope.containerOf(context),
        child: _BookingConfirmModal(
          appeal: appeal,
          onConfirm: () {
            Navigator.of(dialogContext, rootNavigator: true).pop();
            widget.onBookingConfirmed?.call(appeal);
          },
          onDismiss: () =>
              Navigator.of(dialogContext, rootNavigator: true).pop(),
        ),
      ),
    );
  }
}

// ─── Booking confirm modal ────────────────────────────────────────────────────

class _BookingConfirmModal extends ConsumerWidget {
  const _BookingConfirmModal({
    required this.appeal,
    required this.onConfirm,
    required this.onDismiss,
  });

  final AcademicExamAppealData appeal;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              text: 'Prenota esame',
              variant: TextVariant.h5,
            ),
            const SizedBox(height: 4),
            CustomTextWidget(
              text: appeal.examName,
              variant: TextVariant.bodySm,
              color: TextColor.muted,
            ),
            const SizedBox(height: 20),
            CustomTextWidget(
              text: 'Vuoi prenotarti per questo esame?',
              variant: TextVariant.body,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButtonWidget(
                  label: 'Annulla',
                  variant: ButtonVariant.ghost,
                  onPressed: () {
                    onDismiss();
                    ref.read(toastServiceProvider.notifier).warning(
                      'Prenotazione annullata',
                      options: const ToastOptions(
                        title: 'Nessuna prenotazione',
                        position: ToastPosition.topCenter,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                CustomButtonWidget(
                  label: 'Prenota',
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    onConfirm();
                    ref.read(toastServiceProvider.notifier).success(
                      '${appeal.examName} prenotato con successo',
                      options: const ToastOptions(
                        title: 'Prenotazione confermata',
                        position: ToastPosition.topCenter,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Appeal page content ──────────────────────────────────────────────────────

class _AppealPageContent extends StatelessWidget {
  const _AppealPageContent({
    super.key,
    required this.pageAppeals,
    this.onBookAppeal,
  });

  final List<AcademicExamAppealData> pageAppeals;
  final ValueChanged<AcademicExamAppealData>? onBookAppeal;

  @override
  Widget build(BuildContext context) {
    if (pageAppeals.isEmpty) return const _EmptyAppealsTile();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < pageAppeals.length; i++) ...[
          AcademicExamAppealTile(
            appeal: pageAppeals[i],
            onBook: onBookAppeal != null
                ? () => onBookAppeal!(pageAppeals[i])
                : null,
          ),
          if (i != pageAppeals.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

// ─── Tile widgets ─────────────────────────────────────────────────────────────

class AcademicExamCourseTile extends StatelessWidget {
  const AcademicExamCourseTile({
    super.key,
    required this.course,
    required this.provisionalGrade,
    required this.onProvisionalGradeChanged,
  });

  final AcademicExamCourseData course;
  final int? provisionalGrade;
  final void Function(String courseId, int grade) onProvisionalGradeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.fromLTRB(12, 8, 7, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.045),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        course.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                    if (course.passed) ...[
                      const SizedBox(width: 5),
                      const Icon(
                        LucideIcons.checkCircle,
                        size: 18,
                        color: AppColors.examPassed,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  course.code,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          // ── CFU badge → CustomBadgeWidget ──
          CustomBadgeWidget(
            label: '${course.credits} CFU',
            variant: BadgeVariant.neutral,
            size: BadgeSize.sm,
          ),
          const SizedBox(width: 8),
          _ExamGradeBox(
            course: course,
            provisionalGrade: provisionalGrade,
            onChanged: (grade) => onProvisionalGradeChanged(course.id, grade),
          ),
        ],
      ),
    );
  }
}

class AcademicExamAppealTile extends StatelessWidget {
  const AcademicExamAppealTile({
    super.key,
    required this.appeal,
    this.onBook,
  });

  final AcademicExamAppealData appeal;

  /// Callback triggered when the user taps "Prenotabile".
  /// Null means no booking action is wired up.
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final isCompact = availableWidth < 340;
        final iconSize = isCompact ? 38.0 : 42.0;
        final gap = isCompact ? 7.0 : 9.0;
        const trailingWidth = 46.0;
        final isDisabled = !appeal.isBooked && !appeal.isBookable;

        return Container(
          constraints: const BoxConstraints(minHeight: 76),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 9 : 11,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: isDisabled
                ? const Color(0xFFE8EAED)
                : AppColors.background.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isDisabled
                  ? AppColors.textPrimary.withValues(alpha: 0.12)
                  : AppColors.textPrimary.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? AppColors.textPrimary.withValues(alpha: 0.10)
                      : const Color(0xFFBFDCEB),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  LucideIcons.calendarDays,
                  color: isDisabled
                      ? AppColors.textPrimary.withValues(alpha: 0.46)
                      : const Color(0xFF5B93AE),
                  size: 20,
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appeal.examName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _appealDetails(appeal),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.74),
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    // ── Booking button → CustomButtonWidget ──
                    if (!appeal.isBooked) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButtonWidget(
                            label: appeal.isBookable ? 'Prenotabile' : 'Non prenotabile',
                            variant: appeal.isBookable
                                ? ButtonVariant.primary
                                : ButtonVariant.ghost,
                            size: ButtonSize.sm,
                            disabled: !appeal.isBookable,
                            onPressed: appeal.isBookable ? onBook : null,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: gap),
              SizedBox(
                width: trailingWidth,
                child: _AppealTrailingInfo(appeal: appeal),
              ),
            ],
          ),
        );
      },
    );
  }

  String _appealDetails(AcademicExamAppealData appeal) {
    final day = appeal.date.day.toString().padLeft(2, '0');
    final month = appeal.date.month.toString().padLeft(2, '0');
    final room = appeal.room == null ? '' : ' - ${appeal.room}';
    return '$day/$month$room';
  }
}

// ─── Private widgets ──────────────────────────────────────────────────────────

class _ExamGradeBox extends StatelessWidget {
  const _ExamGradeBox({
    required this.course,
    required this.provisionalGrade,
    required this.onChanged,
  });

  final AcademicExamCourseData course;
  final int? provisionalGrade;
  final ValueChanged<int> onChanged;

  static final _availableGrades = List<int>.generate(31, (i) => 30 - i);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = course.passed
        ? course.grade ?? '-'
        : '${provisionalGrade ?? _parseGrade(course.grade) ?? '--'}';

    if (course.passed) {
      return _GradeSurface(
        label: label,
        textColor: AppColors.textPrimary.withValues(alpha: 0.82),
        backgroundColor: AppColors.textPrimary.withValues(alpha: 0.08),
        borderColor: Colors.transparent,
      );
    }

    return PopupMenuButton<int>(
      tooltip: 'Aggiungi voto provvisorio',
      initialValue: provisionalGrade ?? _parseGrade(course.grade),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      constraints: const BoxConstraints(maxHeight: 260, minWidth: 54),
      onSelected: onChanged,
      itemBuilder: (_) => [
        for (final grade in _availableGrades)
          PopupMenuItem<int>(
            value: grade,
            height: 36,
            child: Center(
              child: Text(
                '$grade',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
      child: _GradeSurface(
        label: label,
        textColor: AppColors.textPrimary,
        backgroundColor: const Color(0xFFF7F7F3),
        borderColor: AppColors.cta.withValues(alpha: 0.13),
        showChevron: true,
      ),
    );
  }

  int? _parseGrade(String? grade) {
    if (grade == null) return null;
    return int.tryParse(grade.replaceAll('L', ''));
  }
}

class _GradeSurface extends StatelessWidget {
  const _GradeSurface({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    this.showChevron = false,
  });

  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: 43,
      height: 47,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          if (showChevron)
            Icon(
              LucideIcons.chevronDown,
              size: 12,
              color: textColor.withValues(alpha: 0.72),
            ),
        ],
      ),
    );
  }
}

class _AppealTrailingInfo extends StatelessWidget {
  const _AppealTrailingInfo({required this.appeal});

  final AcademicExamAppealData appeal;

  @override
  Widget build(BuildContext context) {
    // ── orario appello → CustomTextWidget ──
    return CustomTextWidget(
      text: appeal.time,
      variant: TextVariant.label,
      weight: TextWeight.extraBold,
      align: TextAlign.right,
    );
  }
}

class _EmptyAppealsTile extends StatelessWidget {
  const _EmptyAppealsTile();

  @override
  Widget build(BuildContext context) {
    // ── testo vuoto → CustomTextWidget ──
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(13),
      ),
      child: CardStatusWidget(
        statusVariant: StatusVariant.neutral,
        icon: LucideIcons.calendarOff,
        title: 'Nessun appello disponibile',
        shadow: CardShadow.none,
        bordered: false,
      )
    );
  }
}