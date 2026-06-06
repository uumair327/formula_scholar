import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../cubit/achievements_cubit.dart';
import '../cubit/achievements_state.dart';
import '../widgets/achievement_progress_card.dart';
import '../widgets/achievement_tile.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        titleWidget: Text(
          'Achievements',
          style: AppTextStyles.titleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: BlocBuilder<AchievementsCubit, AchievementsState>(
        buildWhen: (p, n) =>
            p.isLoading != n.isLoading ||
            p.unlocked != n.unlocked ||
            p.locked != n.locked,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final unlocked = state.unlocked;
          final locked = state.locked;

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<AchievementsCubit>().loadAchievements();
            },
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.paddingMD),
              children: [
                AchievementProgressCard(state: state),
                const SizedBox(height: AppDimensions.paddingLG),
                if (unlocked.isNotEmpty) ...[
                  _sectionHeader('Unlocked (${unlocked.length})'),
                  const SizedBox(height: AppDimensions.paddingSM),
                  ...unlocked.map((a) => AchievementTile(achievement: a)),
                  const SizedBox(height: AppDimensions.paddingLG),
                ],
                if (locked.isNotEmpty) ...[
                  _sectionHeader('Locked (${locked.length})'),
                  const SizedBox(height: AppDimensions.paddingSM),
                  ...locked.map((a) => AchievementTile(achievement: a)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Text(
      text,
      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
