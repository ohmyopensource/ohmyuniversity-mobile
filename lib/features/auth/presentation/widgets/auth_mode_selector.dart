import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

enum AuthFormMode { login, register }

class AuthModeSelector extends StatelessWidget {
  const AuthModeSelector({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final AuthFormMode mode;
  final ValueChanged<AuthFormMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFD2E1F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeTab(
              label: 'Accedi',
              isSelected: mode == AuthFormMode.login,
              onTap: () => onChanged(AuthFormMode.login),
            ),
          ),
          Expanded(
            child: _ModeTab(
              label: 'Registrati',
              isSelected: mode == AuthFormMode.register,
              onTap: () => onChanged(AuthFormMode.register),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected ? AppColors.background : Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textPrimary.withValues(alpha: 0.42),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
