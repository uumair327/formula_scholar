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
          appBar: AppBar(
            title: Text(
              AppStrings.practiceHistory,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingHero),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.clipboardList,
              size: AppDimensions.imageLG,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            Text(
              AppStrings.noPracticeHistory,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              AppStrings.noPracticeHistoryDesc,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
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
          return HistoryCard(result: result);
        },
      ),
    );
  }
}
