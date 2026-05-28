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
              _ExamCourseTile(course: visibleCourses[index]),
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
  const _ExamCourseTile({required this.course});

  final DidatticaExamCourseEntity course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.18),
        ),
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
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${course.credits}',
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
          const SizedBox(width: 12),
          SizedBox(
            width: 30,
            child: Text(
              course.grade ?? '',
              textAlign: TextAlign.right,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
