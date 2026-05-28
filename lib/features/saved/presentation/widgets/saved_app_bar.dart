library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../../../auth/auth.dart';

import '../cubit/saved_cubit.dart';

class SavedAppBar extends StatelessWidget {
  const SavedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.user != curr.user,
      builder: (context, authState) {
        final user = authState.user;
        final photoUrl = user?.photoUrl ?? '';

        return GlassAppBar(
          titleWidget: Row(
            children: [
              GestureDetector(
                onTap: () => context.go(AppRoutes.profilePath),
                behavior: HitTestBehavior.opaque,
                child: Container(
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
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 2.0,
                      ),
                    ),
                    child: photoUrl.isNotEmpty
                        ? AppAvatar(
                            imageUrl: photoUrl,
                            size: AppDimensions.avatarMD - 8,
                            fallbackIcon: LucideIcons.bookmark,
                            fallbackIconColor: colorScheme.primary,
                          )
                        : Icon(
                            LucideIcons.bookmark,
                            color: colorScheme.primary,
                            size: AppDimensions.iconSM,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMD),
              Text(
                context.l10n.navSaved,
                style: AppTextStyles.titleMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsetsDirectional.only(
                end: AppDimensions.paddingSM,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: IconButton(
                onPressed: () {
                  final curr = context.read<CurriculumCubit>().state.curriculum;
                  if (curr != null) {
                    context.read<SavedCubit>().loadBookmarks(
                      curriculumKey: curr.curriculumKey,
                    );
                  }
                },
                icon: Icon(LucideIcons.refreshCw, color: colorScheme.primary),
                tooltip: context.l10n.refreshBookmarks,
              ),
            ),
          ],
        );
      },
    );
  }
}
