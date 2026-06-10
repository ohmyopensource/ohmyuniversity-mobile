import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';

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
          (course) =>
              course.year == selectedYear &&
              course.semester == selectedSemester + 1,
        )
        .toList();

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
            AcademicYearTabs(
              years: years,
              selectedYear: selectedYear,
              onChanged: onYearChanged,
            ),
            const SizedBox(height: 10),
            AcademicSegmentedControl(
              selectedIndex: selectedSemester,
              labels: const ['Primo semestre', 'Secondo semestre'],
              height: 46,
              onChanged: onSemesterChanged,
            ),
            const SizedBox(height: 10),
            for (var index = 0; index < visibleCourses.length; index++) ...[
              AcademicExamCourseTile(
                course: visibleCourses[index],
                provisionalGrade: provisionalGrades[visibleCourses[index].id],
                onProvisionalGradeChanged: onProvisionalGradeChanged,
              ),
              if (index != visibleCourses.length - 1)
                const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class AcademicExamAppealsPanel extends StatelessWidget {
  const AcademicExamAppealsPanel({
    super.key,
    required this.months,
    required this.selectedMonth,
    required this.selectedStatus,
    required this.appeals,
    required this.onMonthChanged,
    required this.onStatusChanged,
  });

  static const blueSurface = Color(0xFFEEFDFF);
  static const blueActive = Color(0xFFBFDCEB);

  final List<AcademicExamAppealMonthData> months;
  final AcademicExamAppealMonthData? selectedMonth;
  final int selectedStatus;
  final List<AcademicExamAppealData> appeals;
  final ValueChanged<AcademicExamAppealMonthData> onMonthChanged;
  final ValueChanged<int> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedMonth =
        selectedMonth ?? (months.isNotEmpty ? months.first : null);
    final visibleAppeals = effectiveSelectedMonth == null
        ? <AcademicExamAppealData>[]
        : _visibleAppeals(appeals, effectiveSelectedMonth);

    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
        decoration: BoxDecoration(
          color: blueSurface,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AcademicAppealsMonthTabs(
              months: months,
              selectedMonth: effectiveSelectedMonth,
              activeColor: blueActive,
              inactiveColor: AppColors.background.withValues(alpha: 0.58),
              onChanged: onMonthChanged,
            ),
            const SizedBox(height: 10),
            AcademicSegmentedControl(
              selectedIndex: selectedStatus,
              labels: const ['Appelli prenotati', 'Appelli in apertura'],
              height: 48,
              onChanged: onStatusChanged,
            ),
            const SizedBox(height: 10),
            if (visibleAppeals.isEmpty)
              const _EmptyAppealsTile()
            else
              for (var index = 0; index < visibleAppeals.length; index++) ...[
                AcademicExamAppealTile(appeal: visibleAppeals[index]),
                if (index != visibleAppeals.length - 1)
                  const SizedBox(height: 10),
              ],
          ],
        ),
      ),
    );
  }

  List<AcademicExamAppealData> _visibleAppeals(
    List<AcademicExamAppealData> appeals,
    AcademicExamAppealMonthData selectedMonth,
  ) {
    final showBooked = selectedStatus == 0;

    return appeals
        .where(
          (appeal) =>
              appeal.month == selectedMonth.month &&
              appeal.date.year == selectedMonth.year &&
              appeal.isBooked == showBooked,
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}

class AcademicYearTabs extends StatelessWidget {
  const AcademicYearTabs({
    super.key,
    required this.years,
    required this.selectedYear,
    required this.onChanged,
  });

  final List<int> years;
  final int selectedYear;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    if (years.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final compactWidth =
            (constraints.maxWidth - (gap * (years.length - 1))) / years.length;
        final itemWidth = years.length <= 3 ? compactWidth : 92.0;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (var index = 0; index < years.length; index++) ...[
                SizedBox(
                  width: itemWidth,
                  child: _LargeTab(
                    label: 'Anno ${years[index]}',
                    isSelected: selectedYear == years[index],
                    activeColor: const Color(
                      0xFFBFDCEB,
                    ).withValues(alpha: 0.92),
                    inactiveColor: AppColors.background.withValues(alpha: 0.58),
                    shadowColor: const Color(0xFF5B93AE),
                    onTap: () => onChanged(years[index]),
                  ),
                ),
                if (index != years.length - 1) const SizedBox(width: gap),
              ],
            ],
          ),
        );
      },
    );
  }
}

class AcademicAppealsMonthTabs extends StatelessWidget {
  const AcademicAppealsMonthTabs({
    super.key,
    required this.months,
    required this.selectedMonth,
    required this.activeColor,
    required this.inactiveColor,
    required this.onChanged,
  });

  final List<AcademicExamAppealMonthData> months;
  final AcademicExamAppealMonthData? selectedMonth;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<AcademicExamAppealMonthData> onChanged;

  @override
  Widget build(BuildContext context) {
    if (months.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var index = 0; index < months.length; index++) ...[
            SizedBox(
              width: 96,
              child: _LargeTab(
                label: _monthLabel(months[index].month),
                isSelected: selectedMonth?.id == months[index].id,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                shadowColor: activeColor,
                onTap: () => onChanged(months[index]),
              ),
            ),
            if (index != months.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  String _monthLabel(int month) {
    return switch (month) {
      1 => 'Gennaio',
      2 => 'Febbraio',
      6 => 'Giugno',
      7 => 'Luglio',
      9 => 'Settembre',
      10 => 'Ottobre',
      _ => 'Mese $month',
    };
  }
}

class AcademicSegmentedControl extends StatelessWidget {
  const AcademicSegmentedControl({
    super.key,
    required this.selectedIndex,
    required this.labels,
    required this.onChanged,
    this.height = 46,
  });

  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.34)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final indicatorWidth = constraints.maxWidth / labels.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                left: selectedIndex * indicatorWidth,
                top: 0,
                bottom: 0,
                width: indicatorWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.86),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.32),
                        blurRadius: 12,
                        offset: const Offset(-2, -2),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  for (var index = 0; index < labels.length; index++)
                    Expanded(
                      child: _SegmentedTab(
                        label: labels[index],
                        isSelected: selectedIndex == index,
                        onTap: () => onChanged(index),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

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
          _CreditsBadge(credits: course.credits),
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
  const AcademicExamAppealTile({super.key, required this.appeal});

  final AcademicExamAppealData appeal;

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
        final isDisabledAppeal = !appeal.isBooked && !appeal.isBookable;

        return Container(
          constraints: const BoxConstraints(minHeight: 76),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 9 : 11,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: isDisabledAppeal
                ? const Color(0xFFE8EAED)
                : AppColors.background.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isDisabledAppeal
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
                  color: isDisabledAppeal
                      ? AppColors.textPrimary.withValues(alpha: 0.10)
                      : const Color(0xFFBFDCEB),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  LucideIcons.calendarDays,
                  color: isDisabledAppeal
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
                    if (!appeal.isBooked) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _AppealBookingStateButton(
                          isBookable: appeal.isBookable,
                          onTap: () {},
                        ),
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

class _LargeTab extends StatelessWidget {
  const _LargeTab({
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.shadowColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final Color shadowColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      height: 52,
      decoration: BoxDecoration(
        color: isSelected ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: shadowColor.withValues(alpha: 0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textPrimary.withValues(alpha: 0.58),
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentedTab extends StatelessWidget {
  const _SegmentedTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            style: theme.textTheme.labelMedium!.copyWith(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textPrimary.withValues(alpha: 0.62),
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              letterSpacing: 0,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

class _CreditsBadge extends StatelessWidget {
  const _CreditsBadge({required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 34,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$credits',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 0.95,
            ),
          ),
          Text(
            'CFU',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamGradeBox extends StatelessWidget {
  const _ExamGradeBox({
    required this.course,
    required this.provisionalGrade,
    required this.onChanged,
  });

  final AcademicExamCourseData course;
  final int? provisionalGrade;
  final ValueChanged<int> onChanged;

  static final _availableGrades = List<int>.generate(31, (index) => 30 - index);

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
      itemBuilder: (context) => [
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
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          appeal.time,
          textAlign: TextAlign.right,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _AppealBookingStateButton extends StatefulWidget {
  const _AppealBookingStateButton({required this.isBookable, this.onTap});

  final bool isBookable;
  final VoidCallback? onTap;

  @override
  State<_AppealBookingStateButton> createState() =>
      _AppealBookingStateButtonState();
}

class _AppealBookingStateButtonState extends State<_AppealBookingStateButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (!widget.isBookable || _isPressed == value) return;

    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.isBookable;
    final backgroundColor = isEnabled
        ? _isPressed
              ? const Color(0xFF2F7FD6)
              : AppColors.labelBlue
        : AppColors.textPrimary.withValues(alpha: 0.12);

    return AnimatedScale(
      scale: isEnabled && _isPressed ? 0.94 : 1,
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? widget.onTap : null,
          onTapDown: isEnabled ? (_) => _setPressed(true) : null,
          onTapUp: isEnabled ? (_) => _setPressed(false) : null,
          onTapCancel: isEnabled ? () => _setPressed(false) : null,
          borderRadius: BorderRadius.circular(999),
          splashColor: Colors.white.withValues(alpha: 0.22),
          highlightColor: Colors.white.withValues(alpha: 0.10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(999),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: _isPressed ? 0.10 : 0.20,
                        ),
                        blurRadius: _isPressed ? 3 : 6,
                        offset: Offset(0, _isPressed ? 1 : 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                isEnabled ? 'Prenotabile' : 'Non prenotabile',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isEnabled
                      ? Colors.white
                      : AppColors.textPrimary.withValues(alpha: 0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyAppealsTile extends StatelessWidget {
  const _EmptyAppealsTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        'Nessun appello disponibile',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary.withValues(alpha: 0.68),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
