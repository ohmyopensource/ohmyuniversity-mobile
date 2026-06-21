import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/mocks/app_mock_data.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../shared/widgets/custom_text/custom_text_widget.dart';

class TuitionFeeRecordTile extends StatelessWidget {
  const TuitionFeeRecordTile({
    super.key,
    required this.fee,
    required this.onPrimaryAction,
  });

  final MockTuitionFeeData fee;
  final VoidCallback onPrimaryAction;

  CardVariant get _cardVariant {
    if (fee.isPaid) return CardVariant.success;
    if (fee.isOverdue) return CardVariant.error;
    return CardVariant.primary;
  }

  ButtonVariant get _buttonVariant {
    if (fee.isPaid) return ButtonVariant.outline;
    if (fee.isOverdue) return ButtonVariant.error;
    return ButtonVariant.primary;
  }

  IconData get _leadingIcon {
    if (fee.isPaid) return LucideIcons.circleCheckBig;
    if (fee.isOverdue) return LucideIcons.circleAlert;
    return LucideIcons.clock3;
  }

  Color get _leadingBackground {
    if (fee.isPaid) return AppColors.colorSuccessLight.withValues(alpha: 0.9);
    if (fee.isOverdue) return AppColors.colorErrorLight.withValues(alpha: 0.9);
    return AppColors.colorPrimaryLight.withValues(alpha: 0.95);
  }

  Color get _leadingForeground {
    if (fee.isPaid) return AppColors.colorSuccessDark;
    if (fee.isOverdue) return AppColors.colorErrorDark;
    return AppColors.colorPrimaryDark;
  }

  String get _primaryActionLabel => fee.isPaid ? 'Ricevuta' : 'Paga ora';

  String get _titleLabel {
    final academicYear = fee.academicYear;
    if (academicYear == null || academicYear.isEmpty) {
      return fee.title;
    }
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
    return CustomCardWidget(
      variant: _cardVariant,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      padding: CardPadding.none,
      accentBar: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 11, 12, 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _leadingBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(_leadingIcon, size: 14, color: _leadingForeground),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextWidget(
                          text: _titleLabel,
                          variant: TextVariant.bodySm,
                          weight: TextWeight.bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          noWrap: true,
                        ),
                      ),
                    ],
                  ),
                  if (_dateLabel.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    CustomTextWidget(
                      text: _dateLabel,
                      variant: TextVariant.caption,
                      color: TextColor.muted,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 94,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextWidget(
                    text: _formatCurrency(fee.amount),
                    variant: TextVariant.bodySm,
                    weight: TextWeight.extraBold,
                    align: TextAlign.right,
                  ),
                  const SizedBox(height: 5),
                  CustomButtonWidget(
                    label: _primaryActionLabel,
                    variant: _buttonVariant,
                    size: ButtonSize.xs,
                    fullWidth: true,
                    onPressed: onPrimaryAction,
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

String _formatCurrency(double value) {
  final normalized = value.toStringAsFixed(2).replaceAll('.', ',');
  return '$normalized €';
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
