library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class VaultGrid extends StatelessWidget {
  const VaultGrid({
    super.key,
    required this.vaultItems,
    required this.subjects,
    required this.onSubjectTap,
  });

  final List<FormulaVaultItem> vaultItems;
  final List<Subject> subjects;
  final void Function(Subject subject) onSubjectTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colorScheme = Theme.of(context).colorScheme;
        final width = constraints.maxWidth;
        final crossAxisCount = Responsive.gridColumns(
          width,
          mobile: 2,
          tablet: 3,
          desktop: 4,
          wideDesktop: 6,
        );
        final totalCount = vaultItems.length + 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppDimensions.paddingMD,
            crossAxisSpacing: AppDimensions.paddingMD,
            childAspectRatio: AppDimensions.vaultGridAspectRatio,
          ),
          itemCount: totalCount,
          itemBuilder: (context, index) {
            if (index >= vaultItems.length) {
              return Material(
                color: AppColors.transparent,
                child: InkWell(
                  onTap: () {
                    StatefulNavigationShell.of(context).goBranch(3);
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                      border: Border.all(
                        color: colorScheme.surfaceContainerHighest,
                        width: AppDimensions.borderWidth,
                      ),
                      boxShadow: const [AppShadows.subtle],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.plus,
                          size: AppDimensions.iconLG,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(height: AppDimensions.paddingXXS),
                        Text(
                          'Add',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: colorScheme.outline,
                            fontSize: AppDimensions.fontSizeXS,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            final item = vaultItems[index];
            return Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () => _navigateFromVaultItem(context, item),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingLG),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    border: Border.all(color: colorScheme.surfaceContainerHigh),
                    boxShadow: const [AppShadows.subtle],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: AppDimensions.fontSizeXS,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXS),
                      Text(
                        item.title,
                        style: AppTextStyles.labelLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateFromVaultItem(BuildContext context, FormulaVaultItem item) {
    Subject? subject;
    for (final s in subjects) {
      if (s.id == item.id) {
        subject = s;
        break;
      }
    }

    if (subject != null) {
      onSubjectTap(subject);
      return;
    }

    StatefulNavigationShell.of(context).goBranch(3);
  }
}
