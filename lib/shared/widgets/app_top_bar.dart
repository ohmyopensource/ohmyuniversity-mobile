import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/app_routes.dart';
import 'profile_switcher.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  // TODO: replace with real profiles from auth provider
  static const _mockProfiles = [
    StudentProfile(
      name: 'Mario Rossi',
      email: 'mario.rossi@studenti.unimi.it',
      degreeType: DegreeType.triennale,
      isActive: true,
    ),
    StudentProfile(
      name: 'Mario Rossi',
      email: 'mario.rossi@studenti.unimi.it',
      degreeType: DegreeType.magistrale,
    ),
    StudentProfile(
      name: 'Mario Rossi',
      email: 'mario.rossi@studenti.unimi.it',
      degreeType: DegreeType.rinuncia,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background pill ================================
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(28),
              ),
            ),

            // Icons row ================================
            Row(
              children: [
                // Profile
                _TopBarIcon(
                  icon: Icons.account_circle_outlined,
                  tooltip: 'Profile',
                  onTap: () => showProfileSwitcher(
                    context,
                    profiles: _mockProfiles,
                    onAddAccount: () {
                      // TODO: trigger add account flow
                    },
                    onLogout: () {
                      // TODO: trigger logout use case
                    },
                  ),
                ),

                // Search
                _TopBarIcon(
                  icon: Icons.search,
                  tooltip: 'Search',
                  onTap: () {
                    // TODO: open search
                  },
                ),

                const Spacer(),

                // Favourites
                _TopBarIcon(
                  icon: Icons.favorite_border,
                  tooltip: 'Favourites',
                  onTap: () => context.pushNamed(AppRoutes.preferitiName),
                ),

                // Drawer
                _TopBarIcon(
                  icon: Icons.menu,
                  tooltip: 'Menu',
                  onTap: () => scaffoldKey.currentState?.openEndDrawer(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBarIcon extends StatelessWidget {
  const _TopBarIcon({
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

    Widget iconWidget = Icon(
      icon,
      color: colorScheme.onSurfaceVariant,
      size: 24,
    );

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(14), child: iconWidget),
      ),
    );
  }
}
