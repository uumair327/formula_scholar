library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../cubit/saved_cubit.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({required this.bookmark, super.key});

  final BookmarkedFormula bookmark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.subject,
                    style: AppTextStyles.overline.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'SAVED ${_formatDate(bookmark.savedAt)}',
                    style: AppTextStyles.overline.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () =>
                    context.read<SavedCubit>().removeBookmark(bookmark.id),
                icon: const Icon(
                  Icons.bookmark,
                  size: AppDimensions.iconMD,
                  color: AppColors.primary,
                ),
                tooltip: AppStrings.removeBookmark,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            bookmark.title,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingLG),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(color: colorScheme.surfaceContainerHigh),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Math.tex(
                  bookmark.formula,
                  textStyle: AppTextStyles.headlineSmall.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
