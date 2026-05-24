import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import 'search_subject_badge.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.result,
    required this.query,
  });
  final SearchResult result;
  final String query;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingSM),
      child: AppCard(
        onTap: () {
          context.pushNamed(
            AppRoutes.formulaDetailName,
            pathParameters: {
              'subjectId': result.subjectId,
              'chapterId': result.chapterId,
            },
            queryParameters: {'name': result.chapterName},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SubjectBadge(subject: result.subjectName),
                  const SizedBox(width: AppDimensions.paddingSM),
                  Text(
                    result.chapterName,
                    style: AppTextStyles.overline.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                  if (query.isNotEmpty) ...[
                    const SizedBox(width: AppDimensions.paddingXS),
                    _buildHighlightChip(result.chapterName, query, colorScheme),
                  ],
                ],
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              _buildHighlightedText(
                result.title,
                query,
                AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
                colorScheme,
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.paddingSM),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Math.tex(
                      result.latex,
                      textStyle: AppTextStyles.bodyLarge.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
    String text,
    String query,
    TextStyle style,
    ColorScheme colorScheme,
  ) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(text, style: style);
    }

    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          if (before.isNotEmpty) TextSpan(text: before),
          TextSpan(
            text: match,
            style: style.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (after.isNotEmpty) TextSpan(text: after),
        ],
      ),
    );
  }

  Widget _buildHighlightChip(
    String text,
    String query,
    ColorScheme colorScheme,
  ) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXS,
        vertical: AppDimensions.paddingXXS,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
      ),
      child: Text(
        text.substring(index, index + query.length),
        style: AppTextStyles.overline.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
