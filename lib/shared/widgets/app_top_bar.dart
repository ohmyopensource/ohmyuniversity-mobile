import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/routes/app_routes.dart';
import '../../config/theme/app_colors.dart';
import 'profile_switcher.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppTopBar({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Size get preferredSize => const Size.fromHeight(78);

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
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.secondary.withValues(alpha: 0.38),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.92),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              _TopBarGroup(
                children: [
                  _TopBarAction(
                    icon: LucideIcons.userCircle,
                    tooltip: 'Profile',
                    onTap: () => showProfileSwitcher(
                      context,
                      profiles: _mockProfiles,
                      onAddAccount: () {},
                        onLogout: () {
                          ref.read(isAuthenticatedProvider.notifier).setAuthenticated(false);
                          context.goNamed(AppRoutes.loginName);
                        },
                    ),
                  ),
                  const SizedBox(width: 14),
                  _TopBarAction(
                    icon: LucideIcons.search,
                    tooltip: 'Search',
                    hasSoftBackground: true,
                    onTap: () {},
                  ),
                ],
              ),
              const Spacer(),
              _TopBarGroup(
                children: [
                  _TopBarAction(
                    icon: LucideIcons.heart,
                    tooltip: 'Favourites',
                    onTap: () => context.pushNamed(AppRoutes.preferitiName),
                  ),
                  const SizedBox(width: 14),
                  _TopBarAction(
                    icon: LucideIcons.menu,
                    tooltip: 'Menu',
                    onTap: () => scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBarGroup extends StatelessWidget {
  const _TopBarGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}

class _TopBarAction extends StatelessWidget {
  const _TopBarAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.hasSoftBackground = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool hasSoftBackground;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: hasSoftBackground
                  ? AppColors.textPrimary.withValues(alpha: 0.06)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 23),
          ),
        ),
      ),
    );
  }
}
