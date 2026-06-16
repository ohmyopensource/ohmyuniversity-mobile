import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/mocks/app_mock_data.dart';
import '../../../../shared/widgets/academic/academic_tuition_widgets.dart';
import '../../../../shared/widgets/custom_text/custom_text_widget.dart';
import '../widgets/tuition_fee_record_tile.dart';
import '../widgets/tuition_fees_summary_section.dart';

class TuitionFeesPage extends StatelessWidget {
  const TuitionFeesPage({super.key});

  static final _fees = AppMockData.tuitionFees;

  @override
  Widget build(BuildContext context) {
    final paidTotal = _fees
        .where((fee) => fee.isPaid)
        .fold<double>(0, (sum, fee) => sum + fee.amount);
    final dueTotal = _fees
        .where((fee) => !fee.isPaid)
        .fold<double>(0, (sum, fee) => sum + fee.amount);
    final academicYearTotal = _fees.fold<double>(
      0,
      (sum, fee) => sum + fee.amount,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Segreteria')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          const CustomTextWidget(
            text: 'Tasse',
            variant: TextVariant.h5,
            weight: TextWeight.bold,
          ),
          const SizedBox(height: 14),
          TuitionFeesSummarySection(
            paidTotal: paidTotal,
            dueTotal: dueTotal,
            academicYearTotal: academicYearTotal,
          ),
          const SizedBox(height: 66),
          const CustomTextWidget(
            text: 'Dettaglio rate',
            variant: TextVariant.h5,
            weight: TextWeight.bold,
          ),
          const SizedBox(height: 10),
          if (_fees.isEmpty)
            const AcademicTuitionEmptyState()
          else
            ..._fees.map(
              (fee) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: TuitionFeeRecordTile(
                  fee: fee,
                  onPrimaryAction: () => _showPlaceholderFeedback(
                    context,
                    fee.isPaid
                        ? 'Ricevuta di ${fee.title} in arrivo'
                        : 'Pagamento di ${fee.title} in arrivo',
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  LucideIcons.info,
                  size: 14,
                  color: AppColors.colorNeutral400,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: CustomTextWidget(
                  text:
                      'Il pagamento avviene sul portale ESSE3 tramite PagoPA. OhMyUniversity! non gestisce direttamente i pagamenti universitari.',
                  variant: TextVariant.caption,
                  color: TextColor.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showPlaceholderFeedback(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
}
