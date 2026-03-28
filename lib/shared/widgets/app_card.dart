import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Reusable ghost-shadow card container used across the app.
///
/// Wraps its child in the standard surface card styling with the
/// ghost shadow, rounded corners, and optional padding. Replaces
/// inline Container + ghostShadowDecoration usage.
class AppCard extends StatelessWidget {
  /// Child widget rendered inside the card.
  final Widget child;

  /// Card background colour.
  final Color color;

  /// Corner radius.
  final double borderRadius;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Optional box shadow override.
  final List<BoxShadow> boxShadow;

  /// Optional border.
  final BoxBorder? border;

  /// Clip behaviour for content that overflows the rounded corners.
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.color = AppColors.surfaceContainerLowest,
    this.borderRadius = AppDimensions.radiusLG,
    this.padding = const EdgeInsets.all(AppDimensions.paddingXL),
    this.boxShadow = const [AppShadows.ghost],
    this.border,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

/// Reusable section title row with bold title and optional action label.
///
/// Identical to [SectionHeader] but with a more flexible API: supports
/// custom title style and leading icon.
class AppSectionTitle extends StatelessWidget {
  /// Section title text.
  final String title;

  /// Optional trailing action label.
  final String? actionLabel;

  /// Callback when the action label is tapped.
  final VoidCallback? onAction;

  /// Optional leading icon.
  final IconData? leadingIcon;

  /// Colour of the leading icon.
  final Color leadingIconColor;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.leadingIcon,
    this.leadingIconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon,
                    size: AppDimensions.iconLG, color: leadingIconColor),
                const SizedBox(width: AppDimensions.paddingSM),
              ],
              Text(
                title,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
