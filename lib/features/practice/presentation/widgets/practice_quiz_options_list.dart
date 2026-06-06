import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/entities/quiz_question.dart';
import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';

class QuizOptionsList extends StatelessWidget {
  const QuizOptionsList({
    super.key,
    required this.state,
    required this.question,
  });
  final PracticeState state;
  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > AppDimensions.breakpointMedium;
        final options = question.options.map((option) {
          final isSelected = state.selectedOptionId == option.id;
          final isCorrect = option.id == question.correctOptionId;
          final showCorrectState = state.showResult && isSelected && isCorrect;
          final showWrongState = state.showResult && isSelected && !isCorrect;
          final showCorrectHint =
              state.showResult && !state.isCorrect && isCorrect;
          final hasAnswered = state.selectedOptionId != null;

          return AppCard(
            borderRadius: AppDimensions.radiusMD,
            onTap: hasAnswered
                ? null
                : () => context.read<PracticeCubit>().selectOption(option.id),
            padding: const EdgeInsets.all(AppDimensions.paddingXXL),
            color: showCorrectState || showCorrectHint
                ? colorScheme.secondaryContainer.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  )
                : showWrongState
                ? colorScheme.error.withValues(
                    alpha: AppDimensions.opacityFaint,
                  )
                : colorScheme.surfaceContainerLowest,
            border: Border.all(
              color: showCorrectState || showCorrectHint
                  ? colorScheme.secondary
                  : showWrongState
                  ? colorScheme.error
                  : colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: AppDimensions.borderWidth,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: AppDurations.animationDefault,
                  width: AppDimensions.avatarLG,
                  height: AppDimensions.avatarLG,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: showCorrectState || showCorrectHint
                        ? colorScheme.secondary
                        : showWrongState
                        ? colorScheme.error
                        : colorScheme.surfaceContainerHigh,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    option.id,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: showCorrectState || showCorrectHint
                          ? colorScheme.onSecondary
                          : showWrongState
                          ? colorScheme.onError
                          : colorScheme.outline,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingLG),
                Expanded(
                  child: _buildOptionText(
                    option.text,
                    AppTextStyles.titleMedium.copyWith(
                      fontWeight:
                          showCorrectState || showWrongState || showCorrectHint
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: showCorrectState || showCorrectHint
                          ? colorScheme.onSecondaryContainer
                          : showWrongState
                          ? colorScheme.error
                          : null,
                    ),
                  ),
                ),
                if (showCorrectState || showCorrectHint)
                  Icon(
                    LucideIcons.checkCircle2,
                    size: AppDimensions.iconLG,
                    color: colorScheme.secondary,
                  ),
                if (showWrongState)
                  Icon(
                    LucideIcons.xCircle,
                    size: AppDimensions.iconLG,
                    color: colorScheme.error,
                  ),
              ],
            ),
          );
        }).toList();

        if (isWide) {
          return Wrap(
            spacing: AppDimensions.paddingLG,
            runSpacing: AppDimensions.paddingLG,
            children: options
                .map(
                  (o) => SizedBox(
                    width: (constraints.maxWidth - AppDimensions.paddingLG) / 2,
                    child: o,
                  ),
                )
                .toList(),
          );
        }
        return Column(
          children: options
              .map(
                (o) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.paddingLG,
                  ),
                  child: o,
                ),
              )
              .toList(),
        );
      },
    );
  }

  /// Renders option text that may contain inline LaTeX delimited by `$...$`.
  static Widget _buildOptionText(String text, TextStyle style) {
    if (!text.contains('\$')) {
      return Text(text, style: style);
    }

    final parts = <InlineSpan>[];
    final regex = RegExp(r'\$(.+?)\$');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        parts.add(
          TextSpan(text: text.substring(lastEnd, match.start), style: style),
        );
      }
      parts.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Math.tex(match.group(1)!, textStyle: style),
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      parts.add(TextSpan(text: text.substring(lastEnd), style: style));
    }

    return Text.rich(TextSpan(children: parts));
  }
}
