import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/academic/academic_tuition_widgets.dart';
import '../../../../shared/widgets/custom_text/custom_text_widget.dart';
import '../../domain/entities/tuition_snapshot_entity.dart';
import '../providers/tuition_providers.dart';
import '../widgets/tuition_fee_record_tile.dart';
import '../widgets/tuition_fees_summary_section.dart';

class TuitionFeesPage extends ConsumerWidget {
  const TuitionFeesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(tuitionSnapshotProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Segreteria')),
      body: snapshot.when(
        data: (data) => _TuitionContent(snapshot: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _TuitionErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(tuitionSnapshotProvider),
        ),
      ),
    );
  }
}

class _TuitionContent extends ConsumerWidget {
  const _TuitionContent({required this.snapshot});

  final TuitionSnapshotEntity snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final computedDue = snapshot.fees
        .where((fee) => !fee.isPaid)
        .fold<double>(0, (sum, fee) => sum + fee.amount);
    final dueTotal = snapshot.totalDue > 0 ? snapshot.totalDue : computedDue;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(tuitionSnapshotProvider);
        await ref.read(tuitionSnapshotProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          const CustomTextWidget(
            text: 'Tasse',
            variant: TextVariant.h5,
            weight: TextWeight.bold,
          ),
          const SizedBox(height: 14),
          TuitionFeesSummarySection(
            paidTotal: snapshot.paidTotal,
            dueTotal: dueTotal,
            academicYearTotal: snapshot.academicYearTotal,
          ),
          const SizedBox(height: 66),
          const CustomTextWidget(
            text: 'Dettaglio rate',
            variant: TextVariant.h5,
            weight: TextWeight.bold,
          ),
          const SizedBox(height: 10),
          if (snapshot.fees.isEmpty)
            const AcademicTuitionEmptyState()
          else
            ...snapshot.fees.map(
              (fee) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: TuitionFeeRecordTile(
                  fee: fee,
                  onPrimaryAction: () => _showPlaceholderFeedback(
                    context,
                    fee.isPaid
                        ? 'Ricevuta disponibile tramite il portale ESSE3.'
                        : 'Il pagamento è disponibile sul portale ESSE3.',
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

class _TuitionErrorState extends StatelessWidget {
  const _TuitionErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.cloudOff,
              size: 34,
              color: AppColors.colorNeutral400,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 17),
              label: const Text('Riprova'),
            ),
          ],
        ),
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
