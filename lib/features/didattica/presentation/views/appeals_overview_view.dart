import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_input/custom_input_widget.dart';
import '../../../../shared/widgets/custom_tab/custom_tab_widget.dart';
import '../../../../shared/widgets/custom_toast/custom_toast_service.dart';
import '../../domain/entities/exam_booking_entity.dart';
import '../providers/appeals_controller.dart';
import '../providers/questionnaires_provider.dart';
import '../widgets/exam_booking_card.dart';
import '../widgets/exam_booking_sheets.dart';

class AppealsOverviewView extends ConsumerWidget {
  const AppealsOverviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appealsControllerProvider);
    final exams = ref.watch(visibleExamBookingsProvider);

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
          onTabChange: (id) => ref
              .read(appealsControllerProvider.notifier)
              .setFilter(AppealsFilter.values.byName(id)),
        ),
        const SizedBox(height: 10),
        Text(
          '${exams.length} ${exams.length == 1 ? 'appello trovato' : 'appelli trovati'}',
          key: const Key('appeals-results-count'),
          style: const TextStyle(
            color: AppColors.colorNeutral400,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (exams.isEmpty)
          const _EmptyAppeals()
        else
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

    ref.read(appealsControllerProvider.notifier).book(exam.id);
    toast.success(
      'Prenotazione per ${exam.courseName} registrata. Riceverai una conferma via email.',
    );
  }
}

class _EmptyAppeals extends StatelessWidget {
  const _EmptyAppeals();

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
      child: const Column(
        children: [
          Icon(
            LucideIcons.calendarX,
            size: 30,
            color: AppColors.colorNeutral300,
          ),
          SizedBox(height: 10),
          Text(
            'Nessun appello trovato con i filtri selezionati.',
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
