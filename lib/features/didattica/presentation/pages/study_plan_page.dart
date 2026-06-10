import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/didattica_exam_course_entity.dart';
import '../providers/exam_courses_provider.dart';

class StudyPlanPage extends ConsumerWidget {
  const StudyPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(didatticaExamCoursesProvider);
    final years = courses.map((course) => course.year).toSet().toList()..sort();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Piano di studio')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final year = years[index];
          final yearCourses =
              courses.where((course) => course.year == year).toList()
                ..sort((a, b) {
                  final semesterCompare = a.semester.compareTo(b.semester);
                  if (semesterCompare != 0) return semesterCompare;

                  return a.name.compareTo(b.name);
                });

          return _StudyYearSection(year: year, courses: yearCourses);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 18),
        itemCount: years.length,
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
          Text(
            '${course.credits} CFU',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
