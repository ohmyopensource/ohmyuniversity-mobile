import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../shared/widgets/custom_input/custom_input_widget.dart';
import '../../../../shared/widgets/custom_tab/custom_tab_widget.dart';
import '../../domain/entities/didattica_exam_course_entity.dart';
import '../providers/career_provider.dart';
import 'career_exam_card.dart';

class CareerStudyPlanSection extends ConsumerWidget {
  const CareerStudyPlanSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(careerProvider);
    final groups = _groupCourses(state.visibleCourses);

    return CustomCardWidget(
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Piano di studi',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.colorNeutral900,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _StudyPlanFilters(
            state: state,
            controller: ref.read(careerProvider.notifier),
          ),
          const SizedBox(height: 20),
          if (groups.isEmpty)
            const _EmptyStudyPlan()
          else
            for (var index = 0; index < groups.length; index++) ...[
              _CourseYearGroup(
                group: groups[index],
                simulatedGrades: state.simulatedGrades,
              ),
              if (index != groups.length - 1) const SizedBox(height: 24),
            ],
        ],
      ),
    );
  }

  List<_CourseGroup> _groupCourses(List<DidatticaExamCourseEntity> courses) {
    final byYearAndSemester =
        <int, Map<int, List<DidatticaExamCourseEntity>>>{};
    for (final course in courses) {
      final bySemester = byYearAndSemester[course.year] ??= {};
      (bySemester[course.semester] ??= []).add(course);
    }

    final years = byYearAndSemester.keys.toList()..sort();
    return [
      for (final year in years)
        _CourseGroup(
          year: year,
          semesters: _semesterGroups(byYearAndSemester[year]!),
        ),
    ];
  }

  List<_SemesterGroup> _semesterGroups(
    Map<int, List<DidatticaExamCourseEntity>> bySemester,
  ) {
    final semesters = bySemester.keys.toList()..sort();
    return [
      for (final semester in semesters)
        _SemesterGroup(
          semester: semester,
          courses: bySemester[semester]!
            ..sort((first, second) => first.name.compareTo(second.name)),
        ),
    ];
  }
}

class _StudyPlanFilters extends StatelessWidget {
  const _StudyPlanFilters({required this.state, required this.controller});

  final CareerState state;
  final CareerController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final yearSelect = CustomInputWidget(
          key: ValueKey('career-year-${state.yearFilter}'),
          type: InputType.select,
          size: InputSize.sm,
          initialValue: state.yearFilter,
          options: [
            const SelectOption(label: 'Tutti gli anni', value: 'all'),
            for (final year in state.availableYears)
              SelectOption(label: _yearLabel(year), value: '$year'),
            const SelectOption(label: 'A scelta', value: 'elective'),
          ],
          onChanged: controller.setYearFilter,
        );
        final tabs = CustomTabWidget(
          tabs: [
            for (final filter in CareerExamFilter.values)
              TabItem(id: filter.name, label: filter.label),
          ],
          activeTab: state.examFilter.name,
          tabStyle: TabStyle.pill,
          variant: TabVariant.primary,
          size: TabSize.sm,
          onTabChange: (id) {
            controller.setExamFilter(CareerExamFilter.values.byName(id));
          },
        );

        if (constraints.maxWidth < 560) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [yearSelect, const SizedBox(height: 10), tabs],
          );
        }
        return Row(
          children: [
            SizedBox(width: 190, child: yearSelect),
            const SizedBox(width: 12),
            Expanded(
              child: Align(alignment: Alignment.centerRight, child: tabs),
            ),
          ],
        );
      },
    );
  }

  static String _yearLabel(int year) {
    return switch (year) {
      1 => 'Primo anno',
      2 => 'Secondo anno',
      3 => 'Terzo anno',
      _ => 'Anno $year',
    };
  }
}

class _CourseYearGroup extends StatelessWidget {
  const _CourseYearGroup({required this.group, required this.simulatedGrades});

  final _CourseGroup group;
  final Map<String, String> simulatedGrades;

  @override
  Widget build(BuildContext context) {
    final courses = group.semesters.expand((semester) => semester.courses);
    final allCourses = courses.toList(growable: false);
    final passedCount = allCourses.where((course) => course.passed).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _StudyPlanFilters._yearLabel(group.year).toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.colorNeutral400,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.9,
                ),
              ),
            ),
            Text(
              '$passedCount/${allCourses.length} superati',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.colorNeutral400,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < group.semesters.length; index++) ...[
          _SemesterSection(
            group: group.semesters[index],
            simulatedGrades: simulatedGrades,
          ),
          if (index != group.semesters.length - 1) const SizedBox(height: 18),
        ],
      ],
    );
  }
}

class _SemesterSection extends StatelessWidget {
  const _SemesterSection({required this.group, required this.simulatedGrades});

  final _SemesterGroup group;
  final Map<String, String> simulatedGrades;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (group.semester > 0) ...[
          Text(
            group.semester == 1 ? 'Primo semestre' : 'Secondo semestre',
            key: Key('semester-heading-${group.semester}'),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.colorNeutral500,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
        ],
        for (var index = 0; index < group.courses.length; index++) ...[
          CareerExamCard(
            course: group.courses[index],
            simulatedGrade: simulatedGrades[group.courses[index].id],
          ),
          if (index != group.courses.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _EmptyStudyPlan extends StatelessWidget {
  const _EmptyStudyPlan();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Column(
          children: [
            const Icon(
              LucideIcons.searchX,
              size: 30,
              color: AppColors.colorNeutral400,
            ),
            const SizedBox(height: 8),
            Text(
              'Nessun esame trovato',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.colorNeutral500,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseGroup {
  const _CourseGroup({required this.year, required this.semesters});

  final int year;
  final List<_SemesterGroup> semesters;
}

class _SemesterGroup {
  const _SemesterGroup({required this.semester, required this.courses});

  final int semester;
  final List<DidatticaExamCourseEntity> courses;
}
