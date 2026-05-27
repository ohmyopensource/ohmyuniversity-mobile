import 'package:flutter/material.dart';

import '../../widgets/info_section.dart';
import '../../widgets/orientamento_card.dart';
import '../orientamento_shell.dart';


class ComeFunzionaUniversitaPage extends StatelessWidget {
  const ComeFunzionaUniversitaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientamentoShell(
      title: 'Come funziona l\'università',
      currentIndex: 2,
      totalCount: 6,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OrientamentoCard(
            child: InfoSection(
              icon: Icons.compare_arrows_outlined,
              title: 'Scuola vs Università',
              body:
              'All\'università nessuno ti segue: niente compiti a casa controllati, niente registro. Sei tu a organizzare il tuo studio. La libertà è totale, ma lo è anche la responsabilità. Molti studenti non superano il primo anno proprio perché sottovalutano questo salto.',
            ),
          ),

          const SizedBox(height: 12),

          // CFU explanation
          OrientamentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoSection(
                  icon: Icons.stars_outlined,
                  title: 'Cosa sono i CFU',
                  body:
                  'I Crediti Formativi Universitari (CFU) misurano il carico di studio. Un CFU corrisponde a circa 25 ore di lavoro totale tra lezioni e studio individuale. Una laurea triennale richiede 180 CFU, una magistrale altri 120.',
                ),
                Row(
                  children: const [
                    Expanded(
                      child: StatHighlight(
                        value: '180',
                        label: 'CFU per la triennale',
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatHighlight(
                        value: '25h',
                        label: 'di studio per CFU',
                        color: Color(0xFF34A853),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Exam timeline
          OrientamentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Come funzionano gli esami',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const TimelineStep(
                  index: 1,
                  title: 'Prenotazione',
                  body:
                  'Accedi al portale (Esse3/Cineca) e prenota l\'esame entro la scadenza. Senza prenotazione non puoi sostenere l\'esame.',
                ),
                const TimelineStep(
                  index: 2,
                  title: 'Esame scritto o orale',
                  body:
                  'Ogni docente decide la forma: scritto, orale, o entrambi. I risultati vanno da 18 (minimo) a 30/30 (massimo), con la lode come riconoscimento eccezionale.',
                ),
                const TimelineStep(
                  index: 3,
                  title: 'Verbalizzazione',
                  body:
                  'Dopo aver accettato il voto, viene verbalizzato: entra nel tuo libretto ufficiale e non può essere modificato.',
                ),
                const TimelineStep(
                  index: 4,
                  title: 'Appelli e sessioni',
                  body:
                  'Gli esami si tengono nelle sessioni (invernale, estiva, autunnale). Ogni sessione ha più appelli — puoi scegliere quando sostenerli, senza limite di tentativi in caso di rifiuto.',
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          OrientamentoCard(
            child: InfoSection(
              icon: Icons.event_available_outlined,
              title: 'Frequenza obbligatoria?',
              body:
              'Dipende dal corso e dal docente. Molti corsi non hanno obbligo di frequenza, ma frequentare ti aiuta a capire cosa porta all\'esame e a fare domande. Alcuni corsi (laboratori, tirocini, corsi professionalizzanti) hanno invece frequenza obbligatoria per legge.',
            ),
          ),
        ],
      ),
    );
  }
}