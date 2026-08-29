import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_result_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  static const List<String> _suggestedTopics = [
    'Sphere',
    'Circle',
    'Quadratic',
    'Trigonometry',
    'Pythagoras',
    'Volume',
    'Surface Area',
    'Algebra',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    context.read<SearchCubit>().clearSearch();
    _focusNode.requestFocus();
  }

  void _applySearch(String term) {
    _controller.text = term;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );
    final curriculumKey =
        context.read<CurriculumCubit>().state.curriculum?.curriculumKey;
    context.read<SearchCubit>().search(term, curriculumKey: curriculumKey);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildSearchInput(context),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              buildWhen: (p, n) =>
                  p.status != n.status ||
                  p.results != n.results ||
                  p.query != n.query,
              builder: (context, state) {
                switch (state.status) {
                  case SearchStatus.initial:
                    return _buildInitialState(context);
                  case SearchStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case SearchStatus.loaded when state.isEmpty:
                    return AppEmptyState(
                      icon: LucideIcons.searchX,
                      title: l10n.noResultsFound,
                      description: l10n.tryDifferentSearch,
                    );
                  case SearchStatus.loaded:
                    return _buildResultsList(context, state);
                  case SearchStatus.error:
                    return AppErrorState(
                      message: context.localizedError(
                        fallback: state.errorMessage,
                      ),
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
    final l10n = context.l10n;
    return GlassAppBar(
      titleWidget: Text(
        l10n.searchLabel,
        style: AppTextStyles.titleMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsetsDirectional.only(
                end: AppDimensions.paddingSM,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: IconButton(
                onPressed: _clearSearch,
                icon: const Icon(LucideIcons.x),
                tooltip: l10n.clearSearch,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, _) {
          return TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            onChanged: (val) {
              final curriculumKey = context
                  .read<CurriculumCubit>()
                  .state
                  .curriculum
                  ?.curriculumKey;
              context.read<SearchCubit>().search(val, curriculumKey: curriculumKey);
            },
            decoration: InputDecoration(
              hintText: l10n.searchFormulas,
              prefixIcon: const Icon(LucideIcons.search),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(LucideIcons.x, size: AppDimensions.iconSM),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingLG),
              child: Column(
                children: [
                  Icon(
                    LucideIcons.search,
                    size: 48,
                    color: colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                  Text(
                    l10n.searchFormulasTitle,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    l10n.searchEmptyDescription,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            'Popular Topics',
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Wrap(
            spacing: AppDimensions.paddingSM,
            runSpacing: AppDimensions.paddingSM,
            children: _suggestedTopics.map((topic) {
              return ActionChip(
                label: Text(topic),
                avatar: const Icon(
                  LucideIcons.sparkles,
                  size: AppDimensions.iconXS,
                ),
                onPressed: () => _applySearch(topic),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, SearchState state) {
    return ListView.builder(
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        return EntranceWrapper.stagger(
          index: index,
          child: SearchResultCard(
            result: state.results[index],
            query: state.query,
          ),
        );
      },
    );
  }
}
