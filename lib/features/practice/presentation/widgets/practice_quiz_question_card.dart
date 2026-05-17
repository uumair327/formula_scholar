import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
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
            top: 0, right: 0,
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
              Text(
                question.questionText,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  height: AppDimensions.lineHeightRelaxed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
