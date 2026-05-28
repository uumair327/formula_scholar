import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';

import '../cubit/profile_cubit.dart';

Future<void> showEditProfileDialog(BuildContext context) async {
  final profile = context.read<ProfileCubit>().state.profile;
  final nameController = TextEditingController(text: profile?.name ?? '');
  final avatarController = TextEditingController(
    text: profile?.avatarUrl ?? '',
  );

  try {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          ),
          title: Text(context.l10n.editProfileTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.editProfileSubtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                AppTextField(
                  controller: nameController,
                  label: context.l10n.profileNameLabel,
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                AppTextField(
                  controller: avatarController,
                  label: context.l10n.profileAvatarUrlLabel,
                  hintText: 'https://...',
                  keyboardType: TextInputType.url,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.cancelLabel),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.profileNameRequired)),
                  );
                  return;
                }

                final avatarUrl = avatarController.text.trim();
                Navigator.of(dialogContext).pop();

                final success = await context
                    .read<ProfileCubit>()
                    .updateProfile(
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
                          ? context.l10n.profileUpdatedSuccess
                          : context.localizedError(
                              errorKey: context
                                  .read<ProfileCubit>()
                                  .state
                                  .errorKey,
                              fallback:
                                  context
                                      .read<ProfileCubit>()
                                      .state
                                      .errorMessage ??
                                  context.l10n.failedToUpdateProfile,
                            ),
                    ),
                    backgroundColor: success
                        ? AppColors.secondary
                        : AppColors.error,
                  ),
                );
              },
              child: Text(context.l10n.saveChanges),
            ),
          ],
        );
      },
    );
  } finally {
    nameController.dispose();
    avatarController.dispose();
  }
}
