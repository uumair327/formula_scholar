import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/encouragement_card_widget.dart';
import '../widgets/profile_hero_widget.dart';
import '../widgets/progress_stats_widget.dart';
import '../widgets/settings_list_widget.dart';

/// Profile page – account screen assembling all profile widgets.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.initial) {
          return const Scaffold(body: AppLoadingState());
        }

        if (state.status == ProfileStatus.error) {
          return Scaffold(
            body: AppErrorState(
              message: state.errorMessage,
              onRetry: () =>
                  context.read<ProfileCubit>().loadProfile(),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, state),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppDimensions.paddingLG),
                    if (state.profile != null)
                      ProfileHeroWidget(profile: state.profile!),
                    const SizedBox(height: AppDimensions.paddingHero),
                    ProgressStatsWidget(stats: state.stats),
                    const SizedBox(height: AppDimensions.paddingHero),
                    SettingsListWidget(
                      items: state.settingsItems,
                      isDarkMode: state.isDarkMode,
                      onDarkModeToggle: () {
                        context.read<ProfileCubit>().toggleDarkMode();
                      },
                      onItemTapped: (id) {
                        context.read<ProfileCubit>().onSettingsTapped(id);
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingHero),
                    const EncouragementCardWidget(),
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

  SliverAppBar _buildAppBar(BuildContext context, ProfileState state) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor:
          AppColors.surfaceContainerLowest.withValues(alpha: AppDimensions.opacityAppBar),
      surfaceTintColor: AppColors.transparent,
      title: Row(
        children: [
          AppAvatar(
            imageUrl: AppAssets.profileAvatarUrl,
            border: Border.all(
              color: AppColors.primaryContainer,
              width: AppDimensions.borderWidth,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            AppStrings.welcomeScholar,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.blue900,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            AppLogger.debug('Leaderboard tapped',
                tag: AppLogTags.profilePage);
          },
          icon: const Icon(
            LucideIcons.barChart2,
            color: AppColors.blue600,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }
}
