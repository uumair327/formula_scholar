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
    this.completedSessions = 0,
    this.totalStudyMinutes = 0,
    this.daysActive = 0,
    this.longestStreak = 0,
  });

  final int totalFormulas;
  final int daysStreak;
  final double quizAccuracy;
  final WeeklyActivity weeklyActivity;
  final MasteryDistribution masteryDistribution;
  final List<RecentActivityItem> recentActivity;

  // Enhanced metrics
  final int completedSessions;
  final int totalStudyMinutes;
  final int daysActive;
  final int longestStreak;

  @override
  List<Object?> get props => [
    totalFormulas,
    daysStreak,
    quizAccuracy,
    weeklyActivity,
    masteryDistribution,
    recentActivity,
    completedSessions,
    totalStudyMinutes,
    daysActive,
    longestStreak,
  ];
}
