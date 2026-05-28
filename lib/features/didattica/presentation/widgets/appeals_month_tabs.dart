import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class AppealsMonthTabs extends StatelessWidget {
  const AppealsMonthTabs({
    super.key,
    required this.months,
    required this.selectedMonth,
    required this.activeColor,
    required this.inactiveColor,
    required this.onChanged,
  });

  final List<int> months;
  final int selectedMonth;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<int> onChanged;

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
              child: _MonthTab(
                label: _monthLabel(months[index]),
                isSelected: selectedMonth == months[index],
                activeColor: activeColor,
                inactiveColor: inactiveColor,
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

class _MonthTab extends StatelessWidget {
  const _MonthTab({
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
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
                  color: activeColor.withValues(alpha: 0.22),
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
