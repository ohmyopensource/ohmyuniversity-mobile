import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/exam_appeal_entity.dart';
import '../providers/exam_appeals_provider.dart';
import 'appeals_month_tabs.dart';

class ExamAppealsSection extends ConsumerStatefulWidget {
  const ExamAppealsSection({super.key});

  @override
  ConsumerState<ExamAppealsSection> createState() => _ExamAppealsSectionState();
}

class _ExamAppealsSectionState extends ConsumerState<ExamAppealsSection>
    with TickerProviderStateMixin {
  static const _greenSurface = Color(0xFFE3F4E8);
  static const _greenActive = Color(0xFFC6DDCF);

  int? _selectedMonth;
  int _selectedStatus = 0;

  List<int> _availableMonths(List<ExamAppealEntity> appeals) {
    final months = appeals.map((appeal) => appeal.month).toSet().toList();
    months.sort(_compareSessionMonths);

    return months;
  }

  List<ExamAppealEntity> _visibleAppeals(
    List<ExamAppealEntity> appeals,
    int selectedMonth,
  ) {
    final showBooked = _selectedStatus == 0;

    return appeals
        .where(
          (appeal) =>
              appeal.month == selectedMonth && appeal.isBooked == showBooked,
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  int _compareSessionMonths(int a, int b) {
    const order = [6, 7, 9, 10, 1, 2];
    final aIndex = order.indexOf(a);
    final bIndex = order.indexOf(b);

    if (aIndex == -1 && bIndex == -1) return a.compareTo(b);
    if (aIndex == -1) return 1;
    if (bIndex == -1) return -1;

    return aIndex.compareTo(bIndex);
  }

  void _changeMonth(int month) {
    if (month == _selectedMonth) return;

    setState(() {
      _selectedMonth = month;
      _selectedStatus = 0;
    });
  }

  void _changeStatus(int status) {
    if (status == _selectedStatus) return;

    setState(() => _selectedStatus = status);
  }

  @override
  Widget build(BuildContext context) {
    final appeals = ref.watch(examAppealsProvider);
    final months = _availableMonths(appeals);
    final selectedMonth = months.contains(_selectedMonth)
        ? _selectedMonth!
        : months.isNotEmpty
        ? months.first
        : 0;
    final visibleAppeals = selectedMonth == 0
        ? <ExamAppealEntity>[]
        : _visibleAppeals(appeals, selectedMonth);

    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE7EDE6),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppealsMonthTabs(
              months: months,
              selectedMonth: selectedMonth,
              activeColor: _greenActive,
              inactiveColor: _greenSurface.withValues(alpha: 0.76),
              onChanged: _changeMonth,
            ),
            const SizedBox(height: 10),
            _AppealStatusControl(
              selectedStatus: _selectedStatus,
              onChanged: _changeStatus,
            ),
            const SizedBox(height: 10),
            if (visibleAppeals.isEmpty)
              const _EmptyAppealsTile()
            else
              for (var index = 0; index < visibleAppeals.length; index++) ...[
                _ExamAppealTile(appeal: visibleAppeals[index]),
                if (index != visibleAppeals.length - 1)
                  const SizedBox(height: 10),
              ],
          ],
        ),
      ),
    );
  }
}

class _AppealStatusControl extends StatelessWidget {
  const _AppealStatusControl({
    required this.selectedStatus,
    required this.onChanged,
  });

  final int selectedStatus;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final indicatorWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                left: selectedStatus == 0 ? 0 : indicatorWidth,
                top: 0,
                bottom: 0,
                width: indicatorWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: ExamAppealsSectionStateColors.statusIndicator,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.32),
                        blurRadius: 12,
                        offset: const Offset(-2, -2),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _StatusTab(
                      label: 'Appelli prenotati',
                      isSelected: selectedStatus == 0,
                      onTap: () => onChanged(0),
                    ),
                  ),
                  Expanded(
                    child: _StatusTab(
                      label: 'Appelli in apertura',
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

abstract final class ExamAppealsSectionStateColors {
  static const statusIndicator = Color(0xFFEAF8EE);
}

class _StatusTab extends StatelessWidget {
  const _StatusTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            style: theme.textTheme.labelMedium!.copyWith(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textPrimary.withValues(alpha: 0.62),
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              letterSpacing: 0,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

class _ExamAppealTile extends StatelessWidget {
  const _ExamAppealTile({required this.appeal});

  final ExamAppealEntity appeal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final isCompact = availableWidth < 340;
        final iconSize = isCompact ? 38.0 : 42.0;
        final gap = isCompact ? 7.0 : 9.0;
        const trailingWidth = 46.0;

        return Container(
          constraints: const BoxConstraints(minHeight: 76),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 9 : 11,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: ExamAppealsSectionStateColors.statusIndicator.withValues(
              alpha: 0.88,
            ),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: AppColors.textPrimary.withValues(alpha: 0.16),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFBDE8CB),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  LucideIcons.calendarDays,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appeal.examName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _appealDetails(appeal),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.74),
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    if (!appeal.isBooked) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _AppealBookingStateButton(
                          isBookable: appeal.isBookable,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: gap),
              SizedBox(
                width: trailingWidth,
                child: _AppealTrailingInfo(appeal: appeal),
              ),
            ],
          ),
        );
      },
    );
  }

  String _appealDetails(ExamAppealEntity appeal) {
    final day = appeal.date.day.toString().padLeft(2, '0');
    final month = appeal.date.month.toString().padLeft(2, '0');
    final room = appeal.room == null ? '' : ' - ${appeal.room}';

    return '$day/$month$room';
  }
}

class _AppealTrailingInfo extends StatelessWidget {
  const _AppealTrailingInfo({required this.appeal});

  final ExamAppealEntity appeal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          appeal.time,
          textAlign: TextAlign.right,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _AppealBookingStateButton extends StatefulWidget {
  const _AppealBookingStateButton({required this.isBookable, this.onTap});

  final bool isBookable;
  final VoidCallback? onTap;

  @override
  State<_AppealBookingStateButton> createState() =>
      _AppealBookingStateButtonState();
}

class _AppealBookingStateButtonState extends State<_AppealBookingStateButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (!widget.isBookable || _isPressed == value) return;

    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.isBookable;
    final backgroundColor = isEnabled
        ? _isPressed
              ? const Color(0xFF4EAD72)
              : const Color(0xFF62C985)
        : AppColors.textPrimary.withValues(alpha: 0.12);

    return AnimatedScale(
      scale: isEnabled && _isPressed ? 0.94 : 1,
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? widget.onTap : null,
          onTapDown: isEnabled ? (_) => _setPressed(true) : null,
          onTapUp: isEnabled ? (_) => _setPressed(false) : null,
          onTapCancel: isEnabled ? () => _setPressed(false) : null,
          borderRadius: BorderRadius.circular(999),
          splashColor: Colors.white.withValues(alpha: 0.22),
          highlightColor: Colors.white.withValues(alpha: 0.10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(999),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: _isPressed ? 0.10 : 0.20,
                        ),
                        blurRadius: _isPressed ? 3 : 6,
                        offset: Offset(0, _isPressed ? 1 : 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                isEnabled ? 'Prenotabile' : 'Non prenotabile',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isEnabled
                      ? Colors.white
                      : AppColors.textPrimary.withValues(alpha: 0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyAppealsTile extends StatelessWidget {
  const _EmptyAppealsTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: ExamAppealsSectionStateColors.statusIndicator.withValues(
          alpha: 0.72,
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        'Nessun appello disponibile',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary.withValues(alpha: 0.68),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
