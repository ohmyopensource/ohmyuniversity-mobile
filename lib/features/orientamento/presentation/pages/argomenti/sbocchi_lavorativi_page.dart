import 'package:flutter/material.dart';

import '../../widgets/info_section.dart';
import '../../widgets/orientamento_card.dart';
import '../orientamento_shell.dart';


class SbocchiLavorativiPage extends StatelessWidget {
  const SbocchiLavorativiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OrientamentoShell(
      title: 'Sbocchi lavorativi reali',
      currentIndex: 4,
      totalCount: 6,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OrientamentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoSection(
                  icon: Icons.location_city_outlined,
                  title: 'Scelta dell\'università',
                  body:
                  'Il nome dell\'ateneo conta, ma meno di quanto si pensi. Quello che conta davvero è la rete di contatti che costruisci, il tirocinio che fai durante gli studi e le competenze reali che acquisisci.',
                ),
                InfoSection(
                  icon: Icons.route_outlined,
                  title: 'Scelta del corso',
                  body:
                  'Alcune aree di studio hanno tassi di occupazione significativamente più alti (ingegneria, informatica, medicina). Altre sono più competitive ma non impossibili (lettere, comunicazione, scienze politiche). I dati di AlmaLaurea mostrano la situazione reale.',
                ),
                InfoSection(
                  icon: Icons.trending_up_outlined,
                  title: 'Sbocchi lavorativi per area',
                  body:
                  'In questa sezione, selezionando la tua università e il tuo corso, potrai vedere i dati reali di occupazione a 1, 3 e 5 anni dalla laurea. I dati provengono da AlmaLaurea e dal European Data Portal.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Stats
          Row(
            children: const [
              Expanded(
                child: StatHighlight(
                  value: '77%',
                  label: 'Laureati occupati a 1 anno (media nazionale)',
                  color: Color(0xFF34A853),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatHighlight(
                  value: '91%',
                  label: 'Laureati occupati a 5 anni',
                  color: Color(0xFF1A73E8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Data source placeholder
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.dataset_outlined,
                        size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Dati in arrivo — fonte European Data Portal',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Seleziona università e corso di laurea per visualizzare i dati reali di occupazione, stipendio medio e settori di sbocco. I dati saranno aggiornati trimestralmente tramite le API del European Data Portal e di AlmaLaurea.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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