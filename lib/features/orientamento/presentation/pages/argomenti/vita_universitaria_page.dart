import 'package:flutter/material.dart';

import '../../widgets/info_section.dart';
import '../../widgets/orientamento_card.dart';
import '../orientamento_shell.dart';


class VitaUniversitariaPage extends StatelessWidget {
  const VitaUniversitariaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientamentoShell(
      title: 'Vita universitaria concreta',
      currentIndex: 3,
      totalCount: 6,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OrientamentoCard(
            child: InfoSection(
              icon: Icons.schedule_outlined,
              title: 'Gli orari delle lezioni',
              body:
              'L\'orario universitario è frammentato: potresti avere lezioni al mattino, una pausa di ore e poi una lezione nel pomeriggio. Non esiste la "campanella". Impara a usare i buchi tra una lezione e l\'altra per studiare, non per aspettare.',
            ),
          ),

          const SizedBox(height: 12),

          OrientamentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoSection(
                  icon: Icons.menu_book_outlined,
                  title: 'Studio individuale',
                  body:
                  'A lezione si spiega, ma il vero studio avviene fuori dall\'aula. Per ogni ora di lezione, aspettati almeno due o tre ore di studio individuale. Le biblioteche universitarie, le sale studio e i gruppi di studio con i colleghi sono i tuoi strumenti principali.',
                ),
                Row(
                  children: const [
                    Expanded(
                      child: StatHighlight(
                        value: '3x',
                        label: 'Studio individuale vs ore di lezione',
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatHighlight(
                        value: '40h',
                        label: 'Settimana tipo di uno studente full-time',
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          OrientamentoCard(
            child: InfoSection(
              icon: Icons.timer_outlined,
              title: 'Gestione del tempo',
              body:
              'A differenza delle superiori, non hai qualcuno che ti dice quando studiare. Il tempo libero aumenta, ma aumenta anche il rischio di procrastinare. Crea una routine settimanale: assegna slot fissi allo studio, ai pasti, al riposo e alle attività sociali.',
            ),
          ),

          const SizedBox(height: 12),

          // Off-campus student section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.apartment_outlined,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Vita da fuorisede',
                      style:
                      Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _FuorisedeTopic(
                    title: 'Alloggio',
                    body:
                    'Residenze universitarie, stanze singole, appartamenti condivisi: inizia a cercare presto, il mercato degli affitti nelle città universitarie è molto competitivo.'),
                _FuorisedeTopic(
                    title: 'Costi medi',
                    body:
                    'Affitto (300–700€), vitto (~300€), trasporti e materiale (~100€). Il totale mensile medio per un fuorisede è tra 800 e 1.200€.'),
                _FuorisedeTopic(
                    title: 'Borse di studio',
                    body:
                    'L\'ISEEU e il DSU regionali offrono borse di studio, posti letto e mense agevolate. Controlla i bandi entro luglio/agosto del primo anno.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FuorisedeTopic extends StatelessWidget {
  const _FuorisedeTopic({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                      text: '$title: ',
                      style:
                      const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}