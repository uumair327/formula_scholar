library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'vault_grid.dart';

class FormulaVaultSection extends StatelessWidget {
  const FormulaVaultSection({
    super.key,
    required this.description,
    required this.vaultItems,
    required this.subjects,
    required this.onVaultItemTap,
  });

  final String description;
  final List<FormulaVaultItem> vaultItems;
  final List<Subject> subjects;
  final void Function(Subject subject) onVaultItemTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      border: Border.all(color: colorScheme.surfaceContainerHigh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                  boxShadow: const [AppShadows.subtle],
                ),
                child: Icon(
                  LucideIcons.folderOpen,
                  size: AppDimensions.iconLG,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.dashboardFormulaVault,
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: AppDimensions.paddingXXS),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          if (vaultItems.isEmpty)
            _buildVaultEmptyState(context)
          else
            VaultGrid(
              vaultItems: vaultItems,
              subjects: subjects,
              onVaultItemTap: onVaultItemTap,
            ),
        ],
      ),
    );
  }

  Widget _buildVaultEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSection,
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.folderOpen,
            size: AppDimensions.iconDecorative,
            color: colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            'No formulas yet',
            style: AppTextStyles.titleLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            'Select a subject to start learning',
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
