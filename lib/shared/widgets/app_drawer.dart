import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/routes/app_routes.dart';

// Mock Data models ================================

class UniversityInfo {
  const UniversityInfo({
    required this.name,
    required this.websiteUrl,
    required this.mailUrl,
  });

  final String name;
  final String websiteUrl;
  final String mailUrl;
}

// Drawer ================================

/// End drawer accessible from the top bar menu icon.
/// Shows university info, notifications, and grouped navigation items.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.notificationCount = 0});

  final int notificationCount;

  // TODO: replace with real data from active profile provider
  static const _mockUniversity = UniversityInfo(
    name: 'UNIMOL',
    websiteUrl: 'https://www.university.edu',
    mailUrl: 'https://mail.university.edu',
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header ================================
            _DrawerHeader(university: _mockUniversity),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Notifications ================================
                  _NotificationTile(count: notificationCount),

                  const _SectionDivider(),

                  // Transportation ================================
                  _SectionHeader(
                    icon: Icons.directions_bus_outlined,
                    label: 'Trasporti',
                  ),
                  _DrawerItem(
                    label: 'Raggiungi UNIMOL',
                    onTap: () => _close(context),
                  ),
                  _DrawerItem(
                    label: 'Prenotazione navette',
                    onTap: () => _close(context),
                  ),

                  const _SectionDivider(),

                  // Portals ================================
                  _SectionHeader(
                    icon: Icons.open_in_new_outlined,
                    label: 'Portali',
                  ),
                  _DrawerItem(label: 'Esse3', onTap: () => _close(context)),
                  _DrawerItem(label: 'Cineca', onTap: () => _close(context)),

                  const _SectionDivider(),

                  // Classrooms ================================
                  _SectionHeader(
                    icon: Icons.meeting_room_outlined,
                    label: 'Aule',
                  ),
                  _DrawerItem(
                    label: 'Biblioteca',
                    onTap: () => _close(context),
                  ),
                  _DrawerItem(
                    label: 'Prenotazioni aule',
                    onTap: () => _close(context),
                  ),

                  const _SectionDivider(),

                  // Info ================================
                  _SectionHeader(icon: Icons.info_outline, label: 'Info'),
                  _DrawerItem(
                    label: 'Rubrica docenti',
                    onTap: () => _close(context),
                  ),
                  _DrawerItem(
                    label: 'Segreteria',
                    onTap: () => _close(context),
                  ),
                  _DrawerItem(
                    label: 'Impostazioni',
                    onTap: () => _close(context),
                  ),
                  _DrawerItem(label: 'Info app', onTap: () => _close(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _close(BuildContext context) => Navigator.of(context).pop();
}

// Header ================================

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.university});

  final UniversityInfo university;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          // University name
          Expanded(
            child: Text(
              university.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Website
          _HeaderIconButton(
            icon: Icons.language,
            tooltip: 'Website',
            onTap: () => _launch(university.websiteUrl),
          ),

          // Mail
          _HeaderIconButton(
            icon: Icons.mail_outline,
            tooltip: 'Mail',
            onTap: () => _launch(university.mailUrl),
          ),

          // Close drawer
          _HeaderIconButton(
            icon: Icons.close,
            tooltip: 'Close',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

// Notification ================================

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).pop();
          context.pushNamed(AppRoutes.notificheName);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 22,
                color: colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Notifiche',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (count > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onError,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Header ================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Drawer item ================================

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(44, 10, 16, 10),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dividers ================================

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 16,
      indent: 16,
      endIndent: 16,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
