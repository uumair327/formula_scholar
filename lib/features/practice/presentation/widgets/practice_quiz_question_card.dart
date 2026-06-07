import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../../core/core.dart';

import '../../domain/entities/quiz_question.dart';

class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({super.key, required this.question});
  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            width: AppDimensions.imageXL,
            height: AppDimensions.imageXL,
            child: Opacity(
              opacity: AppDimensions.opacityFaint,
              child: CachedNetworkImage(
                imageUrl: question.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => const SizedBox(),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.badgePaddingHorizontal,
                  vertical: AppDimensions.badgePaddingVertical,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Text(
                  question.category,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                    letterSpacing: AppDimensions.letterSpacingWide,
                    fontSize: AppDimensions.fontSizeXS,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              _buildRichText(
                question.questionText,
                AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  height: AppDimensions.lineHeightRelaxed,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Renders text that may contain inline LaTeX delimited by `$...$`.
  /// Plain segments are rendered as [Text], LaTeX segments as [Math.tex].
  static Widget _buildRichText(String rawText, TextStyle style) {
    // Sanitize common escaping issues or typos from the database
    final text = rawText.replaceAll(r'\ ext', r'\text');

    // If there are no LaTeX delimiters, return plain text.
    if (!text.contains('\$')) {
      return Text(text, style: style);
    }

    final parts = <InlineSpan>[];
    final regex = RegExp(r'\$(.+?)\$');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Add plain text before the match.
      if (match.start > lastEnd) {
        parts.add(
          TextSpan(text: text.substring(lastEnd, match.start), style: style),
        );
      }
      // Add the LaTeX as a widget span.
      parts.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Math.tex(
            match.group(1)!,
            textStyle: style.copyWith(fontWeight: FontWeight.w700),
            onErrorFallback: (err) => Text(
              match.group(1)!,
              style: style.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
      lastEnd = match.end;
    }

    // Add any trailing plain text.
    if (lastEnd < text.length) {
      parts.add(TextSpan(text: text.substring(lastEnd), style: style));
    }

    return Text.rich(TextSpan(children: parts));
  }
}
