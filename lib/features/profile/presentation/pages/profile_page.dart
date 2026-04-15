import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_hero_widget.dart';
import '../widgets/profile_insights_sheet.dart';
import '../widgets/progress_stats_widget.dart';
import '../widgets/settings_list_widget.dart';

/// Profile page – account screen assembling all profile widgets.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        final displayName = state.profile?.name ?? AppStrings.welcomeScholar;

        if (state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.initial) {
          return const Scaffold(body: AppLoadingState());
        }

        if (state.status == ProfileStatus.error) {
          return Scaffold(
            body: AppErrorState(
              message: state.errorMessage,
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, state, displayName),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXL,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppDimensions.paddingLG),
                    if (state.profile != null)
                      ProfileHeroWidget(profile: state.profile!),
                    const SizedBox(height: AppDimensions.paddingHero),
                    ProgressStatsWidget(
                      stats: state.stats,
                      displayName: displayName,
                    ),
                    const SizedBox(height: AppDimensions.paddingHero),
                    BlocBuilder<ThemeCubit, ThemeState>(
                      buildWhen: (prev, curr) =>
                          prev.isDarkMode != curr.isDarkMode,
                      builder: (context, themeState) {
                        return SettingsListWidget(
                          items: state.settingsItems,
                          isDarkMode: themeState.isDarkMode,
                          onDarkModeToggle: () {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                          onItemTapped: (id) =>
                              _handleSettingsNavigation(context, id),
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.bottomNavPadding),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildAppBar(
    BuildContext context,
    ProfileState state,
    String displayName,
  ) {
    final avatarUrl = state.profile?.avatarUrl ?? AppAssets.profileAvatarUrl;

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      title: Row(
        children: [
          AppAvatar(
            imageUrl: avatarUrl,
            border: Border.all(
              color: AppColors.primaryContainer,
              width: AppDimensions.borderWidth,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.blue900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (state.profile?.email.isNotEmpty == true)
                  Text(
                    state.profile!.email,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => ProfileInsightsSheet.show(
            context,
            displayName: state.profile?.name ?? AppStrings.welcomeScholar,
            stats: state.stats,
          ),
          icon: const Icon(LucideIcons.barChart2, color: AppColors.blue600),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }

  /// Routes settings item taps to the appropriate page or action.
  void _handleSettingsNavigation(BuildContext context, String id) {
    switch (id) {
      case 'account':
        context.push(AppRoutes.accountInfoPath);
        return;
      case 'bookmarks':
        StatefulNavigationShell.of(context).goBranch(3);
        return;
      case 'notifications':
        context.push(AppRoutes.notificationsPath);
        return;
      case 'help':
        context.push(AppRoutes.helpSupportPath);
        return;
      case 'logout':
        _handleLogout(context);
        return;
      default:
        return;
    }
  }

  /// Handles sign-out via [AuthCubit] resolved from DI.
  Future<void> _handleLogout(BuildContext context) async {
    await context.read<AuthCubit>().signOut();

    if (context.mounted) {
      context.go(AppRoutes.loginPath);
    }
  }
}
