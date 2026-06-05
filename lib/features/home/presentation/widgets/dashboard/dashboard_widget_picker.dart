import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../models/dashboard_widget_option.dart';
import 'dashboard_widget_content.dart';

class DashboardWidgetPicker extends StatelessWidget {
  const DashboardWidgetPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 430,
                  maxHeight: 660,
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: AppColors.textPrimary.withValues(alpha: 0.06),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.13),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Aggiungi alla home',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        shadows: _titleShadows,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: DashboardWidgetOptions.all.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          final option = DashboardWidgetOptions.all[index];

                          return _DashboardWidgetPreviewTile(
                            option: option,
                            onSelected: () {
                              HapticFeedback.mediumImpact();
                              Navigator.of(context).pop(option);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardWidgetPreviewTile extends StatelessWidget {
  const _DashboardWidgetPreviewTile({
    required this.option,
    required this.onSelected,
  });

  final DashboardWidgetOption option;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onLongPress: onSelected,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: option.size.width,
                  height: option.size.height,
                  child: DashboardWidgetContent(option: option, preview: true),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                option.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  shadows: _titleShadows,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _titleShadows = [
  Shadow(color: Color(0x26000000), blurRadius: 3, offset: Offset(0, 1.2)),
];
