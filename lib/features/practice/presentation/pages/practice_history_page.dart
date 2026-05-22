import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/practice_history_cubit.dart';
import 'practice_history_card.dart';
import 'practice_history_shimmer.dart';

class PracticeHistoryPage extends StatefulWidget {
  const PracticeHistoryPage({super.key});

  @override
  State<PracticeHistoryPage> createState() => _PracticeHistoryPageState();
}

class _PracticeHistoryPageState extends State<PracticeHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<PracticeHistoryCubit>().loadHistory(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PracticeHistoryCubit, PracticeHistoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GlassAppBar(
            titleWidget: Text(
              AppStrings.practiceHistory,
              style: AppTextStyles.titleLarge.copyWith(
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
          message: state.errorMessage ?? AppStrings.somethingWentWrong,
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
    return const AppEmptyState(
      icon: LucideIcons.clipboardList,
      title: AppStrings.noPracticeHistory,
      description: AppStrings.noPracticeHistoryDesc,
    );
  }

  Widget _buildList(BuildContext context, PracticeHistoryState state) {
    return RefreshIndicator(
      onRefresh: () => context.read<PracticeHistoryCubit>().loadHistory(),
      child: ListView.builder(
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
