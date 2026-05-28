library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class ProTipBanner extends StatelessWidget {
  const ProTipBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      boxShadow: const [AppShadows.subtle],
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.tertiaryContainer.withValues(alpha: 0.1),
              colorScheme.tertiaryContainer.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIconCircle(
              icon: LucideIcons.lightbulb,
              backgroundColor: colorScheme.tertiaryContainer,
              iconColor: colorScheme.onTertiaryContainer,
              size: 40,
            ),
            const SizedBox(width: AppDimensions.paddingLG),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.proTip,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? colorScheme.tertiary
                          : colorScheme.onTertiaryContainer,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    context.l10n.proTipContent,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: AppDimensions.lineHeightDefault,
                    ),
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
