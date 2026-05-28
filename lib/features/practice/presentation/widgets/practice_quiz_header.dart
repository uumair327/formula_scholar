import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../cubit/practice_cubit.dart';

class QuizHeader extends StatelessWidget {
  const QuizHeader({super.key, required this.photoUrl});
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingSM,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _confirmQuit(context),
            icon: const Icon(LucideIcons.x, size: AppDimensions.iconLG),
            tooltip: context.l10n.closeQuiz,
          ),
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
          photoUrl.isNotEmpty
              ? AppAvatar(
                  imageUrl: photoUrl,
                  size: AppDimensions.avatarSM,
                  fallbackIcon: LucideIcons.userCircle,
                  fallbackIconColor: colorScheme.primary,
                )
              : Icon(
                  LucideIcons.userCircle,
                  size: AppDimensions.iconLG,
                  color: colorScheme.primary,
                ),
        ],
      ),
    );
  }

  void _confirmQuit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quit Practice?'),
        content: const Text(
          'Are you sure you want to quit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<PracticeCubit>().resetQuiz();
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}
