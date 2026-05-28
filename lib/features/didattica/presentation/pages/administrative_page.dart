import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';

class AdministrativePage extends StatelessWidget {
  const AdministrativePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Amministrativa')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
        physics: const BouncingScrollPhysics(),
        children: const [
          _AdministrativeActionButton(
            title: 'Scadenze',
            icon: LucideIcons.clock3,
            accentColor: Color(0xFF357266),
            accentBackgroundColor: Color(0xFFEFFFEE),
          ),
          SizedBox(height: 10),
          _AdministrativeActionButton(
            title: 'Bandi',
            icon: LucideIcons.megaphone,
            accentColor: Color(0xFF0E3B43),
            accentBackgroundColor: Color(0xFFEEFDFF),
          ),
          SizedBox(height: 10),
          _AdministrativeActionButton(
            title: 'Borse di studio',
            icon: LucideIcons.coins,
            accentColor: Color(0xFFF5B700),
            accentBackgroundColor: Color(0xFFFFFCE6),
          ),
          SizedBox(height: 10),
          _AdministrativeActionButton(
            title: 'Documenti scaricabili',
            icon: LucideIcons.fileDown,
            accentColor: Color(0xFF14185E),
            accentBackgroundColor: Color(0xFFE7FBFF),
          ),
          SizedBox(height: 10),
          _AdministrativeActionButton(
            title: 'Segreteria didattica',
            icon: LucideIcons.messagesSquare,
            accentColor: Color(0xFFB829D5),
            accentBackgroundColor: Color(0xFFF7E7FF),
          ),
        ],
      ),
    );
  }
}

class _AdministrativeActionButton extends StatelessWidget {
  const _AdministrativeActionButton({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.accentBackgroundColor,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
  final Color accentBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showPlaceholderFeedback(context, title),
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.textPrimary.withValues(alpha: 0.42),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlaceholderFeedback(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$title in arrivo'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
