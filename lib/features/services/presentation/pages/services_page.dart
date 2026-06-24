import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../shared/widgets/custom_toast/custom_toast_service.dart';
import '../../domain/entities/external_services_entity.dart';
import '../data/service_portal_data.dart';
import '../models/service_portal_models.dart';
import '../providers/external_services_providers.dart';

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(externalServicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Portali')),
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

class _ServicesContent extends StatefulWidget {
  const _ServicesContent({
    required this.services,
    required this.onOpen,
    required this.onOpenEmail,
  });

  final ExternalServicesEntity services;
  final ValueChanged<Uri?> onOpen;
  final VoidCallback onOpenEmail;

  @override
  State<_ServicesContent> createState() => _ServicesContentState();
}

class _ServicesContentState extends State<_ServicesContent> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServicePortalEntry> get _portals => buildServicePortals(
    services: widget.services,
    onOpenEmail: widget.onOpenEmail,
  );

  List<ServicePortalEntry> get _filteredPortals {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return _portals;

    return _portals
        .where((portal) {
          final category = _categoryFor(portal.category);
          return portal.name.toLowerCase().contains(normalizedQuery) ||
              portal.description.toLowerCase().contains(normalizedQuery) ||
              category.label.toLowerCase().contains(normalizedQuery) ||
              portal.tags.any(
                (tag) => tag.toLowerCase().contains(normalizedQuery),
              );
        })
        .toList(growable: false);
  }

  bool get _isSearching => _query.trim().isNotEmpty;

  ServicePortalCategory _categoryFor(ServicePortalCategoryId id) {
    return servicePortalCategories.firstWhere((category) => category.id == id);
  }

  List<ServicePortalEntry> _portalsForCategory(
    ServicePortalCategoryId categoryId,
  ) {
    return _filteredPortals
        .where((portal) => portal.category == categoryId)
        .toList(growable: false);
  }

  List<ServicePortalEntry> get _featuredPortals {
    return _portals
        .where((portal) => portal.featured && portal.isAvailable)
        .toList(growable: false);
  }

  void _openPortal(ServicePortalEntry portal) {
    final action = portal.onTap;
    if (action != null) {
      action();
      return;
    }

    widget.onOpen(portal.url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        Text(
          'Portali',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.colorNeutral900,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tutti i portali e strumenti utili per la tua vita universitaria, raccolti in un unico posto.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.colorNeutral500,
            height: 1.35,
          ),
        ),
        if (widget.services.universityName.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            widget.services.universityName,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.colorPrimaryDark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        const SizedBox(height: 18),
        _PortalSearchField(
          controller: _searchController,
          value: _query,
          onChanged: (value) => setState(() => _query = value),
          onClear: () {
            _searchController.clear();
            setState(() => _query = '');
          },
        ),
        const SizedBox(height: 24),
        if (!_isSearching && _featuredPortals.isNotEmpty) ...[
          _SectionHeader(
            icon: LucideIcons.star,
            title: 'In evidenza',
            count: _featuredPortals.length,
            color: AppColors.colorWarningDark,
            backgroundColor: AppColors.colorWarningLight,
          ),
          const SizedBox(height: 12),
          ..._featuredPortals.map(
            (portal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PortalCard(
                key: Key('featured-${portal.id}-service-card'),
                portal: portal,
                category: _categoryFor(portal.category),
                featured: true,
                onTap: () => _openPortal(portal),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (_isSearching) ...[
          _SectionHeader(
            icon: LucideIcons.search,
            title: 'Risultati ricerca',
            count: _filteredPortals.length,
            color: AppColors.colorInfoDark,
            backgroundColor: AppColors.colorInfoLight,
          ),
          const SizedBox(height: 12),
          if (_filteredPortals.isEmpty)
            _EmptySearchState(query: _query)
          else
            ..._filteredPortals.map(
              (portal) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PortalCard(
                  key: Key('${portal.id}-service-card'),
                  portal: portal,
                  category: _categoryFor(portal.category),
                  onTap: () => _openPortal(portal),
                ),
              ),
            ),
        ] else
          ...servicePortalCategories.expand((category) {
            final portals = _portalsForCategory(category.id);
            if (portals.isEmpty) return const <Widget>[];

            return [
              _SectionHeader(
                icon: category.icon,
                title: category.label,
                count: portals.length,
                color: category.color,
                backgroundColor: category.backgroundColor,
              ),
              const SizedBox(height: 12),
              ...portals.map(
                (portal) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PortalCard(
                    key: Key('${portal.id}-service-card'),
                    portal: portal,
                    category: category,
                    onTap: () => _openPortal(portal),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ];
          }),
      ],
    );
  }
}

class _PortalSearchField extends StatelessWidget {
  const _PortalSearchField({
    required this.controller,
    required this.value,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('portal-search-field'),
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Cerca portale, categoria o parola chiave...',
        prefixIcon: const Icon(LucideIcons.search, size: 18),
        suffixIcon: value.isEmpty
            ? null
            : IconButton(
                tooltip: 'Cancella ricerca',
                icon: const Icon(LucideIcons.x, size: 18),
                onPressed: onClear,
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
          borderSide: const BorderSide(color: AppColors.colorNeutral200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
          borderSide: const BorderSide(color: AppColors.colorNeutral200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
          borderSide: const BorderSide(
            color: AppColors.colorPrimaryDark,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.colorNeutral900,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _SmallBadge(label: '$count'),
      ],
    );
  }
}

class _PortalCard extends StatelessWidget {
  const _PortalCard({
    super.key,
    required this.portal,
    required this.category,
    required this.onTap,
    this.featured = false,
  });

  final ServicePortalEntry portal;
  final ServicePortalCategory category;
  final VoidCallback onTap;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final available = portal.isAvailable;

    return CustomCardWidget(
      variant: CardVariant.defaultVariant,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      accentBar: featured,
      clickable: true,
      onTap: onTap,
      semanticsLabel: 'Apri ${portal.name}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: category.backgroundColor.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category.icon, size: 18, color: category.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  portal.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.colorNeutral900,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (featured) ...[
                const SizedBox(width: 8),
                const Icon(
                  LucideIcons.star,
                  size: 15,
                  color: AppColors.colorWarningDark,
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            available ? portal.description : 'Servizio non configurato',
            style: theme.textTheme.bodySmall?.copyWith(
              color: available
                  ? AppColors.colorNeutral500
                  : AppColors.colorErrorDark,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: portal.tags
                .take(3)
                .map((tag) => _TagChip(label: tag))
                .toList(growable: false),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.colorNeutral200),
          const SizedBox(height: 10),
          Row(
            children: [
              _SmallBadge(label: category.label),
              const Spacer(),
              Text(
                'Apri',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: available
                      ? AppColors.colorPrimaryDark
                      : AppColors.colorNeutral400,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                LucideIcons.externalLink,
                size: 16,
                color: available
                    ? AppColors.colorPrimaryDark
                    : AppColors.colorNeutral400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.colorNeutral100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.colorNeutral200),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.colorNeutral500,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.colorNeutral100,
        borderRadius: BorderRadius.circular(AppColors.radiusFull),
        border: Border.all(color: AppColors.colorNeutral200),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.colorNeutral500,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 42),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(color: AppColors.colorNeutral200),
      ),
      child: Column(
        children: [
          const Icon(
            LucideIcons.searchX,
            size: 34,
            color: AppColors.colorNeutral300,
          ),
          const SizedBox(height: 12),
          Text(
            'Nessun portale trovato per "$query".',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.colorNeutral500,
              fontWeight: FontWeight.w700,
            ),
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
