import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/profile_cubit.dart';

Future<void> showEditProfileBottomSheet(BuildContext context) async {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (bottomSheetContext) {
      return BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: const _EditProfileBottomSheetContent(),
      );
    },
  );
}

class _EditProfileBottomSheetContent extends StatefulWidget {
  const _EditProfileBottomSheetContent();

  @override
  State<_EditProfileBottomSheetContent> createState() =>
      _EditProfileBottomSheetContentState();
}

class _EditProfileBottomSheetContentState
    extends State<_EditProfileBottomSheetContent> {
  late TextEditingController _nameController;
  late String _selectedAvatarUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().state.profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _selectedAvatarUrl = profile?.avatarUrl ?? '';
    
    if (_selectedAvatarUrl.isEmpty && AppAssets.avatarPresets.isNotEmpty) {
      _selectedAvatarUrl = AppAssets.avatarPresets.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileNameRequired)),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await context.read<ProfileCubit>().updateProfile(
          name: name,
          avatarUrl: _selectedAvatarUrl,
        );

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.profileUpdatedSuccess),
          backgroundColor: AppColors.secondary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.localizedError(
              errorKey: context.read<ProfileCubit>().state.errorKey,
              fallback: context.read<ProfileCubit>().state.errorMessage ??
                  context.l10n.failedToUpdateProfile,
            ),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppDimensions.paddingXL,
        right: AppDimensions.paddingXL,
        top: AppDimensions.paddingLG,
        bottom: AppDimensions.paddingXL + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          
          Text(
            context.l10n.editProfileTitle,
            style: AppTextStyles.headlineSmall.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            context.l10n.editProfileSubtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),

          // Avatar Selection
          Text(
            'Choose an Avatar',
            style: AppTextStyles.titleMedium.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: AppAssets.avatarPresets.length,
              separatorBuilder: (context, index) => 
                  const SizedBox(width: AppDimensions.paddingMD),
              itemBuilder: (context, index) {
                final url = AppAssets.avatarPresets[index];
                final isSelected = _selectedAvatarUrl == url;
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedAvatarUrl = url),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected 
                            ? AppColors.primary 
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.surfaceContainerHighest,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: AppAvatar(
                        imageUrl: url,
                        size: 74,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: AppDimensions.paddingXXL),

          // Name Input
          AppTextField(
            controller: _nameController,
            label: context.l10n.profileNameLabel,
          ),
          
          const SizedBox(height: AppDimensions.paddingXXL),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingLG,
                    ),
                  ),
                  child: Text(context.l10n.cancelLabel),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: FilledButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingLG,
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(context.l10n.saveChanges),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
