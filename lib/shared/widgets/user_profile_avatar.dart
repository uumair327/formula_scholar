import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';
import '../../features/auth/auth.dart';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.user != curr.user,
      builder: (context, authState) {
        final user = authState.user;
        final photoUrl = user?.photoUrl ?? AppAssets.dashboardStudentProfileUrl;

        return GestureDetector(
          onTap: onTap ?? () => context.go(AppRoutes.profilePath),
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: const EdgeInsetsDirectional.only(
              end: AppDimensions.paddingSM,
            ),
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDark
                  ? AppColors.darkPrimaryGradient
                  : AppColors.primaryGradient,
            ),
            child: Container(
              width: AppDimensions.avatarMD - 4,
              height: AppDimensions.avatarMD - 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface,
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) =>
                    Icon(LucideIcons.user, color: colorScheme.primary),
              ),
            ),
          ),
        );
      },
    );
  }
}
