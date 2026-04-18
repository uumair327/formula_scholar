import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

/// Bottom sheet for support contact actions.
class SupportContactSheet extends StatelessWidget {

  const SupportContactSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.email,
  });
  final String title;
  final String subtitle;
  final String email;

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String email,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          SupportContactSheet(title: title, subtitle: subtitle, email: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXXL),
          topRight: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingLG,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: AppDimensions.avatarMD,
                height: AppDimensions.borderWidthThick,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            Row(
              children: [
                const AppIconCircle(
                  icon: LucideIcons.messageCircle,
                  size: AppDimensions.avatarHero,
                  backgroundColor: AppColors.primaryFixed,
                  iconColor: AppColors.primary,
                  iconSize: AppDimensions.iconXL,
                ),
                const SizedBox(width: AppDimensions.paddingLG),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXS),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            AppCard(
              border: Border.all(color: AppColors.surfaceContainerHigh),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.mail,
                    color: AppColors.primary,
                    size: AppDimensions.iconMD,
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: Text(
                      email,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: email));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Copied $email')));
                    },
                    child: const Text('Copy'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            AppCard(
              color: AppColors.primaryFixed.withValues(
                alpha: AppDimensions.opacityLight,
              ),
              border: Border.all(color: AppColors.primaryFixed),
              child: Text(
                'If you are blocked anywhere in the app, use the FAQ section first and then contact support with the exact screen name.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Center(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
          ],
        ),
      ),
    );
  }
}
