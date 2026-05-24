library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

class NoSearchResultsState extends StatelessWidget {
  const NoSearchResultsState({required this.onClearSearch, super.key});

  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXL),
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          children: [
            Icon(
              LucideIcons.searchX,
              size: AppDimensions.iconXL,
              color: colorScheme.outline,
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Text(
              AppStrings.noBookmarksFoundTitle,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              AppStrings.noBookmarksFoundDesc,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            OutlinedButton(
              onPressed: onClearSearch,
              child: const Text(AppStrings.clearSearch),
            ),
          ],
        ),
      ),
    );
  }
}
