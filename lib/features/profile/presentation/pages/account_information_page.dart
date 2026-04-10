import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../domain/domain.dart';
import '../../../auth/auth.dart';

/// Account Information page – displays user account details.
///
/// Sub-route of profile. Shows editable fields like name, email,
/// grade, and account status.
class AccountInformationPage extends StatelessWidget {
  const AccountInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXL,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppDimensions.paddingXXL),
                    // Profile card
                    _buildProfileCard(profile),
                    const SizedBox(height: AppDimensions.paddingXXL),
                    // Personal Info section
                    const AppSectionTitle(title: AppStrings.personalInfo),
                    const SizedBox(height: AppDimensions.paddingLG),
                    _buildInfoTile(
                      icon: LucideIcons.user,
                      label: AppStrings.fullName,
                      value: profile?.name ?? AppStrings.welcomeScholar,
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),
                    _buildInfoTile(
                      icon: LucideIcons.mail,
                      label: AppStrings.emailAddress,
                      value: profile?.email ?? '—',
                    ),
                    const SizedBox(height: AppDimensions.paddingXXL),
                    // Academic Info section
                    const AppSectionTitle(title: AppStrings.academicInfo),
                    const SizedBox(height: AppDimensions.paddingLG),
                    _buildInfoTile(
                      icon: LucideIcons.graduationCap,
                      label: AppStrings.currentGrade,
                      value: profile?.grade ?? '—',
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),
                    _buildInfoTile(
                      icon: LucideIcons.award,
                      label: AppStrings.accountType,
                      value: profile?.isPro == true
                          ? AppStrings.proBadge
                          : AppStrings.freeAccount,
                      valueColor: profile?.isPro == true
                          ? AppColors.secondary
                          : AppColors.outline,
                    ),
                    const SizedBox(height: AppDimensions.paddingXXL),
                    // Account Actions
                    const AppSectionTitle(title: AppStrings.accountActions),
                    const SizedBox(height: AppDimensions.paddingLG),
                    _buildActionTile(
                      context: context,
                      icon: LucideIcons.edit3,
                      label: AppStrings.editProfile,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),
                    _buildActionTile(
                      context: context,
                      icon: LucideIcons.lock,
                      label: AppStrings.changePassword,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),
                    _buildActionTile(
                      context: context,
                      icon: LucideIcons.trash2,
                      label: AppStrings.deleteAccount,
                      color: AppColors.error,
                      onTap: () => _showDeleteAccountDialog(context),
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

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(LucideIcons.arrowLeft, color: AppColors.onSurface),
      ),
      title: Text(
        AppStrings.accountInformation,
        style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfileCard(UserProfile? profile) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Row(
        children: [
          AppAvatar(
            imageUrl: profile?.avatarUrl ?? AppAssets.profileAvatarUrl,
            size: AppDimensions.avatarHero,
            border: Border.all(
              color: AppColors.primaryContainer,
              width: AppDimensions.borderWidth,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingXL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name ?? AppStrings.welcomeScholar,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  profile?.email ?? '—',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.chipPaddingHorizontal,
                    vertical: AppDimensions.chipPaddingVertical,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryFixed,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusXL),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.checkCircle,
                        size: AppDimensions.iconXS,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppDimensions.paddingXS),
                      Text(
                        AppStrings.verifiedAccount,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.onSecondaryContainer,
                          letterSpacing: AppDimensions.letterSpacingNarrow,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL,
        vertical: AppDimensions.paddingLG,
      ),
      child: Row(
        children: [
          AppIconCircle(
            icon: icon,
            backgroundColor: AppColors.surfaceContainerHigh,
            iconColor: AppColors.outline,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.outline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  value,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: valueColor ?? AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap ?? () => ComingSoonSheet.show(context, featureName: label),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        child: AppCard(
          boxShadow: const [AppShadows.subtle],
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingLG,
          ),
          child: Row(
            children: [
              AppIconCircle(
                icon: icon,
                backgroundColor: color.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
                iconColor: color,
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.labelLarge.copyWith(color: color),
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: AppDimensions.iconMD,
                color: color.withValues(alpha: AppDimensions.opacityMedium),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.unauthenticated) {
              Navigator.of(dialogContext).pop();
              context.go(AppRoutes.loginPath);
            } else if (state.status == AuthStatus.error) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Failed to delete account'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: AlertDialog(
            backgroundColor: AppColors.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            title: Row(
              children: [
                const Icon(LucideIcons.alertTriangle, color: AppColors.error),
                const SizedBox(width: AppDimensions.paddingMD),
                Text(
                  'Delete Account',
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.error),
                ),
              ],
            ),
            content: Text(
              'Are you sure you want to permanently delete your account? '
              'This action cannot be undone and all your data will be cleared.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.outline),
                ),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading = state.status == AuthStatus.loading;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => context.read<AuthCubit>().deleteAccount(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.onError,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingXL,
                        vertical: AppDimensions.paddingMD,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: AppDimensions.iconSM,
                            height: AppDimensions.iconSM,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Text('Delete Permanently'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
