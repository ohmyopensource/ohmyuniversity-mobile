import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../config/routes/app_routes.dart';
import '../../config/theme/app_colors.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../widgets/avatar_profile_panel/avatar_profile_panel_widget.dart';

class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppTopBar({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Size get preferredSize => const Size.fromHeight(78);

  // Mock accounts — sostituire con dati reali dal provider utente
  static const _mockAccounts = [
    AccountEntry(
      id: '1',
      name: 'Mario Rossi',
      email: 'mario.rossi@studenti.unimi.it',
      courseLabel: 'Ingegneria Informatica',
      universityLabel: 'Università degli Studi di Milano',
      courseAcronym: 'LM',
      status: AccountStatus.active,
      isCurrent: true,
    ),
    AccountEntry(
      id: '2',
      name: 'Mario Rossi',
      email: 'mario.rossi@studenti.unimi.it',
      courseLabel: 'Informatica',
      universityLabel: 'Università degli Studi di Milano',
      courseAcronym: 'L',
      status: AccountStatus.graduated,
    ),
    AccountEntry(
      id: '3',
      name: 'Mario Rossi',
      email: 'mario.rossi@studenti.unimi.it',
      courseLabel: 'Fisica Teorica',
      universityLabel: 'Università degli Studi di Milano',
      courseAcronym: 'LM',
      status: AccountStatus.withdrawn,
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
              // ── Left group ──────────────────────────────────────────
              _TopBarGroup(
                children: [
                  // Avatar + panel dropdown — rimpiazza userCircle + showProfileSwitcher
                  AvatarProfilePanelWidget(
                    accounts: _mockAccounts,
                    position: PanelPosition.right,
                    animation: PanelAnimation.ios,
                    showSettings: true,
                    showLogout: true,
                    showAddAccount: false,
                    onAccountSwitch: (_) {},
                    onSettingsClick: () {},
                    onLogoutClick: () {
                      ref
                          .read(isAuthenticatedProvider.notifier)
                          .setAuthenticated(false);
                      context.goNamed(AppRoutes.loginName);
                    },
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

              // ── Right group ─────────────────────────────────────────
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

// ─── Internal widgets ─────────────────────────────────────────────────────────

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