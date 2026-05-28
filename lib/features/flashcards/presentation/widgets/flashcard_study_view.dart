import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/flashcards_cubit.dart';
import '../cubit/flashcards_state.dart';
import 'flashcard_rating_button.dart';

class FlashcardStudyView extends StatelessWidget {
  const FlashcardStudyView({super.key, required this.state});

  final FlashcardsState state;

  @override
  Widget build(BuildContext context) {
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
            '${state.session.graduatedIds.length + 1} of ${state.session.totalCards}',
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
                    ? _FlashcardBack(card: card)
                    : _FlashcardFront(card: card),
              ),
            ),
          ),
          if (state.session.isFlipped) ...[
            const SizedBox(height: AppDimensions.paddingMD),
            _RatingRow(),
          ],
        ],
      ),
    );
  }
}

class _FlashcardFront extends StatelessWidget {
  const _FlashcardFront({required this.card});

  final Flashcard card;

  @override
  Widget build(BuildContext context) {
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
              Text(context.l10n.flashcardFlip),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlashcardBack extends StatelessWidget {
  const _FlashcardBack({required this.card});

  final Flashcard card;

  @override
  Widget build(BuildContext context) {
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
            if (card.reviewCount > 0) ...[
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                'Reviewed ${card.reviewCount} times',
                style: AppTextStyles.labelSmall.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FlashcardsCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          'How well did you know it?',
          style: AppTextStyles.labelMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        Row(
          children: [
            Expanded(
              child: FlashcardRatingButton(
                label: context.l10n.flashcardAgain,
                icon: LucideIcons.rotateCcw,
                color: colorScheme.error,
                onTap: () => cubit.rateCard(ReviewQuality.again),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: FlashcardRatingButton(
                label: context.l10n.flashcardHard,
                icon: LucideIcons.batteryLow,
                color: colorScheme.tertiary,
                onTap: () => cubit.rateCard(ReviewQuality.hard),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: FlashcardRatingButton(
                label: context.l10n.flashcardGood,
                icon: LucideIcons.batteryMedium,
                color: colorScheme.secondary,
                onTap: () => cubit.rateCard(ReviewQuality.good),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: FlashcardRatingButton(
                label: context.l10n.flashcardEasy,
                icon: LucideIcons.batteryFull,
                color: colorScheme.primary,
                onTap: () => cubit.rateCard(ReviewQuality.easy),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
