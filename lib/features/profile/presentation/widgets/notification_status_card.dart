import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';

class NotificationStatusCard extends StatelessWidget {
  const NotificationStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: signatureGlowDecoration(colorScheme),
      child: Row(
        children: [
          Container(
            width: AppDimensions.avatarLG,
            height: AppDimensions.avatarLG,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(
                alpha: AppDimensions.opacitySubtle,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.bellRing,
              size: AppDimensions.iconLG,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.notificationsEnabled,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  AppStrings.notificationsEnabledDesc,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onPrimary.withValues(
                      alpha: AppDimensions.opacityHigh,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
