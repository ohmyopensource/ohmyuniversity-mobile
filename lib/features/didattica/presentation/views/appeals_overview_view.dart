import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_input/custom_input_widget.dart';
import '../../../../shared/widgets/custom_tab/custom_tab_widget.dart';
import '../../../../shared/widgets/custom_toast/custom_toast_service.dart';
import '../../domain/entities/exam_booking_entity.dart';
import '../../domain/entities/exam_booking_history_entity.dart';
import '../providers/appeals_controller.dart';
import '../providers/questionnaires_provider.dart';
import '../widgets/exam_booking_card.dart';
import '../widgets/exam_booking_sheets.dart';

class AppealsOverviewView extends ConsumerStatefulWidget {
  const AppealsOverviewView({super.key});

  @override
  ConsumerState<AppealsOverviewView> createState() =>
      _AppealsOverviewViewState();
}

class _AppealsOverviewViewState extends ConsumerState<AppealsOverviewView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(appealsControllerProvider.notifier).loadAvailableAppeals(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appealsControllerProvider);
    final exams = ref.watch(visibleExamBookingsProvider);
    final query = state.searchQuery.trim().toLowerCase();
    final history = state.bookingHistory
        .where(
          (booking) =>
              query.isEmpty ||
              booking.courseName.toLowerCase().contains(query) ||
              booking.courseCode.toLowerCase().contains(query),
        )
        .toList(growable: false);
    final resultCount = state.filter == AppealsFilter.booked
        ? history.length
        : exams.length;

    return ListView(
      key: const Key('appeals-overview-list'),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 112),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          'Appelli',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.colorNeutral900,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Cerca un appello, controlla i posti e prenota il tuo esame.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.colorNeutral500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        CustomInputWidget(
          key: const Key('appeals-search'),
          type: InputType.search,
          size: InputSize.sm,
          placeholder: 'Cerca per corso, docente o aula...',
          iconLeft: LucideIcons.search,
          clearable: true,
          onChanged: ref.read(appealsControllerProvider.notifier).search,
          onCleared: () =>
              ref.read(appealsControllerProvider.notifier).search(''),
        ),
        const SizedBox(height: 12),
        CustomTabWidget(
          key: const Key('appeals-filter-tabs'),
          tabs: const [
            TabItem(id: 'all', label: 'Tutti'),
            TabItem(id: 'available', label: 'Disponibili'),
            TabItem(id: 'booked', label: 'Prenotati'),
          ],
          activeTab: state.filter.name,
          tabStyle: TabStyle.pill,
          size: TabSize.sm,
          fullWidth: true,
          onTabChange: (id) => _changeFilter(
            ref,
            AppealsFilter.values.byName(id),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '$resultCount ${resultCount == 1 ? 'risultato trovato' : 'risultati trovati'}',
          key: const Key('appeals-results-count'),
          style: const TextStyle(
            color: AppColors.colorNeutral400,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (state.filter == AppealsFilter.booked) ...[
          if (state.isHistoryLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.historyError != null)
            _HistoryError(
              message: state.historyError!,
            )
          else if (history.isEmpty)
            const _EmptyAppeals(message: 'Nessuna prenotazione trovata.')
          else
            ...history.map(
              (booking) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _BookingHistoryCard(booking: booking),
              ),
            ),
        ] else if (state.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state.error != null)
          _HistoryError(
            message: state.error!,
            onRetry: () => ref
                .read(appealsControllerProvider.notifier)
                .loadAvailableAppeals(),
          )
        else if (exams.isEmpty)
          const _EmptyAppeals()
        else ...[
          ...exams.map((exam) {
            final questionnaireCompleted = ref.watch(
              isQuestionnaireCompletedProvider(exam.courseName),
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ExamBookingCard(
                exam: exam,
                questionnaireCompleted: questionnaireCompleted,
                onInfo: () =>
                    showExamBookingDetailsSheet(context: context, exam: exam),
                onBook: () =>
                    _requestBooking(context, ref, exam, questionnaireCompleted),
              ),
            );
          }),
        ],
        const SizedBox(height: 2),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.info, size: 13, color: AppColors.colorNeutral400),
            SizedBox(width: 7),
            Expanded(
              child: Text(
                'Le prenotazioni sono definitive salvo cancellazione entro la scadenza. Per informazioni contatta la segreteria studenti.',
                style: TextStyle(
                  color: AppColors.colorNeutral400,
                  fontSize: 11,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _changeFilter(
    WidgetRef ref,
    AppealsFilter filter,
  ) async {
    final controller = ref.read(appealsControllerProvider.notifier);
    if (filter != AppealsFilter.booked) {
      controller.setFilter(filter);
      return;
    }
    if (ref.read(appealsControllerProvider).historyLoaded) {
      controller.setFilter(filter);
      return;
    }
    controller.setFilter(AppealsFilter.booked);
    await controller.loadBookingHistory();
  }

  Future<void> _requestBooking(
    BuildContext context,
    WidgetRef ref,
    ExamBookingEntity exam,
    bool questionnaireCompleted,
  ) async {
    final toast = ref.read(toastServiceProvider.notifier);
    if (exam.status == ExamBookingStatus.booked) {
      toast.warning("Sei già iscritto all'appello di ${exam.courseName}.");
      return;
    }
    if (exam.status == ExamBookingStatus.closed) {
      toast.error('Le iscrizioni per ${exam.courseName} sono chiuse.');
      return;
    }
    if (!questionnaireCompleted) {
      toast.error(
        'Prenotazione non effettuabile: prima compila il questionario del corso.',
      );
      return;
    }
    final confirmed = await showExamBookingConfirmationSheet(
      context: context,
      exam: exam,
    );
    if (!confirmed || !context.mounted) return;

    toast.warning(
      'Prenotazione reale non ancora disponibile: manca l’endpoint backend.',
    );
  }
}

class _EmptyAppeals extends StatelessWidget {
  const _EmptyAppeals({this.message = 'Nessun appello trovato con i filtri selezionati.'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('appeals-empty-state'),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 38),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.colorNeutral300),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.calendarX,
            size: 30,
            color: AppColors.colorNeutral300,
          ),
          SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorNeutral400,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingHistoryCard extends StatelessWidget {
  const _BookingHistoryCard({required this.booking});

  final ExamBookingHistoryEntity booking;

  @override
  Widget build(BuildContext context) {
    final date = booking.examDate ?? booking.bookingDate;
    final status = booking.absent
        ? 'Assente'
        : booking.withdrawn
        ? 'Ritirato'
        : booking.grade != null
        ? '${booking.grade}/30'
        : booking.passed
        ? 'Superato'
        : 'Prenotato';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.colorNeutral200),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.calendarCheck,
            size: 20,
            color: AppColors.colorPrimaryDark,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.courseName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    if (booking.courseCode.isNotEmpty) booking.courseCode,
                    if (booking.credits > 0)
                      '${_formatCredits(booking.credits)} CFU',
                    if (date != null) _formatDate(date),
                  ].join(' · '),
                  style: const TextStyle(
                    color: AppColors.colorNeutral500,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(status, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCredits(double credits) {
    return credits == credits.roundToDouble()
        ? credits.toInt().toString()
        : credits.toStringAsFixed(1);
  }
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Riprova'),
            ),
          ],
        ],
      ),
    );
  }
}
