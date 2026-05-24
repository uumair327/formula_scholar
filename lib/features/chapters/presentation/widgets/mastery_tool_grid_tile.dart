import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

class MasteryToolGridTile extends StatelessWidget {
  const MasteryToolGridTile({
    super.key,
    required this.tool,
    required this.onTap,
  });

  final MasteryTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = _iconFor(tool.iconName);
    final color = _colorFor(tool.iconName);
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        boxShadow: const [AppShadows.subtle],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppDimensions.iconXXL, color: color),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              tool.label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _iconFor(String iconName) {
    switch (iconName) {
      case 'graduationCap':
        return LucideIcons.graduationCap;
      case 'helpCircle':
        return LucideIcons.helpCircle;
      case 'fileText':
        return LucideIcons.fileText;
      case 'creditCard':
        return LucideIcons.creditCard;
      case 'box':
        return LucideIcons.box;
      default:
        return LucideIcons.sparkles;
    }
  }

  static Color _colorFor(String iconName) {
    switch (iconName) {
      case 'graduationCap':
        return AppColors.primary;
      case 'helpCircle':
        return AppColors.secondary;
      case 'fileText':
        return AppColors.orange500;
      case 'creditCard':
        return AppColors.secondary;
      case 'box':
        return AppColors.tertiary;
      default:
        return AppColors.primary;
    }
  }
}
