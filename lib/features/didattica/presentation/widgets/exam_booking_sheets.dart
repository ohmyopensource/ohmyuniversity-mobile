import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../domain/entities/exam_booking_entity.dart';
import '../utils/exam_booking_formatters.dart';

Future<void> showExamBookingDetailsSheet({
  required BuildContext context,
  required ExamBookingEntity exam,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ExamDetailsSheet(exam: exam),
  );
}

Future<bool> showExamBookingConfirmationSheet({
  required BuildContext context,
  required ExamBookingEntity exam,
}) async {
  return await showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _BookingConfirmationSheet(exam: exam),
      ) ??
      false;
}

class _ExamDetailsSheet extends StatelessWidget {
  const _ExamDetailsSheet({required this.exam});

  final ExamBookingEntity exam;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Dettagli appello',
      subtitle: exam.courseName,
      child: Column(
        children: [
          _DetailTile(
            icon: LucideIcons.mapPin,
            label: 'Aula',
            value: exam.location,
          ),
          _DetailTile(
            icon: LucideIcons.building2,
            label: 'Edificio',
            value: exam.building,
          ),
          _DetailTile(
            icon: LucideIcons.userRound,
            label: 'Docente',
            value: exam.professor,
          ),
          _DetailTile(
            icon: LucideIcons.users,
            label: 'Posti disponibili',
            value: exam.spotsLeft == 0
                ? 'Esauriti'
                : '${exam.spotsLeft} su ${exam.spotsTotal}',
          ),
        ],
      ),
    );
  }
}

class _BookingConfirmationSheet extends StatelessWidget {
  const _BookingConfirmationSheet({required this.exam});

  final ExamBookingEntity exam;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Conferma prenotazione',
      subtitle: exam.courseName,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.colorPrimaryLight.withValues(alpha: .32),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.calendarCheck,
                  size: 20,
                  color: AppColors.colorPrimaryDark,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    '${formatExamDate(exam.date)} alle ${exam.time}',
                    style: const TextStyle(
                      color: AppColors.colorNeutral900,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Sei sicuro di voler prenotare questo appello?',
            style: TextStyle(
              color: AppColors.colorNeutral600,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Potrai annullare la prenotazione soltanto entro la scadenza indicata.',
            style: TextStyle(
              color: AppColors.colorNeutral500,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: CustomButtonWidget(
                  key: const Key('cancel-exam-booking'),
                  label: 'No, annulla',
                  variant: ButtonVariant.ghost,
                  fullWidth: true,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButtonWidget(
                  key: const Key('confirm-exam-booking'),
                  label: 'Sì, prenota',
                  icon: LucideIcons.calendarCheck,
                  fullWidth: true,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.colorNeutral300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.colorNeutral900,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.colorNeutral500,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButtonWidget(
                    icon: LucideIcons.x,
                    iconOnly: true,
                    ariaLabel: 'Chiudi',
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.sm,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.colorNeutral100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.colorPrimaryDark),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.colorNeutral400,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.colorNeutral900,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
