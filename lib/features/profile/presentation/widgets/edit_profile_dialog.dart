import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/profile_cubit.dart';

Future<void> showEditProfileDialog(BuildContext context) async {
  final profile = context.read<ProfileCubit>().state.profile;
  final nameController = TextEditingController(text: profile?.name ?? '');
  final avatarController = TextEditingController(
    text: profile?.avatarUrl ?? '',
  );

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
        title: const Text(AppStrings.editProfileTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.editProfileSubtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              AppTextField(
                controller: nameController,
                label: AppStrings.profileNameLabel,
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              AppTextField(
                controller: avatarController,
                label: AppStrings.profileAvatarUrlLabel,
                hintText: 'https://...',
                keyboardType: TextInputType.url,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancelLabel),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.profileNameRequired)),
                );
                return;
              }

              final avatarUrl = avatarController.text.trim();
              Navigator.of(dialogContext).pop();

              final success = await context.read<ProfileCubit>().updateProfile(
                name: name,
                avatarUrl: avatarUrl.isNotEmpty
                    ? avatarUrl
                    : profile?.avatarUrl ?? '',
              );

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? AppStrings.profileUpdatedSuccess
                        : context.read<ProfileCubit>().state.errorMessage ??
                              AppStrings.failedToUpdateProfile,
                  ),
                  backgroundColor: success
                      ? AppColors.secondary
                      : AppColors.error,
                ),
              );
            },
            child: const Text(AppStrings.saveChanges),
          ),
        ],
      );
    },
  );
}
