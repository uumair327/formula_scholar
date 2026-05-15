import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/flashcards_cubit.dart';
import '../cubit/flashcards_state.dart';
import '../../domain/domain.dart';

class FlashcardsPage extends StatelessWidget {
  const FlashcardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.flashcardStudy),
        centerTitle: true,
      ),
      body: BlocBuilder<FlashcardsCubit, FlashcardsState>(
        builder: (context, state) {
          switch (state.status) {
            case FlashcardsStatus.initial:
              return _buildStartState(context);
            case FlashcardsStatus.ready:
              return _buildFlashcard(context, state);
            case FlashcardsStatus.finished:
              return _buildCompleteState(context, state);
          }
        },
      ),
    );
  }

  Widget _buildStartState(BuildContext context) {
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

  Widget _buildFlashcard(BuildContext context, FlashcardsState state) {
    final card = state.session.currentCard;
    if (card == null) return const SizedBox();

    final colorScheme = Theme.of(context).colorScheme;
    final progress = state.session.progressPercent;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      child: Column(
        children: [
          LinearProgressIndicator(value: progress / 100),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            '${state.session.currentIndex + 1} of ${state.session.totalCards}',
            style: AppTextStyles.bodySmall.copyWith(color: colorScheme.outline),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            card.chapterName,
            style: AppTextStyles.overline.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Expanded(
            child: GestureDetector(
              onTap: () => context.read<FlashcardsCubit>().flipCard(),
              child: AnimatedSwitcher(
                duration: AppDurations.animationFast,
                child: state.session.isFlipped
                    ? _buildBack(context, card)
                    : _buildFront(context, card),
              ),
            ),
          ),
          if (state.session.isFlipped) ...[
            const SizedBox(height: AppDimensions.paddingMD),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.read<FlashcardsCubit>().markForReview(),
                    icon: const Icon(LucideIcons.refreshCw),
                    label: const Text(AppStrings.flashcardReview),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMD),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.read<FlashcardsCubit>().markMastered(),
                    icon: const Icon(LucideIcons.check),
                    label: const Text(AppStrings.flashcardMastered),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFront(BuildContext context, Flashcard card) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      key: const ValueKey('front'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.eye, size: 32, color: colorScheme.outline),
              const SizedBox(height: AppDimensions.paddingMD),
              Text(
                card.title,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              const Text(AppStrings.flashcardFlip),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBack(BuildContext context, Flashcard card) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      key: const ValueKey('back'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          children: [
            Text(
              card.title,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Math.tex(
                    card.latex,
                    textStyle: AppTextStyles.headlineMedium.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            if (card.description.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingLG),
              Text(
                card.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteState(BuildContext context, FlashcardsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final masteredCount = state.session.masteredIds.length;
    final totalCount = state.session.totalCards;

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
              '$masteredCount/$totalCount mastered',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
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
