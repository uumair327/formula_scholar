import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/flashcards_cubit.dart';
import '../cubit/flashcards_state.dart';

class FlashcardStartView extends StatelessWidget {
  const FlashcardStartView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.bookOpen,
            size: AppDimensions.iconXL * 2,
            color: colorScheme.primary,
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(
            AppStrings.flashcardStudy,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            'Master formulas with spaced repetition',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(LucideIcons.arrowLeft),
            label: const Text('Go back'),
          ),
        ],
      ),
    );
  }
}

class FlashcardCompleteView extends StatelessWidget {
  const FlashcardCompleteView({super.key, required this.state});

  final FlashcardsState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final summary = state.reviewSummary;
    final graduated = summary?.graduated ?? 0;
    final total = summary?.totalCards ?? 1;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.trophy,
              size: AppDimensions.iconXL * 2,
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            Text(
              AppStrings.flashcardSessionComplete,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Text(
              AppStrings.flashcardSessionDesc,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Text(
              '$graduated/$total graduated',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            if (summary != null && summary.mastered > 0)
              Text(
                '${summary.mastered} mastered (interval >= 21 days)',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            const SizedBox(height: AppDimensions.paddingXL),
            FilledButton.icon(
              onPressed: () => context.read<FlashcardsCubit>().restart(),
              icon: const Icon(LucideIcons.refreshCw),
              label: const Text('Study Again'),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
