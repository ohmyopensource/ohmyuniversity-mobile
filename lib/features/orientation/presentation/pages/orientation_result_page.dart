import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/orientation_result_entity.dart';
import '../widgets/orientation_area_score_card.dart';
import '../widgets/orientation_tip_card.dart';

class OrientationResultPage extends StatelessWidget {
  const OrientationResultPage({
    super.key,
    required this.result,
    required this.onBack,
  });

  final OrientationResultEntity result;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        title: const Text('Il tuo risultato'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 40),
        physics: const BouncingScrollPhysics(),
        children: [
          CustomCardWidget(
            variant: CardVariant.primary,
            padding: CardPadding.lg,
            shadow: CardShadow.md,
            radius: CardRadius.lg,
            bordered: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomBadgeWidget(
                  label: 'Il tuo profilo',
                  variant: BadgeVariant.primary,
                  size: BadgeSize.sm,
                ),
                const SizedBox(height: 12),
                Text(
                  result.dominantArea.label,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'È l’area che rispecchia maggiormente interessi e priorità emersi dalle tue risposte.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _SectionTitle(title: 'Le tue aree principali'),
          const SizedBox(height: 10),
          for (var index = 0; index < result.topAreas.length; index++) ...[
            OrientationAreaScoreCard(
              area: result.topAreas[index],
              position: index + 1,
            ),
            if (index != result.topAreas.length - 1) const SizedBox(height: 9),
          ],
          const SizedBox(height: 22),
          OrientationTipCard(
            icon: LucideIcons.lightbulb,
            title: 'Consigli personalizzati',
            tips: result.personalizedTips,
            variant: CardVariant.info,
          ),
          const SizedBox(height: 10),
          OrientationTipCard(
            icon: LucideIcons.circleCheckBig,
            title: 'Consapevolezza della scelta · ${result.awarenessScore}',
            tips: result.awarenessTips,
            variant: CardVariant.success,
          ),
          if (result.estimatedMonthlyBudget case final budget?) ...[
            const SizedBox(height: 22),
            _SectionTitle(title: 'Stima budget'),
            const SizedBox(height: 10),
            CustomCardWidget(
              variant: CardVariant.warning,
              padding: CardPadding.md,
              shadow: CardShadow.sm,
              radius: CardRadius.lg,
              bordered: false,
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.walletCards,
                    color: AppColors.colorWarningText,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Stima indicativa legata all’area geografica scelta.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.colorNeutral600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          OrientationTipCard(
            icon: LucideIcons.badgeEuro,
            title: 'Budget e agevolazioni',
            tips: result.budgetTips,
            variant: CardVariant.warning,
          ),
          const SizedBox(height: 22),
          const _SectionTitle(title: 'Prossimi passi'),
          const SizedBox(height: 10),
          const OrientationTipCard(
            icon: LucideIcons.listChecks,
            title: 'Dalla riflessione all’azione',
            tips: [
              'Controlla il piano di studi dei corsi che ti interessano.',
              'Parla con studenti e partecipa agli open day.',
              'Verifica TOLC, modalità di accesso e scadenze.',
              'Confronta costi, servizi e distanza delle diverse sedi.',
            ],
            variant: CardVariant.info,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
