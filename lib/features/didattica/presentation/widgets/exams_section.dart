import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/didattica_exam_course_entity.dart';
import '../providers/exam_courses_provider.dart';

class ExamsSection extends ConsumerStatefulWidget {
  const ExamsSection({super.key});

  @override
  ConsumerState<ExamsSection> createState() => _ExamsSectionState();
}

class _ExamsSectionState extends ConsumerState<ExamsSection>
    with TickerProviderStateMixin {
  int _selectedYear = 1;
  int _selectedSemester = 0;
  final Map<String, int> _provisionalGrades = {};

  List<int> _availableYears(List<DidatticaExamCourseEntity> courses) {
    final years = courses.map((course) => course.year).toSet().toList()..sort();

    return years;
  }

  List<DidatticaExamCourseEntity> _visibleCourses(
    List<DidatticaExamCourseEntity> courses,
    int selectedYear,
  ) {
    return courses
        .where(
          (course) =>
              course.year == selectedYear &&
              course.semester == _selectedSemester + 1,
        )
        .toList();
  }

  void _changeYear(int year) {
    if (year == _selectedYear) return;

    setState(() {
      _selectedYear = year;
      _selectedSemester = 0;
    });
  }

  void _changeSemester(int semester) {
    if (semester == _selectedSemester) return;

    setState(() => _selectedSemester = semester);
  }

  void _changeProvisionalGrade(String courseId, int grade) {
    setState(() => _provisionalGrades[courseId] = grade);
  }

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(didatticaExamCoursesProvider);
    final years = _availableYears(courses);
    final selectedYear = years.contains(_selectedYear)
        ? _selectedYear
        : years.isNotEmpty
        ? years.first
        : _selectedYear;
    final visibleCourses = _visibleCourses(courses, selectedYear);

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
            _YearTabs(
              years: years,
              selectedYear: selectedYear,
              onChanged: _changeYear,
            ),
            const SizedBox(height: 10),
            _SemesterControl(
              selectedSemester: _selectedSemester,
              onChanged: _changeSemester,
            ),
            const SizedBox(height: 10),
            for (var index = 0; index < visibleCourses.length; index++) ...[
              _ExamCourseTile(
                course: visibleCourses[index],
                provisionalGrade: _provisionalGrades[visibleCourses[index].id],
                onProvisionalGradeChanged: _changeProvisionalGrade,
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

class _YearTabs extends StatelessWidget {
  const _YearTabs({
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
                  child: _YearTab(
                    label: 'Anno ${years[index]}',
                    isSelected: selectedYear == years[index],
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

class _YearTab extends StatelessWidget {
  const _YearTab({
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      height: 52,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFBFDCEB).withValues(alpha: 0.92)
            : AppColors.background.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(15),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF5B93AE).withValues(alpha: 0.18),
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
                    : AppColors.textPrimary.withValues(alpha: 0.56),
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

class _SemesterControl extends StatelessWidget {
  const _SemesterControl({
    required this.selectedSemester,
    required this.onChanged,
  });

  final int selectedSemester;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.34)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final indicatorWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                left: selectedSemester == 0 ? 0 : indicatorWidth,
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
                  Expanded(
                    child: _SemesterTab(
                      label: 'Primo semestre',
                      isSelected: selectedSemester == 0,
                      onTap: () => onChanged(0),
                    ),
                  ),
                  Expanded(
                    child: _SemesterTab(
                      label: 'Secondo semestre',
                      isSelected: selectedSemester == 1,
                      onTap: () => onChanged(1),
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

class _SemesterTab extends StatelessWidget {
  const _SemesterTab({
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

class _ExamCourseTile extends StatelessWidget {
  const _ExamCourseTile({
    required this.course,
    required this.provisionalGrade,
    required this.onProvisionalGradeChanged,
  });

  final DidatticaExamCourseEntity course;
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

  final DidatticaExamCourseEntity course;
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
