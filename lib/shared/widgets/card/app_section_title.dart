import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../app_text.dart';

class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.leadingIcon,
    this.leadingIconColor,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? leadingIcon;
  final Color? leadingIconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    size: AppDimensions.iconLG,
                    color: leadingIconColor ?? colorScheme.primary,
                  ),
                  const SizedBox(width: AppDimensions.paddingSM),
                ],
                Expanded(
                  child: AppText(
                    title,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: AppText(
                actionLabel!,
                style: AppTextStyles.labelLarge.copyWith(
                  color: colorScheme.primary,
                ),
                maxLines: 1,
                softWrap: false,
              ),
            ),
        ],
      ),
    );
  }
}
