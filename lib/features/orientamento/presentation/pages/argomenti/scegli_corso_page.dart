import 'package:flutter/material.dart';

import '../../widgets/info_section.dart';
import '../../widgets/orientamento_card.dart';
import '../orientamento_shell.dart';

class ScegliCorsoPage extends StatelessWidget {
  const ScegliCorsoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientamentoShell(
      title: 'Scegli il corso adatto a te',
      currentIndex: 0,
      totalCount: 6,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OrientamentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoSection(
                  icon: Icons.interests_outlined,
                  title: 'Parti dalle tue passioni',
                  body:
                  'Il primo passo è capire cosa ti appassiona davvero. Non scegliere un corso per moda o per seguire gli amici: saranno tre o cinque anni della tua vita, e la motivazione fa tutta la differenza tra finire o abbandonare.',
                ),
                InfoSection(
                  icon: Icons.category_outlined,
                  title: 'Materie e aree di interesse',
                  body:
                  'Rifletti su quali materie ti hanno sempre attratto: scienze, lettere, economia, ingegneria, arte? Ogni corso universitario affonda le radici in una macro-area. Capire la tua ti aiuta a restringere il campo.',
                ),
                InfoSection(
                  icon: Icons.calculate_outlined,
                  title: 'Calcola la tua media',
                  body:
                  'Alcuni corsi — in particolare medicina, architettura e alcune facoltà scientifiche — prevedono un test d\'ingresso. Conoscere la tua media scolastica ti dà un\'idea del tuo punto di partenza rispetto ai requisiti richiesti.',
                ),
                InfoSection(
                  icon: Icons.map_outlined,
                  title: 'Area geografica',
                  body:
                  'Vuoi studiare vicino a casa o sei disposto a trasferirti? La scelta dell\'area geografica influisce sui costi di vita, sulle opportunità di stage e sul network che costruirai. Le grandi città universitarie offrono più opportunità, ma anche costi più alti.',
                ),
                InfoSection(
                  icon: Icons.school_outlined,
                  title: 'Scegli l\'università',
                  body:
                  'Una volta definita la macro-area e la zona geografica, confronta le università disponibili: ranking, strutture, qualità del corpo docente, opportunità Erasmus, e tasso di occupazione dei laureati sono tutti fattori da considerare.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Stats row
          Row(
            children: const [
              Expanded(
                child: StatHighlight(
                  value: '90+',
                  label: 'Corsi di laurea triennale in Italia',
                  color: Color(0xFF1A73E8),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatHighlight(
                  value: '97',
                  label: 'Atenei pubblici e privati accreditati',
                  color: Color(0xFF34A853),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // TODO: fetch real data from MUR / European Data Portal
          OrientamentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Dati aggiornati — fonte MUR',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'I dati sui corsi di laurea disponibili in Italia vengono aggiornati annualmente dal Ministero dell\'Università e della Ricerca (MUR). In questa sezione mostreremo in futuro l\'elenco aggiornato filtrato per area e regione.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                    Theme.of(context).colorScheme.onSurfaceVariant,
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