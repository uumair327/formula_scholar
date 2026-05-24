import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/account/account_action_tile.dart';
import '../widgets/account/account_info_app_bar.dart';
import '../widgets/account/account_info_tile.dart';
import '../widgets/account/account_profile_card.dart';
import '../widgets/account/delete_account_dialog.dart';
import '../widgets/edit_profile_dialog.dart';

class AccountInformationPage extends StatelessWidget {
  const AccountInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (p, n) => p.profile != n.profile,
      builder: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;
        final profile = state.profile;

        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= AppDimensions.breakpointDesktop;
              final hp = isDesktop
                  ? ((constraints.maxWidth - AppDimensions.breakpointMaxContent) / 2).clamp(
                      AppDimensions.paddingSectionLG, double.infinity)
                  : AppDimensions.paddingXL;
              return CustomScrollView(
                slivers: [
                  const AccountInfoAppBar(),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: hp),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: AppDimensions.paddingXXL),
                        EntranceWrapper.stagger(index: 0, child: AccountProfileCard(profile: profile)),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        EntranceWrapper.stagger(index: 1, child: const AppSectionTitle(title: AppStrings.personalInfo)),
                        const SizedBox(height: AppDimensions.paddingLG),
                        EntranceWrapper.stagger(index: 2, child: AccountInfoTile(
                          icon: LucideIcons.user, label: AppStrings.fullName, value: profile?.name ?? AppStrings.welcomeScholar)),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(index: 3, child: AccountInfoTile(
                          icon: LucideIcons.mail, label: AppStrings.emailAddress, value: profile?.email ?? '—')),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        EntranceWrapper.stagger(index: 4, child: const AppSectionTitle(title: AppStrings.academicInfo)),
                        const SizedBox(height: AppDimensions.paddingLG),
                        EntranceWrapper.stagger(index: 5, child: AccountInfoTile(
                          icon: LucideIcons.graduationCap, label: AppStrings.currentGrade, value: profile?.grade ?? '—')),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(index: 6, child: AccountInfoTile(
                          icon: LucideIcons.award, label: AppStrings.accountType,
                          value: profile?.isPro == true ? AppStrings.proBadge : AppStrings.freeAccount,
                          valueColor: profile?.isPro == true ? AppColors.secondary : colorScheme.outline)),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        EntranceWrapper.stagger(index: 7, child: const AppSectionTitle(title: AppStrings.accountActions)),
                        const SizedBox(height: AppDimensions.paddingLG),
                        EntranceWrapper.stagger(index: 8, child: AccountActionTile(
                          icon: LucideIcons.edit3, label: AppStrings.editProfile, color: AppColors.primary,
                          onTap: () => showEditProfileDialog(context))),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(index: 9, child: AccountActionTile(
                          icon: LucideIcons.lock, label: AppStrings.changePassword, color: AppColors.primary,
                          onTap: () => showForgotPasswordDialog(context, profile?.email ?? ''))),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(index: 10, child: AccountActionTile(
                          icon: LucideIcons.trash2, label: AppStrings.deleteAccount, color: AppColors.error,
                          onTap: () => DeleteAccountDialog.show(context))),
                        const SizedBox(height: AppDimensions.bottomNavPadding),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
