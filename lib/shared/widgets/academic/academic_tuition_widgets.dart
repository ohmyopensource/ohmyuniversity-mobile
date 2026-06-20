import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';
import 'academic_summary_tiles.dart';
import '../custom_card/custom_card_widget.dart';
import '../custom_text/custom_text_widget.dart';

class AcademicTuitionFeeData {
  const AcademicTuitionFeeData({
    required this.id,
    required this.title,
    required this.amount,
    required this.isPaid,
    this.academicYear,
    this.referenceDate,
    this.isOverdue = false,
    this.receiptAvailable = false,
  });

  final String id;
  final String title;
  final double amount;
  final bool isPaid;
  final String? academicYear;
  final DateTime? referenceDate;
  final bool isOverdue;
  final bool receiptAvailable;
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

  @override
  Widget build(BuildContext context) {
    final visibleFees = fees
        .where((fee) => selectedStatus == 0 ? !fee.isPaid : fee.isPaid)
        .toList();
    const panelVariant = CardVariant.info;

    return CustomCardWidget(
      variant: panelVariant,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      padding: CardPadding.none,
      bordered: true,
      stretchHeight: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 9),
        child: Column(
          children: [
            _TuitionStatusControl(
              selectedStatus: selectedStatus,
              onChanged: onStatusChanged,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: visibleFees.isEmpty
                  ? const Center(
                      child: AcademicTuitionEmptyState(compact: true),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: visibleFees.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        return AcademicTuitionFeeTile(fee: visibleFees[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AcademicTuitionFeeTile extends StatelessWidget {
  const AcademicTuitionFeeTile({super.key, required this.fee});

  final AcademicTuitionFeeData fee;

  CardVariant get _variant {
    if (fee.isPaid) return CardVariant.success;
    if (fee.isOverdue) return CardVariant.error;
    return CardVariant.primary;
  }

  IconData get _icon {
    if (fee.isPaid) return LucideIcons.circleCheckBig;
    if (fee.isOverdue) return LucideIcons.circleAlert;
    return LucideIcons.clock3;
  }

  String get _titleLabel {
    final academicYear = fee.academicYear;
    if (academicYear == null || academicYear.isEmpty) return fee.title;
    return '${fee.title} - $academicYear';
  }

  String get _dateLabel {
    final referenceDate = fee.referenceDate;
    if (referenceDate == null) return '';

    final prefix = fee.isPaid ? 'Pagata il' : 'Scadenza:';
    return '$prefix ${_formatDate(referenceDate)}';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 280;
        final iconSize = compact ? 20.0 : 22.0;
        final gap = compact ? 5.0 : 7.0;

        return CustomCardWidget(
          variant: _variant,
          shadow: CardShadow.none,
          radius: CardRadius.md,
          padding: CardPadding.none,
          accentBar: true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(compact ? 6 : 8, 6, 8, 6),
            child: Row(
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: _iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_icon, size: 11, color: _iconColor),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextWidget(
                        text: _titleLabel,
                        variant: TextVariant.caption,
                        weight: TextWeight.bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        noWrap: true,
                      ),
                      if (_dateLabel.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        CustomTextWidget(
                          text: _dateLabel,
                          variant: TextVariant.caption,
                          color: TextColor.muted,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          noWrap: true,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: gap),
                SizedBox(
                  width: compact ? 54 : 64,
                  height: 20,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: CustomTextWidget(
                      text: _formatCurrency(fee.amount),
                      variant: TextVariant.label,
                      weight: TextWeight.extraBold,
                      noWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color get _iconBackground {
    if (fee.isPaid) return AppColors.colorSuccessLight.withValues(alpha: 0.9);
    if (fee.isOverdue) return AppColors.colorErrorLight.withValues(alpha: 0.9);
    return AppColors.colorPrimaryLight.withValues(alpha: 0.95);
  }

  Color get _iconColor {
    if (fee.isPaid) return AppColors.colorSuccessDark;
    if (fee.isOverdue) return AppColors.colorErrorDark;
    return AppColors.colorPrimaryDark;
  }
}

class AcademicTuitionCounterTile extends StatelessWidget {
  const AcademicTuitionCounterTile({
    super.key,
    required this.unpaidCount,
    required this.paidCount,
    this.onTap,
  });

  final int unpaidCount;
  final int paidCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: AcademicSummaryTiles.tileDecoration(alpha: 0.06),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Row(
            children: [
              Expanded(
                child: _TuitionCounterColumn(
                  label: 'Da pagare',
                  value: unpaidCount,
                  surfaceColor: AppColors.colorWarningLight.withValues(
                    alpha: 0.22,
                  ),
                  borderColor: AppColors.colorWarningDark.withValues(
                    alpha: 0.45,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: double.infinity,
                color: AppColors.textPrimary.withValues(alpha: 0.12),
              ),
              Expanded(
                child: _TuitionCounterColumn(
                  label: 'Pagate',
                  value: paidCount,
                  surfaceColor: AppColors.colorSuccessLight.withValues(
                    alpha: 0.26,
                  ),
                  borderColor: AppColors.colorSuccessDark.withValues(
                    alpha: 0.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TuitionCounterColumn extends StatelessWidget {
  const _TuitionCounterColumn({
    required this.label,
    required this.value,
    required this.surfaceColor,
    required this.borderColor,
  });

  final String label;
  final int value;
  final Color surfaceColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: surfaceColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                height: 1.05,
                fontSize: 9.5,
              ),
            ),
            const SizedBox(height: 7),
            FittedBox(
              child: Container(
                constraints: const BoxConstraints(minWidth: 74),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.58),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AcademicTuitionEmptyState extends StatelessWidget {
  const AcademicTuitionEmptyState({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.primary,
      shadow: CardShadow.none,
      radius: CardRadius.md,
      padding: CardPadding.none,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 18,
          vertical: compact ? 14 : 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 38 : 58,
              height: compact ? 38 : 58,
              decoration: BoxDecoration(
                color: AppColors.colorPrimaryLight.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(compact ? 13 : 18),
              ),
              child: Icon(
                LucideIcons.creditCard,
                color: AppColors.colorPrimaryDark,
                size: compact ? 19 : 28,
              ),
            ),
            SizedBox(height: compact ? 8 : 14),
            CustomTextWidget(
              text: "Non c'\u00E8 niente da pagare",
              variant: compact ? TextVariant.caption : TextVariant.h6,
              weight: TextWeight.bold,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TuitionStatusControl extends StatelessWidget {
  const _TuitionStatusControl({
    required this.selectedStatus,
    required this.onChanged,
  });

  final int selectedStatus;
  final ValueChanged<int> onChanged;

  Color get _activeColor {
    if (selectedStatus == 0) {
      return AppColors.colorWarningLight.withValues(alpha: 0.9);
    }
    return AppColors.colorSuccessLight.withValues(alpha: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.colorNeutral200),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final indicatorWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                left: selectedStatus == 0 ? 0 : indicatorWidth,
                top: 0,
                bottom: 0,
                width: indicatorWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: _activeColor,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: _activeColor.withValues(alpha: 0.35),
                        blurRadius: 9,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _TuitionStatusTab(
                      label: 'Da pagare',
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Center(
          child: CustomTextWidget(
            text: label,
            variant: TextVariant.caption,
            color: isSelected ? TextColor.defaultColor : TextColor.muted,
            weight: isSelected ? TextWeight.extraBold : TextWeight.bold,
            noWrap: true,
          ),
        ),
      ),
    );
  }
}

String _formatCurrency(double value) {
  final normalized = value.toStringAsFixed(2).replaceAll('.', ',');
  return '$normalized \u20AC';
}

String _formatDate(DateTime date) {
  const monthNames = [
    'gennaio',
    'febbraio',
    'marzo',
    'aprile',
    'maggio',
    'giugno',
    'luglio',
    'agosto',
    'settembre',
    'ottobre',
    'novembre',
    'dicembre',
  ];

  return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
}
