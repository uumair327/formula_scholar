import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

class QuizHeader extends StatelessWidget {
  const QuizHeader({super.key, required this.photoUrl});
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingSM,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => StatefulNavigationShell.of(context).goBranch(1),
            icon: const Icon(LucideIcons.x, size: AppDimensions.iconLG),
            tooltip: AppStrings.closeQuiz,
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            AppStrings.formulaFlow,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: AppDimensions.letterSpacingTight,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          photoUrl.isNotEmpty
              ? AppAvatar(
                  imageUrl: photoUrl,
                  size: AppDimensions.avatarSM,
                  fallbackIcon: LucideIcons.userCircle,
                  fallbackIconColor: colorScheme.primary,
                )
              : Icon(
                  LucideIcons.userCircle,
                  size: AppDimensions.iconLG,
                  color: colorScheme.primary,
                ),
        ],
      ),
    );
  }
}
