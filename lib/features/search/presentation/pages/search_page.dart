import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/widgets/widgets.dart';

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

  static const List<_TopicSuggestion> _suggestedTopics = [
    _TopicSuggestion(
      label: 'Quadratic Formula',
      query: 'Quadratic',
      icon: LucideIcons.sigma,
    ),
    _TopicSuggestion(
      label: 'Trigonometry',
      query: 'Trigonometry',
      icon: LucideIcons.calculator,
    ),
    _TopicSuggestion(
      label: 'Pythagoras Theorem',
      query: 'Pythagoras',
      icon: LucideIcons.layers,
    ),
    _TopicSuggestion(
      label: 'Sphere & Circles',
      query: 'Sphere',
      icon: LucideIcons.circle,
    ),
    _TopicSuggestion(
      label: 'Volume & Area',
      query: 'Volume',
      icon: LucideIcons.box,
    ),
    _TopicSuggestion(
      label: 'Algebraic Identities',
      query: 'Algebra',
      icon: LucideIcons.sigma,
    ),
    _TopicSuggestion(
      label: 'Laws of Motion',
      query: 'Newton',
      icon: LucideIcons.atom,
    ),
    _TopicSuggestion(
      label: 'Kinematics',
      query: 'Motion',
      icon: LucideIcons.bookOpen,
    ),
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.breakpointTablet,
          ),
          child: Column(
            children: [
              _buildSearchInput(context),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  buildWhen: (p, n) =>
                      p.status != n.status ||
                      p.results != n.results ||
                      p.query != n.query,
                  builder: (context, state) {
                    if (state.status == SearchStatus.initial &&
                        state.query.isEmpty) {
                      return _buildInitialState(context);
                    }

                    if (state.status == SearchStatus.loading &&
                        state.results.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == SearchStatus.loaded && state.isEmpty) {
                      return AppEmptyState(
                        icon: LucideIcons.searchX,
                        title: l10n.noResultsFound,
                        description: l10n.tryDifferentSearch,
                        mascotMessage: 'No formulas found! 🔍',
                        actionLabel: 'Clear Search',
                        onAction: _clearSearch,
                      );
                    }

                    if (state.status == SearchStatus.error &&
                        state.results.isEmpty) {
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

                    return Stack(
                      children: [
                        _buildResultsList(context, state),
                        if (state.status == SearchStatus.loading)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(
                              minHeight: 2,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLG,
        vertical: AppDimensions.paddingMD,
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, _) {
          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              border: Border.all(
                color: value.text.isNotEmpty
                    ? colorScheme.primary.withValues(alpha: 0.6)
                    : colorScheme.outlineVariant.withValues(alpha: 0.35),
                width: value.text.isNotEmpty ? 1.5 : 1,
              ),
              boxShadow: value.text.isNotEmpty
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              style: AppTextStyles.bodyLarge.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (val) {
                final curriculumKey = context
                    .read<CurriculumCubit>()
                    .state
                    .curriculum
                    ?.curriculumKey;
                context.read<SearchCubit>().search(
                  val,
                  curriculumKey: curriculumKey,
                );
              },
              decoration: InputDecoration(
                hintText: l10n.searchFormulas,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  size: AppDimensions.iconMD,
                  color: value.text.isNotEmpty
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          LucideIcons.x,
                          size: AppDimensions.iconSM,
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLG,
                  vertical: AppDimensions.paddingMD,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLG,
        vertical: AppDimensions.paddingMD,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.paddingMD),

          // Mascot with speech bubble
          const MascotSpeechBubble(
            message: 'What formula are we solving today? 🦉',
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          const AppMascot(
            mood: MascotMood.thinking,
            size: AppDimensions.mascotLG,
          ),
          const SizedBox(height: AppDimensions.paddingLG),

          Text(
            'Explore Formulas & Concepts',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            'Search instantly across mathematics, physics, and science formulas',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingXXL),

          // Popular Topics Card
          AppCard(
            padding: const EdgeInsets.all(AppDimensions.paddingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingXS + 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMD,
                        ),
                      ),
                      child: Icon(
                        LucideIcons.sparkles,
                        size: AppDimensions.iconSM,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMD),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Search Topics',
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Tap any topic to discover relevant formulas',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                Wrap(
                  spacing: AppDimensions.paddingSM,
                  runSpacing: AppDimensions.paddingSM,
                  children: _suggestedTopics.map((topic) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _applySearch(topic.query),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusFull,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMD + 2,
                            vertical: AppDimensions.paddingSM + 1,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                            border: Border.all(
                              color: colorScheme.outlineVariant
                                  .withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                topic.icon,
                                size: AppDimensions.iconSM - 2,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: AppDimensions.paddingSM),
                              Text(
                                topic.label,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
        ],
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, SearchState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      addAutomaticKeepAlives: false,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLG,
        vertical: AppDimensions.paddingSM,
      ),
      itemCount: state.results.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: AppDimensions.paddingMD,
              top: AppDimensions.paddingXS,
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.search,
                  size: AppDimensions.iconXS,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.paddingXS),
                Text(
                  'Found ${state.results.length} formula${state.results.length == 1 ? '' : 's'}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        final result = state.results[index - 1];
        return EntranceWrapper.stagger(
          index: index - 1,
          child: SearchResultCard(
            result: result,
            query: state.query,
          ),
        );
      },
    );
  }
}

class _TopicSuggestion {
  const _TopicSuggestion({
    required this.label,
    required this.query,
    required this.icon,
  });

  final String label;
  final String query;
  final IconData icon;
}
