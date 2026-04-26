import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';

/// Reusable card-level action row with label and trailing chevron icon.
///
/// Used in dashboard subject cards (e.g. "Enter Lab ›", "Explore Elements ›")
/// and geometry topic cards (e.g. "View Topics ›").
class AppActionRow extends StatelessWidget {
  const AppActionRow({
    super.key,
    required this.label,
    this.color = AppColors.primary,
    this.onTap,
    this.trailingIcon = LucideIcons.chevronRight,
  });

  /// Action label text.
  final String label;

  /// Colour applied to both text and chevron icon.
  final Color color;

  /// Callback when the row is tapped.
  final VoidCallback? onTap;

  /// Trailing icon. Defaults to [LucideIcons.chevronRight].
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.labelLarge.copyWith(color: color)),
          const SizedBox(width: AppDimensions.paddingXS),
          Icon(trailingIcon, size: AppDimensions.iconMD, color: color),
        ],
      ),
    );
  }
}
