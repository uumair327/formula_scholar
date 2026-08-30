import 'dart:math' as math;
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
    final currentIndex = state.session.currentIndex;
    final totalCards = state.session.totalCards;
    final isFlipped = state.session.isFlipped;
    final progress = totalCards > 0 ? (currentIndex + 1) / totalCards : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingSM,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: colorScheme.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currentIndex + 1} of $totalCards',
                style: AppTextStyles.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (card.chapterName.isNotEmpty)
                Text(
                  card.chapterName,
                  style: AppTextStyles.overline.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Expanded(
            child: _FlippableFlashcard(
              key: ValueKey(card.id),
              card: card,
              isFlipped: isFlipped,
              onFlip: () => context.read<FlashcardsCubit>().flipCard(),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          if (isFlipped)
            _RatingRow()
          else
            _FlipPromptBar(
              onFlip: () => context.read<FlashcardsCubit>().flipCard(),
            ),
        ],
      ),
    );
  }
}

class _FlippableFlashcard extends StatelessWidget {
  const _FlippableFlashcard({
    super.key,
    required this.card,
    required this.isFlipped,
    required this.onFlip,
  });

  final Flashcard card;
  final bool isFlipped;
  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: AppDurations.animationDefault,
      curve: AppDurations.curvePremium,
      tween: Tween<double>(begin: 0, end: isFlipped ? 180 : 0),
      builder: (context, val, __) {
        final isBack = val >= 90;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY((val * math.pi) / 180),
          child: isBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: _FlashcardBack(card: card, onFlip: onFlip),
                )
              : _FlashcardFront(card: card, onFlip: onFlip),
        );
      },
    );
  }
}

class _FlashcardFront extends StatelessWidget {
  const _FlashcardFront({required this.card, required this.onFlip});

  final Flashcard card;
  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onFlip,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            boxShadow: [AppShadows.cardHover, AppShadows.glow(colorScheme.primary)],
          ),
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.eye,
                  size: AppDimensions.iconLG,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Text(
                card.title,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMD,
                  vertical: AppDimensions.paddingSM,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.refreshCw,
                      size: AppDimensions.iconXS,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: AppDimensions.paddingXS),
                    Text(
                      context.l10n.flashcardFlip,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlashcardBack extends StatelessWidget {
  const _FlashcardBack({required this.card, required this.onFlip});

  final Flashcard card;
  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onFlip,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [AppShadows.elevated, AppShadows.glow(colorScheme.primary)],
          ),
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                card.title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingLG),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Math.tex(
                          card.latex.isNotEmpty ? card.latex : r'\text{N/A}',
                          textStyle: AppTextStyles.headlineSmall.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (card.description.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.paddingMD),
                Text(
                  card.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppDimensions.paddingSM),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (card.reviewCount > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSM,
                        vertical: AppDimensions.paddingXXS,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusPill,
                        ),
                      ),
                      child: Text(
                        'Reviewed ${card.reviewCount}x',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                  ],
                  if (card.isMastered)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSM,
                        vertical: AppDimensions.paddingXXS,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusPill,
                        ),
                      ),
                      child: Text(
                        'Mastered',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlipPromptBar extends StatelessWidget {
  const _FlipPromptBar({required this.onFlip});

  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: onFlip,
        icon: const Icon(LucideIcons.refreshCw),
        label: Text(
          context.l10n.flashcardFlip,
          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
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
            fontWeight: FontWeight.w600,
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
            const SizedBox(width: AppDimensions.paddingXS),
            Expanded(
              child: FlashcardRatingButton(
                label: context.l10n.flashcardHard,
                icon: LucideIcons.batteryLow,
                color: colorScheme.tertiary,
                onTap: () => cubit.rateCard(ReviewQuality.hard),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingXS),
            Expanded(
              child: FlashcardRatingButton(
                label: context.l10n.flashcardGood,
                icon: LucideIcons.batteryMedium,
                color: colorScheme.secondary,
                onTap: () => cubit.rateCard(ReviewQuality.good),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingXS),
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
