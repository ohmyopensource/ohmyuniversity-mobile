import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/routes/app_routes.dart';
import '../../config/theme/app_colors.dart';
import '../../features/services/domain/entities/external_services_entity.dart';
import '../../features/services/presentation/providers/external_services_providers.dart';
import '../mocks/app_mock_data.dart';
import 'custom_toast/custom_toast_service.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key, this.notificationCount = 0});

  final int notificationCount;

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  static const _mockUniversity = AppMockData.university;

  String? _expandedSectionId;

  void _toggleSection(String sectionId) {
    setState(() {
      _expandedSectionId = _expandedSectionId == sectionId ? null : sectionId;
    });
  }

  void _close() => Navigator.of(context).pop();

  void _openRoute(String routeName) {
    final router = GoRouter.of(context);
    _close();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.pushNamed(routeName);
    });
  }

  void _showPlaceholderFeedback(String label) {
    _close();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$label in arrivo'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openExternalService(
    AsyncValue<ExternalServicesEntity> services,
    Uri? Function(ExternalServicesEntity) selectUrl,
    String label,
  ) async {
    final toast = ref.read(toastServiceProvider.notifier);
    if (services.isLoading) {
      toast.info('Caricamento servizi universitari in corso.');
      return;
    }
    if (services.hasError) {
      toast.error('Impossibile caricare $label.');
      return;
    }
    final data = services.value;
    final url = data == null ? null : selectUrl(data);
    if (url == null) {
      toast.warning('$label non configurato per il tuo ateneo.');
      return;
    }
    _close();
    final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!opened) toast.error('Impossibile aprire $label.');
  }

  @override
  Widget build(BuildContext context) {
    final externalServices = ref.watch(externalServicesProvider);
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DrawerHeader(university: _mockUniversity, onClose: _close),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _DrawerLabelTile(
                          icon: LucideIcons.bell,
                          label: 'Notifiche',
                          badgeCount: widget.notificationCount,
                          onTap: () => _openRoute(AppRoutes.notificheName),
                        ),
                        const SizedBox(height: 6),
                        _DrawerLabelTile(
                          icon: LucideIcons.calendarDays,
                          label: 'Agenda',
                          onTap: () => _openRoute(AppRoutes.calendarioName),
                        ),
                        const SizedBox(height: 6),
                        _DrawerLabelTile(
                          icon: LucideIcons.calendarClock,
                          label: 'Orario Lezioni',
                          onTap: () => _openRoute(AppRoutes.orarioLezioniName),
                        ),
                        const SizedBox(height: 6),
                        _DrawerLabelTile(
                          icon: LucideIcons.mail,
                          label: 'Email istituzionale',
                          onTap: () => _openRoute(AppRoutes.emailInboxName),
                        ),
                        const SizedBox(height: 12),
                        _DrawerAccordionSection(
                          id: 'transport',
                          icon: LucideIcons.bus,
                          label: 'Trasporti',
                          isExpanded: _expandedSectionId == 'transport',
                          onTap: () => _toggleSection('transport'),
                          children: [
                            _DrawerSubItem(
                              label: 'Raggiungi ${_mockUniversity.name}',
                              onTap: _close,
                            ),
                            _DrawerSubItem(
                              label: 'Prenotazione navette',
                              onTap: _close,
                            ),
                          ],
                        ),
                        _DrawerAccordionSection(
                          id: 'portals',
                          icon: LucideIcons.externalLink,
                          label: 'Portali',
                          isExpanded: _expandedSectionId == 'portals',
                          onTap: () => _toggleSection('portals'),
                          children: [
                            _DrawerSubItem(
                              label: 'Sito web',
                              onTap: () => _launch(_mockUniversity.websiteUrl),
                            ),
                            _DrawerSubItem(
                              label: 'Moodle',
                              onTap: () => _openExternalService(
                                externalServices,
                                (services) => services.moodleUrl,
                                'Moodle',
                              ),
                            ),
                            _DrawerSubItem(
                              label: 'Biblioteca',
                              onTap: () => _openExternalService(
                                externalServices,
                                (services) => services.libraryUrl,
                                'Biblioteca',
                              ),
                            ),
                            _DrawerSubItem(
                              label: 'Portale Studente',
                              onTap: () => _openExternalService(
                                externalServices,
                                (services) => services.studentPortalUrl,
                                'Portale Studente',
                              ),
                            ),
                          ],
                        ),
                        _DrawerAccordionSection(
                          id: 'rooms',
                          icon: LucideIcons.doorOpen,
                          label: 'Aule',
                          isExpanded: _expandedSectionId == 'rooms',
                          onTap: () => _toggleSection('rooms'),
                          children: [
                            _DrawerSubItem(label: 'Biblioteca', onTap: _close),
                            _DrawerSubItem(
                              label: 'Prenotazioni aule',
                              onTap: _close,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _DrawerBottomGroup(
                    expandedSectionId: _expandedSectionId,
                    onToggleSection: _toggleSection,
                    onShowPlaceholderFeedback: _showPlaceholderFeedback,
                    onOpenTuitionFees: () =>
                        _openRoute(AppRoutes.didatticaTuitionFeesName),
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

class _DrawerBottomGroup extends StatelessWidget {
  const _DrawerBottomGroup({
    required this.expandedSectionId,
    required this.onToggleSection,
    required this.onShowPlaceholderFeedback,
    required this.onOpenTuitionFees,
  });

  final String? expandedSectionId;
  final ValueChanged<String> onToggleSection;
  final ValueChanged<String> onShowPlaceholderFeedback;
  final VoidCallback onOpenTuitionFees;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 22),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DrawerLabelTile(
            icon: LucideIcons.contactRound,
            label: 'Contatti',
            onTap: () => onShowPlaceholderFeedback('Contatti'),
          ),
          const SizedBox(height: 8),
          _DrawerAccordionSection(
            id: 'secretariat',
            icon: LucideIcons.briefcaseBusiness,
            label: 'Segreteria',
            isExpanded: expandedSectionId == 'secretariat',
            onTap: () => onToggleSection('secretariat'),
            children: [
              _DrawerSubItem(
                label: 'Tasse da pagare',
                onTap: onOpenTuitionFees,
              ),
              _DrawerSubItem(
                label: 'Borse di studio',
                onTap: () => onShowPlaceholderFeedback('Borse di studio'),
              ),
              _DrawerSubItem(
                label: 'Bandi',
                onTap: () => onShowPlaceholderFeedback('Bandi'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _DrawerLabelTile(
            icon: LucideIcons.settings,
            label: 'Impostazioni',
            onTap: () => onShowPlaceholderFeedback('Impostazioni'),
          ),
          const SizedBox(height: 8),
          _DrawerLabelTile(
            icon: LucideIcons.info,
            label: 'Info app',
            onTap: () => onShowPlaceholderFeedback('Info app'),
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.university, required this.onClose});

  final MockUniversityData university;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 14, 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              university.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          _DrawerHeaderCloseButton(onTap: onClose),
        ],
      ),
    );
  }
}

class _DrawerHeaderCloseButton extends StatelessWidget {
  const _DrawerHeaderCloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          child: const Icon(
            LucideIcons.x,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _DrawerAccordionSection extends StatelessWidget {
  const _DrawerAccordionSection({
    required this.id,
    required this.icon,
    required this.label,
    required this.isExpanded,
    required this.onTap,
    required this.children,
  });

  final String id;
  final IconData icon;
  final String label;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          _DrawerLabelTile(
            icon: icon,
            label: label,
            isSelected: isExpanded,
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: const Icon(
                LucideIcons.chevronDown,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
            onTap: onTap,
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(42, 4, 4, 8),
              child: Column(children: children),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
            sizeCurve: Curves.easeOutCubic,
          ),
        ],
      ),
    );
  }
}

class _DrawerLabelTile extends StatefulWidget {
  const _DrawerLabelTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.trailing,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final Widget? trailing;
  final int badgeCount;

  @override
  State<_DrawerLabelTile> createState() => _DrawerLabelTileState();
}

class _DrawerLabelTileState extends State<_DrawerLabelTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHighlighted = widget.isSelected || _isHovered;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: widget.onTap,
        onHover: (value) => setState(() => _isHovered = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isHighlighted ? const Color(0xFFE7F4FA) : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 19, color: AppColors.textPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: isHighlighted
                        ? FontWeight.w900
                        : FontWeight.w700,
                    height: 1,
                    letterSpacing: 0,
                  ),
                ),
              ),
              if (widget.badgeCount > 0) ...[
                const SizedBox(width: 8),
                _DrawerBadge(count: widget.badgeCount),
              ],
              if (widget.trailing != null) ...[
                const SizedBox(width: 8),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerSubItem extends StatefulWidget {
  const _DrawerSubItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_DrawerSubItem> createState() => _DrawerSubItemState();
}

class _DrawerSubItemState extends State<_DrawerSubItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: widget.onTap,
        onHover: (value) => setState(() => _isHovered = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 42),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFFE7F4FA) : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.76),
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: 0,
                  ),
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: AppColors.textPrimary.withValues(alpha: 0.36),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerBadge extends StatelessWidget {
  const _DrawerBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      height: 22,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: AppColors.cta,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.cta.withValues(alpha: 0.24),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}
