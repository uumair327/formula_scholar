import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class CurriculumChip extends StatefulWidget {
  const CurriculumChip({
    super.key,
    required this.label,
    this.subtitle,
    required this.selected,
    this.onTap,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback? onTap;

  @override
  State<CurriculumChip> createState() => _CurriculumChipState();
}

class _CurriculumChipState extends State<CurriculumChip> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = widget.selected;

    return GestureDetector(
      onTap: () {
        HapticsHelper.lightImpact();
        widget.onTap?.call();
      },
      child: Semantics(
        label: widget.label,
        selected: selected,
        button: true,
        child: AnimatedContainer(
          duration: AppDurations.animationFast,
          curve: AppDurations.curveDefault,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingSM,
          ),
          decoration: BoxDecoration(
            gradient: selected
                ? (isDark ? AppColors.darkPrimaryGradient : AppColors.primaryGradient)
                : null,
            color: selected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            boxShadow: selected ? const [AppShadows.chip] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected)
                const Padding(
                  padding: EdgeInsets.only(
                    right: AppDimensions.paddingXS,
                  ),
                  child: Icon(
                    LucideIcons.check,
                    size: AppDimensions.iconSM,
                    color: AppColors.white,
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: selected
                          ? AppColors.white
                          : colorScheme.onSurface,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: selected
                            ? AppColors.white.withValues(
                                alpha: AppDimensions.opacityMedium,
                              )
                            : colorScheme.onSurfaceVariant,
                        fontSize: AppDimensions.fontSizeXS,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
