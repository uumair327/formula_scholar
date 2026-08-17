import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/streak_cubit.dart';
import '../widgets/streak_calendar.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key, required this.currentStreak});

  final int currentStreak;

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StreakCubit>()..init(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              LucideIcons.x,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Streak',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.share_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                // Share functionality
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Tabs
            TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
              tabs: const [
                Tab(text: 'PERSONAL'),
                Tab(text: 'FRIENDS'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _PersonalStreakView(currentStreak: widget.currentStreak),
                  const Center(child: Text('Friends Feature Coming Soon')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonalStreakView extends StatelessWidget {
  const _PersonalStreakView({required this.currentStreak});

  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Orange Header Box with Flame
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingXXL,
              horizontal: AppDimensions.paddingXL,
            ),
            color: Colors.orange.shade700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSM,
                        vertical: AppDimensions.paddingXXS,
                      ),
                      decoration: BoxDecoration(
                        color: currentStreak >= 365 
                            ? Colors.orange.shade300 
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (currentStreak < 365) ...[
                            Icon(
                              LucideIcons.lock,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            currentStreak >= 365 ? 'ALPHA WOLF PACK' : 'ALPHA WOLF PACK (Unlocks at 365)',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: currentStreak >= 365 
                                  ? Colors.orange.shade900 
                                  : Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),
                    Text(
                      currentStreak.toString(),
                      style: AppTextStyles.displayLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 64,
                        height: 1,
                      ),
                    ),
                    Text(
                      'day streak!',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  LucideIcons.flame,
                  size: 100,
                  color: Colors.orange.shade300,
                ),
              ],
            ),
          ),
          
          // Calendar Section
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak Calendar',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                BlocBuilder<StreakCubit, StreakState>(
                  builder: (context, state) {
                    if (state.status == StreakStatus.loading && state.currentMonthHistory == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == StreakStatus.error && state.currentMonthHistory == null) {
                      return Center(child: Text(state.errorMessage ?? 'Error loading calendar'));
                    }

                    final join = state.joinDate;
                    bool canGoPrev = true;
                    if (join != null) {
                      if (state.viewingYear < join.year || (state.viewingYear == join.year && state.viewingMonth <= join.month)) {
                        canGoPrev = false;
                      }
                    }
                    
                    return StreakCalendar(
                      year: state.viewingYear,
                      month: state.viewingMonth,
                      history: state.currentMonthHistory,
                      joinDate: state.joinDate,
                      canGoPrevious: canGoPrev,
                      onPrevious: () => context.read<StreakCubit>().previousMonth(),
                      onNext: () => context.read<StreakCubit>().nextMonth(),
                    );
                  },
                ),
                
                const SizedBox(height: AppDimensions.paddingXL),
                
                // Freezes info
                BlocBuilder<StreakCubit, StreakState>(
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingMD),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppDimensions.paddingSM),
                            decoration: const BoxDecoration(
                              color: Colors.lightBlueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.ac_unit_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.paddingMD),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Streak Freezes: ${state.availableFreezes}',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Freezes protect your streak if you miss a day.',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                
                // How Streaks Work info
                Text(
                  'How Streaks Work',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMD),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            LucideIcons.flame,
                            color: Colors.orangeAccent,
                            size: 24,
                          ),
                          const SizedBox(width: AppDimensions.paddingMD),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Extend your streak',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Your streak grows with every consecutive day you study for at least 5 minutes or complete a module. The counter resets at midnight local time.',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.ac_unit_rounded,
                            color: Colors.lightBlueAccent,
                            size: 24,
                          ),
                          const SizedBox(width: AppDimensions.paddingMD),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Streak Freezes',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Missing a day will automatically consume a freeze if you have one available. Otherwise, your streak resets to 0!',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
