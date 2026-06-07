import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../../../auth/auth.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/account/delete_account_dialog.dart';
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
        final displayName = state.profile?.name ?? context.l10n.welcomeScholar;

        if (state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.initial) {
          return const Scaffold(body: ProfileShimmer());
        }

        if (state.status == ProfileStatus.error) {
          return Scaffold(
            body: AppErrorState(
              message: context.localizedError(
                errorKey: state.errorKey,
                fallback: state.errorMessage,
              ),
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            ),
          );
        }

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => context.read<ProfileCubit>().loadProfile(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop =
                    constraints.maxWidth >= AppDimensions.breakpointDesktop;
                final hp = isDesktop
                    ? ((constraints.maxWidth -
                                  AppDimensions.breakpointMaxContent) /
                              2)
                          .clamp(
                            AppDimensions.paddingSectionLG,
                            double.infinity,
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
                                final allItems = state.settingsItems;

                                final appFeatures = allItems.where((item) =>
                                    ['account', 'bookmarks', 'study_planner', 'achievements']
                                        .contains(item.id)).toList();
                                        
                                final preferences = allItems.where((item) =>
                                    ['notifications', 'language', 'appearance']
                                        .contains(item.id)).toList();
                                        
                                final supportInfo = allItems.where((item) =>
                                    ['help', 'about'].contains(item.id)).toList();
                                    
                                final dangerZone = allItems.where((item) =>
                                    ['logout'].contains(item.id)).toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SettingsListWidget(
                                      title: context.l10n.accountInformation,
                                      items: appFeatures,
                                      isDarkMode: themeState.isDarkMode,
                                      startIndex: 3,
                                      onDarkModeToggle: () {},
                                      onItemTapped: (id) =>
                                          _handleSettingsNavigation(context, id),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingXXL),
                                    SettingsListWidget(
                                      title: context.l10n.preferences,
                                      items: preferences,
                                      isDarkMode: themeState.isDarkMode,
                                      startIndex: 8,
                                      onDarkModeToggle: () {
                                        context.read<ThemeCubit>().toggleTheme();
                                      },
                                      onItemTapped: (id) =>
                                          _handleSettingsNavigation(context, id),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingXXL),
                                    SettingsListWidget(
                                      title: context.l10n.supportAndAbout,
                                      items: supportInfo,
                                      isDarkMode: themeState.isDarkMode,
                                      startIndex: 12,
                                      onDarkModeToggle: () {},
                                      onItemTapped: (id) =>
                                          _handleSettingsNavigation(context, id),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingXXL),
                                    SettingsListWidget(
                                      title: context.l10n.dangerZone,
                                      items: dangerZone,
                                      isDarkMode: themeState.isDarkMode,
                                      startIndex: 15,
                                      onDarkModeToggle: () {},
                                      onItemTapped: (id) =>
                                          _handleSettingsNavigation(context, id),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: AppDimensions.bottomNavPadding,
                          ),
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

    return SliverGlassAppBar(
      titleWidget: Text(
        context.l10n.navProfile,
        style: AppTextStyles.headlineSmall.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
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
            onPressed: () => ProfileInsightsSheet.show(
              context,
              displayName: state.profile?.name ?? context.l10n.welcomeScholar,
              stats: state.stats,
            ),
            icon: Icon(LucideIcons.barChart2, color: colorScheme.primary),
            tooltip: context.l10n.viewInsights,
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(
            end: AppDimensions.paddingSM,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: IconButton(
            onPressed: () => context.push(AppRoutes.accountInfoPath),
            icon: Icon(
              LucideIcons.settings,
              color: colorScheme.onSurfaceVariant,
            ),
            tooltip: context.l10n.settings,
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
      case 'language':
        context.push(AppRoutes.languageLocalizationPath);
        return;
      case 'help':
        context.push(AppRoutes.helpSupportPath);
        return;
      case 'about':
        context.push(AppRoutes.aboutAppPath);
        return;
      case 'change_password':
        final state = context.read<ProfileCubit>().state;
        showForgotPasswordDialog(context, state.profile?.email ?? '');
        return;
      case 'logout':
        _handleLogout(context);
        return;
      case 'delete_account':
        DeleteAccountDialog.show(context);
        return;
      default:
        return;
    }
  }

  /// Handles sign-out via [AuthCubit] resolved from DI.
  Future<void> _handleLogout(BuildContext context) async {
    await context.read<AuthCubit>().signOut();
    if (context.mounted) {
      context.read<CurriculumCubit>().clear();
      context.go(AppRoutes.loginPath);
    }
  }
}
