import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../shared/widgets/custom_card/custom_card_variants_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';

class QuestionnairesView extends StatelessWidget {
  const QuestionnairesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('questionnaires-overview-list'),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 112),
      physics: const BouncingScrollPhysics(),
      children: const [
        CardStatusWidget(
          statusVariant: StatusVariant.info,
          icon: LucideIcons.clipboardList,
          title: 'Questionari',
          description:
              'Qui troverai i questionari da compilare e lo storico di quelli completati.',
          padding: CardPadding.md,
          shadow: CardShadow.sm,
        ),
      ],
    );
  }
}
