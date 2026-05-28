import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

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
    final color = _colorFor(tool.iconName, context);
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

  static Color _colorFor(String iconName, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (iconName) {
      case 'graduationCap':
        return colorScheme.primary;
      case 'helpCircle':
        return colorScheme.secondary;
      case 'fileText':
        return AppColors.orange500;
      case 'creditCard':
        return colorScheme.secondary;
      case 'box':
        return colorScheme.tertiary;
      default:
        return colorScheme.primary;
    }
  }
}
