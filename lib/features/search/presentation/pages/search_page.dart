import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_result_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    return const AppEmptyState(
                      icon: LucideIcons.search,
                      title: AppStrings.searchFormulasTitle,
                      description:
                          'Type to search across all your subjects and chapters',
                    );
                  case SearchStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case SearchStatus.loaded when state.isEmpty:
                    return const AppEmptyState(
                      icon: LucideIcons.searchX,
                      title: AppStrings.noResultsFound,
                      description: AppStrings.tryDifferentSearch,
                    );
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
