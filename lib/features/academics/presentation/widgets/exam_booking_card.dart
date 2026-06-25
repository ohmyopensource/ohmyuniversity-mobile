import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/exam_booking_entity.dart';
import '../utils/exam_booking_formatters.dart';

class ExamBookingCard extends StatelessWidget {
  const ExamBookingCard({
    super.key,
    required this.exam,
    required this.questionnaireCompleted,
    required this.onInfo,
    required this.onBook,
  });

  final ExamBookingEntity exam;
  final bool questionnaireCompleted;
  final VoidCallback onInfo;
  final VoidCallback onBook;

  bool get _isBooked => exam.status == ExamBookingStatus.booked;

  bool get _questionnaireRequired =>
      !_isBooked &&
      exam.status != ExamBookingStatus.closed &&
      !questionnaireCompleted;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      key: Key('exam-booking-card-${exam.id}'),
      variant: _isBooked ? CardVariant.primary : CardVariant.defaultVariant,
      padding: CardPadding.sm,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      accentBar: _isBooked,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(exam: exam, onInfo: onInfo),
            const SizedBox(height: 13),
            Row(
              children: [
                Expanded(
                  child: _PrimaryInfo(
                    label: 'Data',
                    icon: LucideIcons.calendarDays,
                    value: formatExamDate(exam.date),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PrimaryInfo(
                    label: 'Ora',
                    icon: LucideIcons.clock3,
                    value: exam.time,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.colorNeutral100,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.timer,
                    size: 14,
                    color: AppColors.colorNeutral400,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Iscrizioni aperte fino al ${formatExamDate(exam.enrollDeadline)}',
                      style: const TextStyle(
                        color: AppColors.colorNeutral600,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 11),
            CustomButtonWidget(
              key: Key('book-exam-${exam.id}'),
              label: _buttonLabel,
              icon: _buttonIcon,
              variant: _buttonVariant,
              size: ButtonSize.sm,
              disabled:
                  exam.status == ExamBookingStatus.closed ||
                  _questionnaireRequired,
              fullWidth: true,
              onPressed: onBook,
            ),
          ],
        ),
      ),
    );
  }

  String get _buttonLabel {
    if (_questionnaireRequired) return 'Questionario da compilare';
    return switch (exam.status) {
      ExamBookingStatus.open || ExamBookingStatus.closing => 'Prenota',
      ExamBookingStatus.closed => 'Iscrizioni chiuse',
      ExamBookingStatus.booked => 'Prenotato',
    };
  }

  IconData get _buttonIcon {
    if (_questionnaireRequired) return LucideIcons.clipboardList;
    return switch (exam.status) {
      ExamBookingStatus.booked => LucideIcons.calendarCheck,
      ExamBookingStatus.closed => LucideIcons.calendarX,
      _ => LucideIcons.calendarDays,
    };
  }

  ButtonVariant get _buttonVariant {
    if (_questionnaireRequired || exam.status == ExamBookingStatus.closed) {
      return ButtonVariant.ghost;
    }
    return _isBooked ? ButtonVariant.success : ButtonVariant.primary;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.exam, required this.onInfo});

  final ExamBookingEntity exam;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    final booked = exam.status == ExamBookingStatus.booked;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.colorNeutral100,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            booked ? LucideIcons.calendarCheck : LucideIcons.calendarDays,
            size: 17,
            color: booked
                ? AppColors.colorPrimaryDark
                : AppColors.colorNeutral500,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exam.courseName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.colorNeutral900,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              CustomBadgeWidget(
                label: '${exam.credits} CFU',
                variant: BadgeVariant.neutral,
                size: BadgeSize.xs,
                shape: BadgeShape.rounded,
              ),
            ],
          ),
        ),
        const SizedBox(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomBadgeWidget(
              label: _statusLabel,
              variant: _statusVariant,
              size: BadgeSize.xs,
              shape: BadgeShape.pill,
              dot: true,
            ),
            const SizedBox(height: 9),
            CustomButtonWidget(
              key: Key('exam-info-${exam.id}'),
              icon: LucideIcons.info,
              iconOnly: true,
              ariaLabel: 'Mostra dettagli ${exam.courseName}',
              variant: ButtonVariant.ghost,
              size: ButtonSize.xs,
              onPressed: onInfo,
            ),
          ],
        ),
      ],
    );
  }

  String get _statusLabel => switch (exam.status) {
    ExamBookingStatus.open => 'Aperto',
    ExamBookingStatus.closing => 'In chiusura',
    ExamBookingStatus.closed => 'Chiuso',
    ExamBookingStatus.booked => 'Prenotato',
  };

  BadgeVariant get _statusVariant => switch (exam.status) {
    ExamBookingStatus.open => BadgeVariant.success,
    ExamBookingStatus.closing => BadgeVariant.warning,
    ExamBookingStatus.closed => BadgeVariant.error,
    ExamBookingStatus.booked => BadgeVariant.primary,
  };
}

class _PrimaryInfo extends StatelessWidget {
  const _PrimaryInfo({
    required this.label,
    required this.icon,
    required this.value,
  });

  final String label;
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.colorNeutral400,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: .4,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Icon(icon, size: 13, color: AppColors.colorPrimaryDark),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.colorNeutral900,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
