import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../widgets/orientation_path_card.dart';

class OrientamentoPage extends StatefulWidget {
  const OrientamentoPage({super.key});

  @override
  State<OrientamentoPage> createState() => _OrientamentoPageState();
}

class _OrientamentoPageState extends State<OrientamentoPage> {
  int? _selectedCardIndex;

  void _handleCardTap(int index, String routeName) {
    if (_selectedCardIndex != index) {
      setState(() => _selectedCardIndex = index);
      return;
    }

    context.goNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => context.goNamed(AppRoutes.loginName),
                icon: const Icon(LucideIcons.arrowLeft),
                color: colorScheme.onSurface,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: const CircleBorder(),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Vuoi iniziare un nuovo percorso?\nPrima, togli ogni dubbio.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 38),
            OrientationPathCard(
              title: 'Scopri il tuo percorso',
              subtitle:
                  'Valuta le tue passioni, fai il quiz attitudinale ed evita di scegliere per moda.',
              animationAsset: AppAssets.orientationTetrisLoop,
              isSelected: _selectedCardIndex == 0,
              onTap: () => _handleCardTap(
                0,
                AppRoutes.orientamentoScegliCorsoName,
              ),
            ),
            const SizedBox(height: 38),
            OrientationPathCard(
              title: 'Affronta l\'università',
              subtitle:
                  'Scopri cosa sono i CFU, come funzionano gli esami e come gestire la vita da fuorisede.',
              animationAsset: AppAssets.orientationPencilRuler,
              isSelected: _selectedCardIndex == 1,
              onTap: () => _handleCardTap(
                1,
                AppRoutes.orientamentoComeFunzionaName,
              ),
            ),
            const SizedBox(height: 38),
            OrientationPathCard(
              title: 'Oltre la Laurea',
              subtitle:
                  'Sii consapevole del dopo e assicurati di non cadere nelle classiche trappole.',
              animationAsset: AppAssets.orientationDesigningIcon,
              isSelected: _selectedCardIndex == 2,
              onTap: () => _handleCardTap(
                2,
                AppRoutes.orientamentoSbocchiName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}