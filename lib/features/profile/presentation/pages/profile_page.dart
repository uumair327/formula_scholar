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
          return const Scaffold(body: ProfileShimmer());
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
          body: RefreshIndicator(
            onRefresh: () =>
                context.read<ProfileCubit>().loadProfile(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= AppDimensions.breakpointDesktop;
                final hp = isDesktop
                    ? ((constraints.maxWidth - AppDimensions.breakpointMaxContent) / 2).clamp(
                        AppDimensions.paddingSectionLG, double.infinity,
                      )
                    : AppDimensions.paddingXL;
                return CustomScrollView(
                  slivers: [
                    _buildAppBar(context, state, displayName),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: AppDimensions.paddingLG),
                          if (state.profile != null)
                            EntranceWrapper.stagger(
                              index: 0,
                              child: ProfileHeroWidget(profile: state.profile!),
                            ),
                          const SizedBox(height: AppDimensions.paddingHero),
                          EntranceWrapper.stagger(
                            index: 1,
                            child: ProgressStatsWidget(
                              stats: state.stats,
                              displayName: displayName,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingHero),
                          EntranceWrapper.stagger(
                            index: 2,
                            child: BlocBuilder<ThemeCubit, ThemeState>(
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
                          ),
                          const SizedBox(height: AppDimensions.bottomNavPadding),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  SliverGlassAppBar _buildAppBar(
    BuildContext context,
    ProfileState state,
    String displayName,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarUrl = state.profile?.avatarUrl ?? AppAssets.profileAvatarUrl;

    return SliverGlassAppBar(
      titleWidget: Row(
        children: [
          // Gradient ring avatar
          Container(
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
              child: AppAvatar(
                imageUrl: avatarUrl,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (state.profile?.email.isNotEmpty == true)
                  Text(
                    state.profile!.email,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: AppDimensions.paddingSM),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: IconButton(
            onPressed: () => ProfileInsightsSheet.show(
              context,
              displayName: state.profile?.name ?? AppStrings.welcomeScholar,
              stats: state.stats,
            ),
            icon: Icon(LucideIcons.barChart2, color: colorScheme.primary),
          ),
        ),
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
      case 'study_planner':
        context.pushNamed(AppRoutes.studyPlannerName);
        return;
      case 'achievements':
        context.pushNamed(AppRoutes.achievementsName);
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
