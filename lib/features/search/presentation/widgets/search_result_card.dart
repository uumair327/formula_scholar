import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
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
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
      child: AppCard(
        onTap: () {
          context.read<SubjectSelectionCubit>().selectSubject(
            id: result.subjectId,
            name: result.subjectName,
            category: '',
            description: '',
            iconName: '',
          );
          context.goNamed(
            AppRoutes.formulaDetailName,
            pathParameters: {
              'subjectId': result.subjectId,
              'chapterId': result.chapterId,
            },
            queryParameters: {'name': result.chapterName},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SubjectBadge(subject: result.subjectName),
                  const SizedBox(width: AppDimensions.paddingSM),
                  Expanded(
                    child: Text(
                      result.chapterName,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
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
              const SizedBox(height: AppDimensions.paddingMD),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLG,
                  vertical: AppDimensions.paddingMD,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Math.tex(
                      result.latex,
                      textStyle: AppTextStyles.titleLarge.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
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
    final baseStyle = style.copyWith(color: colorScheme.onSurface);
    if (query.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(text, style: baseStyle);
    }

    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          if (before.isNotEmpty) TextSpan(text: before),
          TextSpan(
            text: match,
            style: baseStyle.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
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
        horizontal: AppDimensions.paddingXS + 2,
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
