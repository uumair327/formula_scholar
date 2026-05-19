import 'package:equatable/equatable.dart';

import 'mastery_distribution.dart';
import 'recent_activity_item.dart';
import 'weekly_activity.dart';

class AnalyticsData extends Equatable {
  const AnalyticsData({
    required this.totalFormulas,
    required this.daysStreak,
    required this.quizAccuracy,
    required this.weeklyActivity,
    required this.masteryDistribution,
    required this.recentActivity,
  });

  final int totalFormulas;
  final int daysStreak;
  final double quizAccuracy;
  final WeeklyActivity weeklyActivity;
  final MasteryDistribution masteryDistribution;
  final List<RecentActivityItem> recentActivity;

  @override
  List<Object?> get props => [
    totalFormulas,
    daysStreak,
    quizAccuracy,
    weeklyActivity,
    masteryDistribution,
    recentActivity,
  ];
}
