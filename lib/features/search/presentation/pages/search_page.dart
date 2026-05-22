import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../../domain/domain.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildSearchInput(context),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                switch (state.status) {
                  case SearchStatus.initial:
                    return _buildInitialState(context);
                  case SearchStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case SearchStatus.loaded when state.isEmpty:
                    return _buildEmptyState(context);
                  case SearchStatus.loaded:
                    return _buildResultsList(context, state);
                  case SearchStatus.error:
                    return AppErrorState(
                      message: state.errorMessage,
                      onRetry: () {
                        context.read<SearchCubit>().search(
                          state.query,
                          curriculumKey: context
                              .read<CurriculumCubit>()
                              .state
                              .curriculum
                              ?.curriculumKey,
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return GlassAppBar(
      titleWidget: Text(
        AppStrings.searchLabel,
        style: AppTextStyles.titleMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: AppDimensions.paddingSM),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: IconButton(
            onPressed: () => context.read<SearchCubit>().clearSearch(),
            icon: const Icon(LucideIcons.x),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        autofocus: true,
        onChanged: (value) {
          context.read<SearchCubit>().search(
            value,
            curriculumKey: context
                .read<CurriculumCubit>()
                .state
                .curriculum
                ?.curriculumKey,
          );
        },
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          prefixIcon: const Icon(LucideIcons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerLow,
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return const AppEmptyState(
      icon: LucideIcons.search,
      title: 'Search Formulas',
      description: 'Type to search across all your subjects and chapters',
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const AppEmptyState(
      icon: LucideIcons.searchX,
      title: 'No results found',
      description: 'Try a different search term',
    );
  }

  Widget _buildResultsList(BuildContext context, SearchState state) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        return EntranceWrapper.stagger(
          index: index,
          child: _SearchResultCard(
            result: state.results[index],
            query: state.query,
          ),
        );
      },
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.result, required this.query});
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
                _SubjectBadge(subject: result.subjectName),
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
            _buildHighlightedText(result.title, query, AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ), colorScheme),
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

class _SubjectBadge extends StatelessWidget {
  const _SubjectBadge({required this.subject});
  final String subject;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
      ),
      child: Text(
        subject.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
