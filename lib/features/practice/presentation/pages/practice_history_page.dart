import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../cubit/practice_history_cubit.dart';
import 'practice_history_card.dart';
import 'practice_history_shimmer.dart';

class PracticeHistoryPage extends StatelessWidget {
  const PracticeHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PracticeHistoryCubit, PracticeHistoryState>(
      buildWhen: (p, n) => p.status != n.status || p.results != n.results,
      builder: (context, state) {
        return Scaffold(
          appBar: GlassAppBar(
            titleWidget: Text(
              context.l10n.practiceHistory,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PracticeHistoryState state) {
    switch (state.status) {
      case PracticeHistoryStatus.initial:
      case PracticeHistoryStatus.loading:
        return const HistoryShimmer();
      case PracticeHistoryStatus.error:
        return AppErrorState(
          message: context.localizedError(
            fallback: state.errorMessage ?? context.l10n.somethingWentWrong,
          ),
          onRetry: () => context.read<PracticeHistoryCubit>().loadHistory(),
        );
      case PracticeHistoryStatus.loaded:
        if (state.results.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildList(context, state);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppEmptyState(
      icon: LucideIcons.clipboardList,
      title: context.l10n.noPracticeHistory,
      description: context.l10n.noPracticeHistoryDesc,
    );
  }

  Widget _buildList(BuildContext context, PracticeHistoryState state) {
    return RefreshIndicator(
      onRefresh: () => context.read<PracticeHistoryCubit>().loadHistory(),
      child: ListView.builder(
        addAutomaticKeepAlives: false,
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        itemCount: state.results.length,
        itemBuilder: (context, index) {
          final result = state.results[index];
          return EntranceWrapper.stagger(
            index: index,
            child: HistoryCard(result: result),
          );
        },
      ),
    );
  }
}
