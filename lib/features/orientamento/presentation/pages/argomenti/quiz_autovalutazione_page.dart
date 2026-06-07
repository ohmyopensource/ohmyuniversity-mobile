import 'package:flutter/material.dart';

import '../../widgets/info_section.dart';
import '../../widgets/orientamento_card.dart';
import '../orientamento_shell.dart';

class QuizAutovalutazionePage extends StatelessWidget {
  const QuizAutovalutazionePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OrientamentoShell(
      title: 'Quiz e Autovalutazione',
      currentIndex: 1,
      totalCount: 6,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OrientamentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                InfoSection(
                  icon: Icons.school_outlined,
                  title: 'Scegli l\'universit\u00E0',
                  body:
                      'Prima di fare un quiz, \u00E8 utile gi\u00E0 avere in mente due o tre atenei che ti attraggono. Il quiz ti aiuter\u00E0 a capire se la tua scelta \u00E8 coerente con il tuo profilo.',
                ),
                InfoSection(
                  icon: Icons.menu_book_outlined,
                  title: 'Scegli il corso universitario',
                  body:
                      'Ogni corso ha prerequisiti diversi. Sapere verso quale corso ti stai orientando ti permette di fare una autovalutazione pi\u00F9 precisa e mirata.',
                ),
                InfoSection(
                  icon: Icons.account_tree_outlined,
                  title: 'Macro-area del corso',
                  body:
                      'Le macro-aree (ING/INF, TUR, MED, LET, ECO...) raggruppano corsi con caratteristiche simili. Conoscere la tua macro-area ti aiuta a capire il tipo di ragionamento e le competenze che ti saranno richieste.',
                ),
                InfoSection(
                  icon: Icons.checklist_outlined,
                  title: 'Test d\'ingresso',
                  body:
                      'Molti corsi prevedono un test d\'ingresso - alcuni selettivi (medicina, architettura), altri orientativi (ingegneria, economia). In questa sezione troverai l\'elenco dei test per ogni universit\u00E0 selezionata e materiale per prepararti.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.tertiaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.quiz,
                  size: 40,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 12),
                Text(
                  'Quiz in arrivo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Stiamo integrando i dati di MUR e European Data Portal per offrirti un quiz di autovalutazione personalizzato. Torna presto!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.8,
                    ),
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
