import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_tab/custom_tab_widget.dart';
import '../../domain/entities/didattica_course_type.dart';
import '../../domain/entities/didattica_exam_course_entity.dart';
import '../providers/exam_courses_provider.dart';

enum StudyPlanFilter { all, passed, pending, elective }

class StudyPlanPage extends ConsumerStatefulWidget {
  const StudyPlanPage({super.key});

  @override
  ConsumerState<StudyPlanPage> createState() => _StudyPlanPageState();
}

class _StudyPlanPageState extends ConsumerState<StudyPlanPage> {
  StudyPlanFilter _activeFilter = StudyPlanFilter.all;

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(didatticaExamCoursesProvider);
    final filteredCourses = _filterCourses(courses, _activeFilter);
    final years = filteredCourses.map((course) => course.year).toSet().toList()
      ..sort();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Piano di studio')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
        physics: const BouncingScrollPhysics(),
        children: [
          _StudyPlanFilterBar(
            activeFilter: _activeFilter,
            onFilterChanged: (filter) {
              setState(() => _activeFilter = filter);
            },
          ),
          const SizedBox(height: 18),
          if (filteredCourses.isEmpty)
            _StudyPlanEmptyState(filter: _activeFilter)
          else
            for (var index = 0; index < years.length; index++) ...[
              _StudyYearSection(
                year: years[index],
                courses: _coursesForYear(filteredCourses, years[index]),
              ),
              if (index != years.length - 1) const SizedBox(height: 18),
            ],
        ],
      ),
    );
  }

  List<DidatticaExamCourseEntity> _filterCourses(
    List<DidatticaExamCourseEntity> courses,
    StudyPlanFilter filter,
  ) {
    return switch (filter) {
      StudyPlanFilter.all => [...courses],
      StudyPlanFilter.passed =>
        courses.where((course) => course.passed).toList(),
      StudyPlanFilter.pending =>
        courses.where((course) => !course.passed).toList(),
      StudyPlanFilter.elective =>
        courses
            .where(
              (course) => course.courseType == DidatticaCourseType.elective,
            )
            .toList(),
    };
  }

  List<DidatticaExamCourseEntity> _coursesForYear(
    List<DidatticaExamCourseEntity> courses,
    int year,
  ) {
    return courses.where((course) => course.year == year).toList()
      ..sort((a, b) {
        final semesterCompare = a.semester.compareTo(b.semester);
        if (semesterCompare != 0) return semesterCompare;

        return a.name.compareTo(b.name);
      });
  }
}

class _StudyPlanFilterBar extends StatelessWidget {
  const _StudyPlanFilterBar({
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final StudyPlanFilter activeFilter;
  final ValueChanged<StudyPlanFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomTabWidget(
        tabs: StudyPlanFilter.values
            .map((filter) => TabItem(id: filter.name, label: filter.label))
            .toList(growable: false),
        activeTab: activeFilter.name,
        tabStyle: TabStyle.pill,
        variant: TabVariant.primary,
        size: TabSize.sm,
        onTabChange: (id) => onFilterChanged(StudyPlanFilter.values.byName(id)),
      ),
    );
  }
}

class _StudyPlanEmptyState extends StatelessWidget {
  const _StudyPlanEmptyState({required this.filter});

  final StudyPlanFilter filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.search,
            size: 30,
            color: AppColors.textPrimary.withValues(alpha: 0.42),
          ),
          const SizedBox(height: 10),
          Text(
            'Nessun esame trovato',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Non ci sono esami per il filtro ${filter.label.toLowerCase()}.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.58),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudyYearSection extends StatelessWidget {
  const _StudyYearSection({required this.year, required this.courses});

  final int year;
  final List<DidatticaExamCourseEntity> courses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: _yearColor(year),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 10),
            child: Text(
              'Anno $year',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          for (var index = 0; index < courses.length; index++) ...[
            _StudyCourseTile(course: courses[index]),
            if (index != courses.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Color _yearColor(int year) {
    return switch (year) {
      1 => const Color(0xFFEEFDFF),
      2 => const Color(0xFFEFFFEE),
      _ => const Color(0xFFFFFCE6),
    };
  }
}

class _StudyCourseTile extends StatelessWidget {
  const _StudyCourseTile({required this.course});

  final DidatticaExamCourseEntity course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.08),
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
                  '${course.code} - Semestre ${course.semester}',
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
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${course.credits} CFU',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                course.courseType.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: course.courseType == DidatticaCourseType.elective
                      ? AppColors.colorPrimaryDark
                      : AppColors.textPrimary.withValues(alpha: 0.46),
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension StudyPlanFilterLabel on StudyPlanFilter {
  String get label {
    return switch (this) {
      StudyPlanFilter.all => 'Tutti',
      StudyPlanFilter.passed => 'Superati',
      StudyPlanFilter.pending => 'Da sostenere',
      StudyPlanFilter.elective => 'A scelta',
    };
  }
}

extension DidatticaCourseTypeLabel on DidatticaCourseType {
  String get label {
    return switch (this) {
      DidatticaCourseType.mandatory => 'Obbligatorio',
      DidatticaCourseType.elective => 'A scelta',
    };
  }
}
