import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';

Future<String?> showGradeSimulationSheet({
  required BuildContext context,
  required String courseName,
  String? currentGrade,
}) {
  return showModalBottomSheet<String?>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _GradeSimulationSheet(
      courseName: courseName,
      currentGrade: currentGrade,
    ),
  );
}

class _GradeSimulationSheet extends StatefulWidget {
  const _GradeSimulationSheet({
    required this.courseName,
    required this.currentGrade,
  });

  final String courseName;
  final String? currentGrade;

  @override
  State<_GradeSimulationSheet> createState() => _GradeSimulationSheetState();
}

class _GradeSimulationSheetState extends State<_GradeSimulationSheet> {
  static const _removeValue = 'remove';

  late final List<String> _values;
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _values = [
      if (widget.currentGrade != null) _removeValue,
      for (var grade = 18; grade <= 30; grade++) '$grade',
      '30L',
    ];
    final currentIndex = widget.currentGrade == null
        ? -1
        : _values.indexOf(widget.currentGrade!);
    final initialIndex = currentIndex >= 0 ? currentIndex : 0;
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 330,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.colorNeutral300,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Simula un voto',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.colorNeutral900,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.courseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomButtonWidget(
                key: const Key('cancel-simulated-grade'),
                label: 'Annulla',
                variant: ButtonVariant.ghost,
                size: ButtonSize.sm,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.colorNeutral200),
          Expanded(
            child: CupertinoPicker.builder(
              key: const Key('grade-wheel-picker'),
              scrollController: _scrollController,
              itemExtent: 44,
              diameterRatio: 1.35,
              squeeze: 1.05,
              useMagnifier: true,
              magnification: 1.08,
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: AppColors.colorPrimaryLight.withValues(alpha: 0.2),
              ),
              childCount: _values.length,
              onSelectedItemChanged: (_) {},
              itemBuilder: (context, index) {
                final value = _values[index];
                return GestureDetector(
                  key: Key('grade-wheel-value-$value'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(value),
                  child: Center(
                    child: Text(
                      value == _removeValue ? 'Rimuovi simulazione' : value,
                      style: TextStyle(
                        color: value == _removeValue
                            ? AppColors.colorErrorDark
                            : AppColors.colorNeutral900,
                        fontSize: value == _removeValue ? 15 : 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
