import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class OrientationPathCard extends StatefulWidget {
  const OrientationPathCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.animationAsset,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String animationAsset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<OrientationPathCard> createState() => _OrientationPathCardState();
}

class _OrientationPathCardState extends State<OrientationPathCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isActive = widget.isSelected || _isPressed;

    final borderColor = isActive
        ? colorScheme.primary
        : colorScheme.outlineVariant;

    final contentOpacity = isActive ? 1.0 : 0.58;
    final backgroundColor = isActive
        ? colorScheme.surface
        : Color.alphaBlend(
            Colors.grey.withValues(alpha: 0.06),
            colorScheme.surface,
          );

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 172),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor, width: isActive ? 1.6 : 1),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Opacity(
          opacity: contentOpacity,
          child: Row(
            children: [
              SizedBox(
                width: 92,
                height: 92,
                child: Lottie.asset(
                  widget.animationAsset,
                  fit: BoxFit.contain,
                  repeat: false,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isActive
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                        shadows: isActive
                            ? [
                                Shadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.18,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      maxLines: 4,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.16,
                        color: isActive
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                LucideIcons.chevronRight,
                size: 24,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
