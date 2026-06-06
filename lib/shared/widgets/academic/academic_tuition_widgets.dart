import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';

class AcademicTuitionFeeData {
  const AcademicTuitionFeeData({
    required this.id,
    required this.title,
    required this.amount,
    required this.isPaid,
  });

  final String id;
  final String title;
  final double amount;
  final bool isPaid;
}

class AcademicTuitionPanel extends StatelessWidget {
  const AcademicTuitionPanel({
    super.key,
    required this.fees,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  final List<AcademicTuitionFeeData> fees;
  final int selectedStatus;
  final ValueChanged<int> onStatusChanged;

  static const _surface = Color(0xFFE7EBD8);
  static const _dueActive = Color(0xFFD8ED96);
  static const _paidActive = Color(0xFFBFDCEB);
  static const _accent = Color(0xFFE7B733);
  static const _paidSurface = Color(0xFFE7F4FA);

  @override
  Widget build(BuildContext context) {
    final visibleFees = fees
        .where((fee) => selectedStatus == 0 ? !fee.isPaid : fee.isPaid)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 38, 8, 14),
      decoration: BoxDecoration(
        color: selectedStatus == 0 ? _surface : _paidSurface,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TuitionStatusControl(
            selectedStatus: selectedStatus,
            activeColor: selectedStatus == 0 ? _dueActive : _paidActive,
            onChanged: onStatusChanged,
          ),
          const SizedBox(height: 28),
          if (visibleFees.isEmpty)
            const AcademicTuitionEmptyState()
          else
            for (var index = 0; index < visibleFees.length; index++) ...[
              AcademicTuitionFeeTile(fee: visibleFees[index]),
              if (index != visibleFees.length - 1) const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class AcademicTuitionFeeTile extends StatelessWidget {
  const AcademicTuitionFeeTile({super.key, required this.fee});

  final AcademicTuitionFeeData fee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 74),
      padding: const EdgeInsets.fromLTRB(24, 12, 18, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 34,
            decoration: BoxDecoration(
              color: AcademicTuitionPanel._accent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              fee.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${fee.amount.toStringAsFixed(2)} €',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.38),
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class AcademicTuitionEmptyState extends StatelessWidget {
  const AcademicTuitionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFE7FBFF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              LucideIcons.creditCard,
              color: Color(0xFF14185E),
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Non c\'è niente da pagare',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TuitionStatusControl extends StatelessWidget {
  const _TuitionStatusControl({
    required this.selectedStatus,
    required this.activeColor,
    required this.onChanged,
  });

  final int selectedStatus;
  final Color activeColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 48,
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
                  left: selectedStatus == 0 ? 0 : indicatorWidth,
                  top: 0,
                  bottom: 0,
                  width: indicatorWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: activeColor,
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
                      child: _TuitionStatusTab(
                        label: 'Da Pagare',
                        isSelected: selectedStatus == 0,
                        onTap: () => onChanged(0),
                      ),
                    ),
                    Expanded(
                      child: _TuitionStatusTab(
                        label: 'Pagate',
                        isSelected: selectedStatus == 1,
                        onTap: () => onChanged(1),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TuitionStatusTab extends StatelessWidget {
  const _TuitionStatusTab({
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
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            style: theme.textTheme.labelMedium!.copyWith(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textPrimary.withValues(alpha: 0.36),
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
