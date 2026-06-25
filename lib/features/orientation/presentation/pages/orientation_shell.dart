import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';

/// Wraps each topic page with shared previous/next navigation
/// and a back-to-orientation button.
class OrientationShell extends StatelessWidget {
  const OrientationShell({
    super.key,
    required this.child,
    required this.title,
    required this.currentIndex,
    required this.totalCount,
  });

  final Widget child;
  final String title;
  final int currentIndex; // 0-based
  final int totalCount;

  bool get _hasPrev => currentIndex > 0;
  bool get _hasNext => currentIndex < totalCount - 1;

  static final _argomentiRoutes = [
    AppRoutes.orientamentoScegliCorsoName,
    AppRoutes.orientamentoQuizName,
    AppRoutes.orientamentoComeFunzionaName,
    AppRoutes.orientamentoVitaUniversitariaName,
    AppRoutes.orientamentoSbocchiName,
    AppRoutes.orientamentoErroriComuniName,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.orientamentoName),
        ),
      ),
      body: child,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Previous / Next ─────────────────────
              Row(
                children: [
                  if (_hasPrev)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            context.goNamed(_argomentiRoutes[currentIndex - 1]),
                        icon: const Icon(Icons.arrow_back_ios, size: 14),
                        label: const Text('<= Arg.Prec'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  if (_hasPrev && _hasNext) const SizedBox(width: 8),
                  if (_hasNext)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            context.goNamed(_argomentiRoutes[currentIndex + 1]),
                        icon: const Icon(Icons.arrow_forward_ios, size: 14),
                        label: const Text('Arg.Succ =>'),
                        iconAlignment: IconAlignment.end,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Back to orientation ─────────────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.goNamed(AppRoutes.orientamentoName),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: const Text('Torna ad Orientamento'),
                ),
              ),

              // ── Progress indicator ─────────────────
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalCount, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == currentIndex ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: i == currentIndex
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
