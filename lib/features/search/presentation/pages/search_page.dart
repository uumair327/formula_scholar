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
    return AppBar(
      title: const Text(AppStrings.searchLabel),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () => context.read<SearchCubit>().clearSearch(),
          icon: const Icon(LucideIcons.x),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.search,
            size: AppDimensions.iconXL * 2,
            color: colorScheme.outlineVariant,
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            AppStrings.searchHint,
            style: AppTextStyles.bodyLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.searchX,
            size: AppDimensions.iconXL * 2,
            color: colorScheme.outlineVariant,
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            'No results found',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            'Try a different search term',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, SearchState state) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        return _SearchResultCard(
          result: state.results[index],
          query: state.query,
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

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSM),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
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
                    _highlightMatch(result.chapterName, query),
                    style: AppTextStyles.overline.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                _highlightMatch(result.title, query),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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

  String _highlightMatch(String text, String query) {
    return text;
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
