import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';

class _ArgomentoItem {
  const _ArgomentoItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String routeName;
}

const _argomenti = [
  _ArgomentoItem(
    title: 'Scegli il corso adatto a te',
    subtitle:
    'Scopri come trovare il corso universitario più adatto alle tue passioni e al tuo futuro.',
    icon: Icons.explore_outlined,
    routeName: AppRoutes.orientamentoScegliCorsoName,
  ),
  _ArgomentoItem(
    title: 'Quiz e Autovalutazione',
    subtitle:
    'Valuta le tue attitudini e scopri quali corsi e università potrebbero fare al caso tuo.',
    icon: Icons.quiz_outlined,
    routeName: AppRoutes.orientamentoQuizName,
  ),
  _ArgomentoItem(
    title: 'Come funziona l\'università',
    subtitle:
    'CFU, esami, sessioni, frequenza: tutto quello che devi sapere prima di iniziare.',
    icon: Icons.school_outlined,
    routeName: AppRoutes.orientamentoComeFunzionaName,
  ),
  _ArgomentoItem(
    title: 'Vita universitaria concreta',
    subtitle:
    'Orari, studio, gestione del tempo e vita da fuorisede: cosa aspettarsi davvero.',
    icon: Icons.home_outlined,
    routeName: AppRoutes.orientamentoVitaUniversitariaName,
  ),
  _ArgomentoItem(
    title: 'Sbocchi lavorativi reali',
    subtitle:
    'Dati reali su occupazione, stipendi e prospettive per ogni macro-area di studio.',
    icon: Icons.work_outline,
    routeName: AppRoutes.orientamentoSbocchiName,
  ),
  _ArgomentoItem(
    title: 'Errori comuni da evitare',
    subtitle:
    'Le trappole più frequenti di chi si iscrive all\'università e come evitarle.',
    icon: Icons.warning_amber_outlined,
    routeName: AppRoutes.orientamentoErroriComuniName,
  ),
];

class OrientamentoPage extends StatelessWidget {
  const OrientamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orientamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.loginName),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Header ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.school,
                  size: 36,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 12),
                Text(
                  'Vuoi iscriverti all\'università\nper la prima volta?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ti aiutiamo noi. Esplora gli argomenti qui sotto e scopri tutto quello che devi sapere.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Argomenti',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 8),

          // ── Topic list ───────────────────────────────
          ...List.generate(_argomenti.length, (index) {
            final item = _argomenti[index];
            return _ArgomentoTile(item: item, index: index);
          }),

          const SizedBox(height: 24),

          // ── Already a student ────────────────────────
          Center(
            child: GestureDetector(
              onTap: () => context.goNamed(AppRoutes.loginName),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'Sei già uno studente? '),
                    TextSpan(
                      text: 'Clicca qui',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ArgomentoTile extends StatelessWidget {
  const _ArgomentoTile({required this.item, required this.index});

  final _ArgomentoItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.goNamed(item.routeName),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    size: 22,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}