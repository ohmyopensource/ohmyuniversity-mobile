import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../academics/domain/entities/exam_booking_entity.dart';
import '../../../../academics/presentation/utils/exam_booking_formatters.dart';

class HomeAppealsWidget extends StatelessWidget {
  const HomeAppealsWidget({super.key, required this.appeals});

  final List<ExamBookingEntity> appeals;

  @override
  Widget build(BuildContext context) {
    final upcoming = [...appeals]
      ..sort((first, second) => first.date.compareTo(second.date));

    return CustomCardWidget(
      key: const Key('home-appeals-widget'),
      variant: CardVariant.info,
      padding: CardPadding.sm,
      shadow: CardShadow.sm,
      stretchHeight: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                LucideIcons.calendarDays,
                size: 17,
                color: AppColors.colorPrimaryDark,
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Prossimi appelli',
                  style: TextStyle(
                    color: AppColors.colorNeutral900,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Expanded(
            child: upcoming.isEmpty
                ? const Center(
                    child: Text(
                      'Nessun appello disponibile',
                      style: TextStyle(color: AppColors.colorNeutral400),
                    ),
                  )
                : Column(
                    children: [
                      for (final appeal in upcoming.take(4))
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: appeal == upcoming.take(4).last ? 0 : 6,
                            ),
                            child: _AppealRow(appeal: appeal),
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

class _AppealRow extends StatelessWidget {
  const _AppealRow({required this.appeal});

  final ExamBookingEntity appeal;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('home-appeal-pill-${appeal.id}'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.colorNeutral200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.colorPrimaryLight.withValues(alpha: .35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  '${appeal.date.day}',
                  style: const TextStyle(
                    color: AppColors.colorNeutral900,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatExamDate(appeal.date).split(' ')[1].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.colorPrimaryDark,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  appeal.courseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.colorNeutral900,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${appeal.time} · ${appeal.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.colorNeutral500,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          CustomBadgeWidget(
            label: _statusLabel,
            variant: _statusVariant,
            size: BadgeSize.sm,
            dot: true,
          ),
        ],
      ),
    );
  }

  String get _statusLabel => switch (appeal.status) {
    ExamBookingStatus.open => 'Aperto',
    ExamBookingStatus.closing => 'Scade',
    ExamBookingStatus.closed => 'Chiuso',
    ExamBookingStatus.booked => 'Prenotato',
  };

  BadgeVariant get _statusVariant => switch (appeal.status) {
    ExamBookingStatus.open => BadgeVariant.success,
    ExamBookingStatus.closing => BadgeVariant.warning,
    ExamBookingStatus.closed => BadgeVariant.error,
    ExamBookingStatus.booked => BadgeVariant.primary,
  };
}
