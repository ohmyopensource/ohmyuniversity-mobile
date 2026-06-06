import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../models/dashboard_widget_option.dart';
import 'dashboard_widget_content.dart';

class DashboardWidgetPicker extends StatefulWidget {
  const DashboardWidgetPicker({super.key});

  @override
  State<DashboardWidgetPicker> createState() => _DashboardWidgetPickerState();
}

class _DashboardWidgetPickerState extends State<DashboardWidgetPicker> {
  String? _selectedOptionKey;

  void _selectOption(DashboardWidgetOption option) {
    if (_selectedOptionKey == option.key) return;

    HapticFeedback.selectionClick();
    setState(() => _selectedOptionKey = option.key);
  }

  void _confirmOption(DashboardWidgetOption option) {
    if (_selectedOptionKey != option.key) {
      _selectOption(option);
      return;
    }

    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(option);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 430,
                  maxHeight: 660,
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: AppColors.textPrimary.withValues(alpha: 0.06),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.13),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Aggiungi alla home',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        shadows: _titleShadows,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: DashboardWidgetOptions.all.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          final option = DashboardWidgetOptions.all[index];

                          return _DashboardWidgetPreviewTile(
                            option: option,
                            isSelected: _selectedOptionKey == option.key,
                            onTap: () => _selectOption(option),
                            onLongPress: () => _confirmOption(option),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardWidgetPreviewTile extends StatelessWidget {
  const _DashboardWidgetPreviewTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  final DashboardWidgetOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? AppColors.labelBlue
        : AppColors.textPrimary.withValues(alpha: 0.04);
    final backgroundColor = isSelected
        ? AppColors.labelBlue.withValues(alpha: 0.055)
        : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(23),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: borderColor, width: isSelected ? 1.4 : 1),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.labelBlue.withValues(alpha: 0.12),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: IgnorePointer(
                  child: SizedBox(
                    width: option.size.width,
                    height: option.size.height,
                    child: DashboardWidgetContent(
                      option: option,
                      preview: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                option.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSelected
                      ? AppColors.labelBlue
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  shadows: _titleShadows,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _titleShadows = [
  Shadow(color: Color(0x26000000), blurRadius: 3, offset: Offset(0, 1.2)),
];
