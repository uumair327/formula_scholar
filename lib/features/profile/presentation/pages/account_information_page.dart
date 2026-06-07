import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/account/account_action_tile.dart';
import '../widgets/account/account_info_app_bar.dart';
import '../widgets/account/account_info_tile.dart';
import '../widgets/account/account_profile_card.dart';
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
              final isDesktop =
                  constraints.maxWidth >= AppDimensions.breakpointDesktop;
              final hp = isDesktop
                  ? ((constraints.maxWidth -
                                AppDimensions.breakpointMaxContent) /
                            2)
                        .clamp(AppDimensions.paddingSectionLG, double.infinity)
                  : AppDimensions.paddingXL;
              return CustomScrollView(
                slivers: [
                  const AccountInfoAppBar(),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: hp),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: AppDimensions.paddingXXL),
                        EntranceWrapper.stagger(
                          index: 0,
                          child: AccountProfileCard(profile: profile),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        // Personal Information
                        EntranceWrapper.stagger(
                          index: 2,
                          child: AppSectionTitle(
                            title: context.l10n.personalInfo,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        EntranceWrapper.stagger(
                          index: 3,
                          child: AccountInfoTile(
                            icon: LucideIcons.user,
                            label: context.l10n.fullName,
                            value: profile?.name ?? context.l10n.welcomeScholar,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(
                          index: 4,
                          child: AccountInfoTile(
                            icon: LucideIcons.mail,
                            label: context.l10n.emailAddress,
                            value: profile?.email ?? '—',
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(
                          index: 5,
                          child: AccountActionTile(
                            icon: LucideIcons.edit3,
                            label: context.l10n.editProfile,
                            color: AppColors.primary,
                            onTap: () => showEditProfileBottomSheet(context),
                          ),
                        ),
                        if (profile?.joinedAt != null) ...[
                          const SizedBox(height: AppDimensions.paddingMD),
                          EntranceWrapper.stagger(
                            index: 5,
                            child: AccountInfoTile(
                              icon: LucideIcons.calendar,
                              label: 'Joined On', // Using hardcoded string since not in l10n immediately
                              value: DateFormat('MMMM yyyy').format(profile!.joinedAt!),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppDimensions.paddingXXL),

                        // Academic Information
                        EntranceWrapper.stagger(
                          index: 6,
                          child: AppSectionTitle(
                            title: context.l10n.academicInfo,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        EntranceWrapper.stagger(
                          index: 7,
                          child: AccountInfoTile(
                            icon: LucideIcons.graduationCap,
                            label: context.l10n.currentGrade,
                            value: profile?.grade ?? '—',
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(
                          index: 8,
                          child: AccountInfoTile(
                            icon: LucideIcons.award,
                            label: context.l10n.accountType,
                            value: profile?.isPro == true
                                ? context.l10n.proBadge
                                : context.l10n.freeAccount,
                            valueColor: profile?.isPro == true
                                ? AppColors.secondary
                                : colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),

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
