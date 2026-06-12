import 'package:flutter/material.dart';

// Degree type enum ================================

enum DegreeType {
  triennale('L', 'Bachelor'),
  magistrale('LM', 'Master'),
  magistraleACicloUnico('LMU', 'Single-cycle Master'),
  dottorato('PhD', 'PhD'),
  masterPrimoLivello('M1', 'Master I'),
  masterSecondoLivello('M2', 'Master II'),
  rinuncia('L', 'Withdrawn', isWithdrawn: true);

  const DegreeType(this.badge, this.label, {this.isWithdrawn = false});

  final String badge;
  final String label;
  final bool isWithdrawn;
}

// Profile data model ================================

class StudentProfile {
  const StudentProfile({
    required this.name,
    required this.email,
    required this.degreeType,
    this.isActive = false,
    this.avatarUrl,
  });

  final String name;
  final String email;
  final DegreeType degreeType;
  final bool isActive;
  final String? avatarUrl;
}

// Public entry point ================================

void showProfileSwitcher(
  BuildContext context, {
  required List<StudentProfile> profiles,
  required VoidCallback onAddAccount,
  required VoidCallback onLogout,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'ProfileSwitcher',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          alignment: Alignment.topLeft,
          child: child,
        ),
      );
    },
    pageBuilder: (_, _, _) => _ProfileSwitcherOverlay(
      profiles: profiles,
      onAddAccount: onAddAccount,
      onLogout: onLogout,
    ),
  );
}

// Overlay widget ================================

class _ProfileSwitcherOverlay extends StatelessWidget {
  const _ProfileSwitcherOverlay({
    required this.profiles,
    required this.onAddAccount,
    required this.onLogout,
  });

  final List<StudentProfile> profiles;
  final VoidCallback onAddAccount;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 72, 48, 0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile list ================================
                ...profiles.map(
                  (profile) => _ProfileTile(
                    profile: profile,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1),
                ),

                // Bottom actions ================================
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Add account
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.add_circle_outline,
                          label: 'Add account',
                          onTap: () {
                            Navigator.of(context).pop();
                            onAddAccount();
                          },
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        width: 1,
                        height: 36,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),

                      const SizedBox(width: 8),

                      // Logout
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.logout,
                          label: 'Logout',
                          color: Theme.of(context).colorScheme.error,
                          onTap: () {
                            Navigator.of(context).pop();
                            onLogout();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Single profile row ================================

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.profile, required this.onTap});

  final StudentProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar with optional active ring
            _ProfileAvatar(
              avatarUrl: profile.avatarUrl,
              name: profile.name,
              isActive: profile.isActive,
              isWithdrawn: profile.degreeType.isWithdrawn,
            ),

            const SizedBox(width: 12),

            // Name + email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    profile.email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Degree badge
            _DegreeBadge(type: profile.degreeType),
          ],
        ),
      ),
    );
  }
}

// Avatar ================================

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.name,
    required this.isActive,
    required this.isWithdrawn,
    this.avatarUrl,
  });

  final String name;
  final bool isActive;
  final bool isWithdrawn;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final avatar = CircleAvatar(
      radius: 22,
      backgroundColor: colorScheme.surfaceContainerHigh,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child: avatarUrl == null
          ? Icon(Icons.person, size: 22, color: colorScheme.onSurfaceVariant)
          : null,
    );

    if (!isActive) return avatar;

    // Green ring for active profile
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.green, width: 2.5),
      ),
      child: avatar,
    );
  }
}

// Degree type badge ================================

class _DegreeBadge extends StatelessWidget {
  const _DegreeBadge({required this.type});

  final DegreeType type;

  Color _badgeColor(ColorScheme cs) {
    if (type.isWithdrawn) return cs.surfaceContainerHighest;
    return switch (type) {
      DegreeType.triennale => const Color(0xFF1A73E8),
      DegreeType.magistrale => const Color(0xFFE8710A),
      DegreeType.magistraleACicloUnico => const Color(0xFF9C27B0),
      DegreeType.dottorato => const Color(0xFF1E8E3E),
      DegreeType.masterPrimoLivello => const Color(0xFF00ACC1),
      DegreeType.masterSecondoLivello => const Color(0xFF00897B),
      _ => cs.surfaceContainerHighest,
    };
  }

  Color _textColor(ColorScheme cs) {
    if (type.isWithdrawn) return cs.onSurfaceVariant;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _badgeColor(colorScheme),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type.badge,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: _textColor(colorScheme),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// Bottom action button ================================
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: effectiveColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
