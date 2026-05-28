import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

/// Empty state when no subject is selected.
class NoSubjectSelectedState extends StatelessWidget {
  const NoSubjectSelectedState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingSection),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.bookOpen,
              size: AppDimensions.iconHero,
              color: colorScheme.outline.withValues(
                alpha: AppDimensions.opacityMedium,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            Text(
              context.l10n.selectSubjectTitle,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              context.l10n.selectSubjectDesc,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
