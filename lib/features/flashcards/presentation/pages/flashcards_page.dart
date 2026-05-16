import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/flashcards_cubit.dart';
import '../cubit/flashcards_state.dart';

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
            case FlashcardsStatus.loading:
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
                    ? _buildBack(context, card, card.reviewCount)
                    : _buildFront(context, card),
              ),
            ),
          ),
          if (state.session.isFlipped) ...[
            const SizedBox(height: AppDimensions.paddingMD),
            _buildRatingRow(context),
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

  Widget _buildBack(BuildContext context, Flashcard card, int reviewCount) {
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
            if (reviewCount > 0) ...[
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                'Reviewed $reviewCount times',
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

  Widget _buildRatingRow(BuildContext context) {
    final cubit = context.read<FlashcardsCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          'How well did you know it?',
          style: AppTextStyles.labelMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        Row(
          children: [
            Expanded(
              child: _RatingButton(
                label: 'Again',
                icon: LucideIcons.rotateCcw,
                color: colorScheme.error,
                onTap: () => cubit.rateCard(ReviewQuality.again),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _RatingButton(
                label: 'Hard',
                icon: LucideIcons.batteryLow,
                color: colorScheme.tertiary,
                onTap: () => cubit.rateCard(ReviewQuality.hard),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _RatingButton(
                label: 'Good',
                icon: LucideIcons.batteryMedium,
                color: colorScheme.secondary,
                onTap: () => cubit.rateCard(ReviewQuality.good),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _RatingButton(
                label: 'Easy',
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

  Widget _buildCompleteState(BuildContext context, FlashcardsState state) {
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

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
