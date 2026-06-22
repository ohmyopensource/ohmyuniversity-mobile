import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../shared/widgets/custom_toast/custom_toast_service.dart';
import '../../domain/entities/external_services_entity.dart';
import '../providers/external_services_providers.dart';

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(externalServicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Servizi')),
      body: services.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ServicesError(
          message: error.toString(),
          onRetry: () => ref.invalidate(externalServicesProvider),
        ),
        data: (data) => _ServicesContent(
          services: data,
          onOpen: (url) => _openService(ref, url),
          onOpenEmail: () => context.pushNamed(AppRoutes.emailInboxName),
        ),
      ),
    );
  }

  Future<void> _openService(WidgetRef ref, Uri? url) async {
    if (url == null) {
      ref
          .read(toastServiceProvider.notifier)
          .warning('Servizio non configurato per il tuo ateneo.');
      return;
    }
    final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!opened) {
      ref
          .read(toastServiceProvider.notifier)
          .error('Impossibile aprire il servizio.');
    }
  }
}

class _ServicesContent extends StatelessWidget {
  const _ServicesContent({
    required this.services,
    required this.onOpen,
    required this.onOpenEmail,
  });

  final ExternalServicesEntity services;
  final ValueChanged<Uri?> onOpen;
  final VoidCallback onOpenEmail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        Text(
          'Servizi universitari',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.colorNeutral900,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          services.universityName.isEmpty
              ? 'Accedi ai servizi digitali del tuo ateneo.'
              : services.universityName,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.colorNeutral500,
          ),
        ),
        const SizedBox(height: 20),
        _ServiceCard(
          key: const Key('email-service-card'),
          icon: LucideIcons.mail,
          title: 'Email istituzionale',
          description: 'Consulta i messaggi del tuo account universitario.',
          available: true,
          onTap: onOpenEmail,
        ),
        const SizedBox(height: 12),
        _ServiceCard(
          key: const Key('moodle-service-card'),
          icon: LucideIcons.graduationCap,
          title: 'Moodle',
          description: 'Corsi, materiali didattici e attività online.',
          available: services.moodleUrl != null,
          onTap: () => onOpen(services.moodleUrl),
        ),
        const SizedBox(height: 12),
        _ServiceCard(
          key: const Key('library-service-card'),
          icon: LucideIcons.library,
          title: 'Biblioteca',
          description: 'Cataloghi, risorse digitali e servizi bibliotecari.',
          available: services.libraryUrl != null,
          onTap: () => onOpen(services.libraryUrl),
        ),
        const SizedBox(height: 12),
        _ServiceCard(
          key: const Key('student-portal-service-card'),
          icon: LucideIcons.school,
          title: 'Portale Studente',
          description: 'Accedi ai servizi online della tua carriera.',
          available: services.studentPortalUrl != null,
          onTap: () => onOpen(services.studentPortalUrl),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.available,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool available;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.primary,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      clickable: true,
      onTap: onTap,
      semanticsLabel: 'Apri $title',
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.colorPrimaryDark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.colorNeutral900,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  available ? description : 'Servizio non configurato',
                  style: const TextStyle(
                    color: AppColors.colorNeutral600,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            LucideIcons.externalLink,
            size: 18,
            color: AppColors.colorPrimaryDark,
          ),
        ],
      ),
    );
  }
}

class _ServicesError extends StatelessWidget {
  const _ServicesError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.cloudOff,
              size: 36,
              color: AppColors.colorNeutral400,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}
