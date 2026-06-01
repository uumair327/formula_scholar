import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';

/// A full-width dummy search bar that routes the user to the dedicated SearchPage.
/// This provides a prominent, enterprise-grade search affordance.
class DummySearchPill extends StatelessWidget implements PreferredSizeWidget {
  const DummySearchPill({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.paddingXL,
        right: AppDimensions.paddingXL,
        bottom: AppDimensions.paddingMD,
        top: AppDimensions.paddingXS,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pushNamed(AppRoutes.searchName),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMD,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.search,
                  color: colorScheme.onSurfaceVariant,
                  size: AppDimensions.iconSM,
                ),
                const SizedBox(width: AppDimensions.paddingSM),
                Expanded(
                  child: Text(
                    l10n.searchFormulas,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
