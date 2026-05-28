import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../../../auth/auth.dart';

class PreFilterHeader extends StatelessWidget {
  const PreFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final photoUrl = context.select<AuthCubit, String>(
      (c) => c.state.user?.photoUrl ?? '',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingSM,
      ),
      child: Row(
        children: [
          // Removed the 'X' button since Practice is a standalone tab
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            context.l10n.formulaFlow,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: AppDimensions.letterSpacingTight,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          AppAvatar(
            imageUrl: photoUrl,
            size: AppDimensions.avatarSM,
            fallbackIcon: LucideIcons.userCircle,
            fallbackIconColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
