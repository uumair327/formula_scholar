import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/widgets/app_mascot.dart';
import '../../../../shared/widgets/mascot_painter.dart';
import '../../../../shared/widgets/mascot_speech_bubble.dart';
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
          const MascotSpeechBubble(message: "Let's study! 📚"),
          const AppMascot(
            mood: MascotMood.encouraging,
            size: AppDimensions.mascotLG,
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            context.l10n.flashcardStudy,
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
            label: Text(context.l10n.goBack),
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
    final mastered = summary?.mastered ?? 0;
    final needsReview = state.session.reviewIds.length;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MascotSpeechBubble(message: 'Great job! 🎉'),
            const AppMascot(
              mood: MascotMood.celebrating,
              size: AppDimensions.mascotLG,
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Text(
              context.l10n.flashcardSessionComplete,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              context.l10n.flashcardSessionDesc,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatColumn(
                    label: 'Graduated',
                    value: '$graduated / $total',
                    color: colorScheme.primary,
                  ),
                  if (mastered > 0)
                    _StatColumn(
                      label: 'Mastered',
                      value: '$mastered',
                      color: colorScheme.secondary,
                    ),
                  if (needsReview > 0)
                    _StatColumn(
                      label: 'Needs Review',
                      value: '$needsReview',
                      color: colorScheme.error,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            if (needsReview > 0) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () =>
                      context.read<FlashcardsCubit>().reviewRemaining(),
                  icon: const Icon(LucideIcons.rotateCcw),
                  label: Text('Review $needsReview Remaining Cards'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.tertiary,
                    foregroundColor: colorScheme.onTertiary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingMD,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.read<FlashcardsCubit>().restart(),
                icon: const Icon(LucideIcons.refreshCw),
                label: Text(context.l10n.studyAgain),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingMD,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.done),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXXS),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
