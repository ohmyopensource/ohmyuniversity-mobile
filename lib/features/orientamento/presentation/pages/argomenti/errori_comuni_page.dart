import 'package:flutter/material.dart';

import '../../widgets/orientamento_card.dart';
import '../orientamento_shell.dart';


class ErroriComuniPage extends StatelessWidget {
  const ErroriComuniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientamentoShell(
      title: 'Errori comuni da evitare',
      currentIndex: 5,
      totalCount: 6,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ErrorCard(
            icon: Icons.trending_up_outlined,
            color: Color(0xFFEA4335),
            title: 'Scegliere per moda',
            body:
            'Informatica, economia, marketing: ci sono corsi che "vanno" in un certo periodo storico. Ma se non ti appassionano, il rischio di abbandonare è altissimo. Il mercato del lavoro cambia: punta su ciò che ti motiva, non su ciò che è trendy.',
          ),
          _ErrorCard(
            icon: Icons.people_outline,
            color: Color(0xFFFF6D00),
            title: 'Seguire gli amici',
            body:
            'Andare nella stessa università degli amici può sembrare rassicurante. Ma se il corso non è giusto per te, saranno tre anni difficili. La scelta universitaria è personale: i tuoi amici avranno i loro percorsi, tu abbi il tuo.',
          ),
          _ErrorCard(
            icon: Icons.functions_outlined,
            color: Color(0xFF9C27B0),
            title: 'Sottovalutare matematica e logica',
            body:
            'Anche corsi apparentemente non tecnici (economia, psicologia, scienze politiche) richiedono statistica e logica. Arriva preparato: il primo anno spesso fa la selezione naturale proprio su queste basi.',
          ),
          _ErrorCard(
            icon: Icons.search_outlined,
            color: Color(0xFF1A73E8),
            title: 'Non informarsi sugli esami',
            body:
            'Molti studenti si iscrivono senza aver mai visto un esame del corso che scelgono. Cerca su YouTube, chiedi a studenti degli anni superiori, leggi i forum universitari. Sapere cosa ti aspetta è già metà del lavoro.',
          ),
          _ErrorCard(
            icon: Icons.event_busy_outlined,
            color: Color(0xFF34A853),
            title: 'Rimandare la prima sessione',
            body:
            'Il primo anno è fondamentale. Chi rimanda gli esami della prima sessione tende ad accumulare ritardo che diventa sempre più difficile da recuperare. Inizia subito, anche se non sei sicuro di essere pronto.',
          ),
          _ErrorCard(
            icon: Icons.attach_money_outlined,
            color: Color(0xFFFBBC04),
            title: 'Non informarsi su borse e agevolazioni',
            body:
            'Migliaia di studenti perdono ogni anno borse di studio e agevolazioni semplicemente perché non fanno domanda in tempo. Controlla i bandi DSU regionali, le borse di merito, i posti in residenza: i soldi ci sono, bisogna saperli trovare.',
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OrientamentoCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}