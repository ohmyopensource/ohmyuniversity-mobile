import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../shared/widgets/custom_text/custom_text_widget.dart';

class TuitionFeesSummarySection extends StatelessWidget {
  const TuitionFeesSummarySection({
    super.key,
    required this.paidTotal,
    required this.dueTotal,
    required this.academicYearTotal,
  });

  final double paidTotal;
  final double dueTotal;
  final double academicYearTotal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 340;
        final itemWidth = useTwoColumns
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: itemWidth,
              child: _SummaryCard(
                label: 'Pagato',
                amount: paidTotal,
                variant: CardVariant.success,
                textColor: TextColor.success,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _SummaryCard(
                label: 'Da pagare',
                amount: dueTotal,
                variant: CardVariant.warning,
                textColor: TextColor.warning,
              ),
            ),
            SizedBox(
              width: useTwoColumns ? itemWidth : constraints.maxWidth,
              child: _SummaryCard(
                label: 'Totale A.A.',
                amount: academicYearTotal,
                variant: CardVariant.primary,
                textColor: TextColor.primary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.variant,
    required this.textColor,
  });

  final String label;
  final double amount;
  final CardVariant variant;
  final TextColor textColor;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: variant,
      shadow: CardShadow.sm,
      radius: CardRadius.md,
      padding: CardPadding.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextWidget(
            text: label.toUpperCase(),
            variant: TextVariant.caption,
            color: textColor,
            weight: TextWeight.bold,
          ),
          const SizedBox(height: 6),
          CustomTextWidget(
            text: _formatCurrency(amount),
            variant: TextVariant.h6,
            weight: TextWeight.extraBold,
          ),
        ],
      ),
    );
  }
}

String _formatCurrency(double value) {
  final normalized = value.toStringAsFixed(2).replaceAll('.', ',');
  return '$normalized €';
}
