import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../shared/widgets/custom_input/custom_input_widget.dart';
import '../../domain/entities/timetable_document_entity.dart';

class TimetableSearchModal extends StatefulWidget {
  const TimetableSearchModal({
    super.key,
    required this.documents,
    required this.initialSemester,
    required this.onView,
    required this.onDownload,
  });

  final List<TimetableDocumentEntity> documents;
  final int initialSemester;
  final ValueChanged<TimetableDocumentEntity> onView;
  final ValueChanged<TimetableDocumentEntity> onDownload;

  @override
  State<TimetableSearchModal> createState() => _TimetableSearchModalState();
}

class _TimetableSearchModalState extends State<TimetableSearchModal> {
  late String _selectedDepartment;
  late String _selectedCourse;
  late int _selectedSemester;
  bool _showResult = true;

  @override
  void initState() {
    super.initState();
    _setInitialSelection();
  }

  @override
  void didUpdateWidget(covariant TimetableSearchModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.documents != widget.documents ||
        oldWidget.initialSemester != widget.initialSemester) {
      _setInitialSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final matchingDocument = _matchingDocument;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.colorPrimaryLight,
                borderRadius: BorderRadius.circular(AppColors.radiusFull),
              ),
              child: const Icon(
                LucideIcons.calendarClock,
                color: AppColors.colorPrimaryText,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cerca orario lezioni',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Seleziona dipartimento, corso e semestre.',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        CustomInputWidget(
          label: 'Dipartimento',
          type: InputType.select,
          initialValue: _selectedDepartment,
          options: _departmentOptions,
          iconLeft: LucideIcons.building2,
          variant: InputVariant.primary,
          onChanged: (value) {
            setState(() {
              _selectedDepartment = value;
              _showResult = false;
            });
          },
        ),
        const SizedBox(height: 12),
        CustomInputWidget(
          label: 'Corso di laurea',
          type: InputType.select,
          initialValue: _selectedCourse,
          options: _courseOptions,
          iconLeft: LucideIcons.graduationCap,
          variant: InputVariant.primary,
          onChanged: (value) {
            setState(() {
              _selectedCourse = value;
              _showResult = false;
            });
          },
        ),
        const SizedBox(height: 12),
        CustomInputWidget(
          label: 'Semestre',
          type: InputType.select,
          initialValue: _selectedSemester.toString(),
          options: const [
            SelectOption(label: 'Primo semestre', value: '1'),
            SelectOption(label: 'Secondo semestre', value: '2'),
          ],
          iconLeft: LucideIcons.bookOpen,
          variant: InputVariant.primary,
          onChanged: (value) {
            setState(() {
              _selectedSemester = int.parse(value);
              _showResult = false;
            });
          },
        ),
        const SizedBox(height: 16),
        CustomButtonWidget(
          label: 'Cerca orario',
          icon: LucideIcons.search,
          variant: ButtonVariant.info,
          fullWidth: true,
          onPressed: () => setState(() => _showResult = true),
        ),
        if (_showResult) ...[
          const SizedBox(height: 18),
          if (matchingDocument == null)
            const _TimetableSearchEmptyResult()
          else
            _TimetableSearchResultPreview(document: matchingDocument),
        ],
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              LucideIcons.info,
              size: 15,
              color: AppColors.colorNeutral400,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Gli orari sono forniti direttamente dall\'ateneo. OhMyUniversity non garantisce l\'aggiornamento in tempo reale.',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.colorNeutral400,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _setInitialSelection() {
    if (widget.documents.isEmpty) {
      _selectedDepartment = '';
      _selectedCourse = '';
      _selectedSemester = widget.initialSemester;
      return;
    }

    final seed = widget.documents.firstWhere(
      (document) => document.semester == widget.initialSemester,
      orElse: () => widget.documents.first,
    );

    _selectedDepartment = seed.department;
    _selectedCourse = seed.title;
    _selectedSemester = seed.semester;
    _showResult = true;
  }

  TimetableDocumentEntity? get _matchingDocument {
    for (final document in widget.documents) {
      if (document.department == _selectedDepartment &&
          document.title == _selectedCourse &&
          document.semester == _selectedSemester) {
        return document;
      }
    }

    return null;
  }

  List<SelectOption> get _departmentOptions {
    return _unique(
      widget.documents.map((document) => document.department),
    ).map((value) => SelectOption(label: value, value: value)).toList();
  }

  List<SelectOption> get _courseOptions {
    return _unique(
      widget.documents.map((document) => document.title),
    ).map((value) => SelectOption(label: value, value: value)).toList();
  }

  List<String> _unique(Iterable<String> values) {
    return values.toSet().toList()..sort();
  }
}

class _TimetableSearchResultPreview extends StatelessWidget {
  const _TimetableSearchResultPreview({required this.document});

  final TimetableDocumentEntity document;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomCardWidget(
      variant: CardVariant.info,
      padding: CardPadding.none,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      accentBar: true,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.colorPrimaryLight,
                borderRadius: BorderRadius.circular(AppColors.radiusMd),
              ),
              child: const Icon(
                LucideIcons.calendarClock,
                color: AppColors.colorPrimaryText,
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          document.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomBadgeWidget(
                        label: document.degreeClass,
                        variant: BadgeVariant.secondary,
                        size: BadgeSize.xs,
                        shape: BadgeShape.pill,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${document.department} - ${document.universityName}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral500,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      CustomBadgeWidget(
                        label: 'Semestre ${document.semester}',
                        variant: BadgeVariant.info,
                        size: BadgeSize.sm,
                        shape: BadgeShape.pill,
                      ),
                      CustomBadgeWidget(
                        label: document.academicYear,
                        variant: BadgeVariant.neutral,
                        size: BadgeSize.sm,
                        shape: BadgeShape.pill,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimetableSearchEmptyResult extends StatelessWidget {
  const _TimetableSearchEmptyResult();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomCardWidget(
      variant: CardVariant.neutral,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      child: Row(
        children: [
          const CustomBadgeWidget(
            icon: LucideIcons.searchX,
            variant: BadgeVariant.neutral,
            size: BadgeSize.lg,
            shape: BadgeShape.pill,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nessun orario trovato per i filtri selezionati.',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.colorNeutral500,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
