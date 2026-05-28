import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

class HelpHeroCard extends StatelessWidget {
  const HelpHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: signatureGlowDecoration(colorScheme),
      child: Column(
        children: [
          Container(
            width: AppDimensions.avatarHero,
            height: AppDimensions.avatarHero,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(
                alpha: AppDimensions.opacitySubtle,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.helpCircle,
              size: AppDimensions.iconXXL,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            context.l10n.helpHeroTitle,
            style: AppTextStyles.headlineSmall.copyWith(
              color: colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            context.l10n.helpHeroSubtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onPrimary.withValues(
                alpha: AppDimensions.opacityHigh,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
