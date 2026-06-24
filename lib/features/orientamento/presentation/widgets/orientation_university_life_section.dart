import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';

class OrientationUniversityLifeSection extends StatelessWidget {
  const OrientationUniversityLifeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        const _SectionHeader(
          title: 'Come si distribuisce la settimana',
          subtitle:
              'Uno studente a tempo pieno occupa mediamente 50–60 ore settimanali tra lezioni, studio e attività collegate.',
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _weekBlocks.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (context, index) => _WeekCard(item: _weekBlocks[index]),
        ),
        const SizedBox(height: 24),
        const _SectionHeader(
          title: 'Gli orari delle lezioni',
          subtitle:
              'Le lezioni universitarie non sono come le ore scolastiche. Ecco cosa cambia davvero.',
        ),
        const SizedBox(height: 14),
        const _Timeline(items: _timetableTips),
        const SizedBox(height: 24),
        const _SectionHeader(
          title: 'Studio individuale - la vera differenza',
          subtitle:
              "Le lezioni coprono circa un terzo del lavoro reale. Il resto dipende da come organizzi il tempo fuori dall'aula.",
        ),
        const SizedBox(height: 14),
        for (final item in _studyTips) ...[
          _SuccessCard(item: item),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.colorNeutral500,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _WeekCard extends StatelessWidget {
  const _WeekCard({required this.item});

  final _WeekBlock item;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.defaultVariant,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.background,
              borderRadius: BorderRadius.circular(AppColors.radiusMd),
            ),
            child: Icon(item.icon, color: item.color, size: 19),
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          CustomBadgeWidget(
            label: item.hours,
            variant: BadgeVariant.neutral,
            shape: BadgeShape.pill,
            size: BadgeSize.xs,
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.items});

  final List<_Tip> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final last = index == items.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF60A5FA),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!last)
                  Container(
                    width: 1,
                    height: 78,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: const Color(0xFFDBEAFE),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: last ? 0 : 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.colorNeutral500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.item});

  final _Tip item;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.defaultVariant,
      padding: CardPadding.md,
      shadow: CardShadow.none,
      radius: CardRadius.lg,
      bordered: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.colorSuccessLight,
              borderRadius: BorderRadius.circular(AppColors.radiusMd),
            ),
            child: const Icon(
              LucideIcons.circleCheck,
              color: AppColors.colorSuccessText,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral600,
                    height: 1.4,
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

class _WeekBlock {
  const _WeekBlock(
    this.icon,
    this.title,
    this.hours,
    this.color,
    this.background,
  );

  final IconData icon;
  final String title;
  final String hours;
  final Color color;
  final Color background;
}

class _Tip {
  const _Tip(this.title, this.description);

  final String title;
  final String description;
}

const _weekBlocks = [
  _WeekBlock(
    LucideIcons.calendarDays,
    'Lezioni',
    '15–20 ore/sett.',
    Color(0xFF2563EB),
    Color(0xFFEFF6FF),
  ),
  _WeekBlock(
    LucideIcons.bookOpen,
    'Studio individuale',
    '20–25 ore/sett.',
    Color(0xFF0891B2),
    Color(0xFFECFEFF),
  ),
  _WeekBlock(
    LucideIcons.users,
    'Gruppi di studio',
    '0–5 ore/sett.',
    Color(0xFF16A34A),
    Color(0xFFF0FDF4),
  ),
  _WeekBlock(
    LucideIcons.zap,
    'Tempo libero e sport',
    '15–20 ore/sett.',
    Color(0xFFF59E0B),
    Color(0xFFFFFBEB),
  ),
];

const _timetableTips = [
  _Tip(
    'Gli orari non sono come al liceo',
    'Potresti avere due ore di lezione al mattino e una lunga pausa prima della lezione successiva. Questi intervalli sono utili per studiare.',
  ),
  _Tip(
    'Lezioni spezzate su più giorni',
    'Un corso può distribuire poche ore di lezione su giorni diversi. Leggere bene il piano orario aiuta a costruire una routine stabile.',
  ),
];

const _studyTips = [
  _Tip(
    'Studia subito dopo la lezione',
    'Ripassare entro 24 ore aiuta a consolidare i contenuti e riduce il carico prima della sessione.',
  ),
  _Tip(
    "Non studiare solo prima dell'esame",
    'Lo studio concentrato può aiutare a superare una prova, ma quello distribuito costruisce competenze più solide e durature.',
  ),
];

