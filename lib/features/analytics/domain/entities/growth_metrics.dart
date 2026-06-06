import 'package:equatable/equatable.dart';

class GrowthMetrics extends Equatable {
  const GrowthMetrics({
    required this.totalSessions,
    required this.totalStudyMinutes,
    required this.daysActive,
    required this.currentStreak,
    required this.longestStreak,
    required this.weeklyGrowth,
    required this.monthlyGrowth,
    required this.subjectBreakdown,
  });

  final int totalSessions;
  final int totalStudyMinutes;
  final int daysActive;
  final int currentStreak;
  final int longestStreak;
  final List<WeeklyGrowthPoint> weeklyGrowth;
  final List<MonthlyGrowthPoint> monthlyGrowth;
  final List<SubjectPerformance> subjectBreakdown;

  @override
  List<Object?> get props => [
    totalSessions,
    totalStudyMinutes,
    daysActive,
    currentStreak,
    longestStreak,
    weeklyGrowth,
    monthlyGrowth,
    subjectBreakdown,
  ];
}

class WeeklyGrowthPoint extends Equatable {
  const WeeklyGrowthPoint({
    required this.weekLabel,
    required this.sessions,
    required this.minutes,
    required this.accuracy,
    required this.formulasLearned,
  });

  final String weekLabel;
  final int sessions;
  final int minutes;
  final double accuracy;
  final int formulasLearned;

  @override
  List<Object?> get props => [
    weekLabel,
    sessions,
    minutes,
    accuracy,
    formulasLearned,
  ];
}

class MonthlyGrowthPoint extends Equatable {
  const MonthlyGrowthPoint({
    required this.monthLabel,
    required this.sessions,
    required this.minutes,
    required this.accuracy,
    required this.formulasLearned,
    required this.newUsers,
  });

  final String monthLabel;
  final int sessions;
  final int minutes;
  final double accuracy;
  final int formulasLearned;
  final int newUsers;

  @override
  List<Object?> get props => [
    monthLabel,
    sessions,
    minutes,
    accuracy,
    formulasLearned,
    newUsers,
  ];
}

class SubjectPerformance extends Equatable {
  const SubjectPerformance({
    required this.subjectId,
    required this.subjectName,
    required this.iconName,
    required this.colorValue,
    required this.sessionsCompleted,
    required this.accuracy,
    required this.formulasMastered,
    required this.totalFormulas,
    required this.streakDays,
    required this.lastStudied,
  });

  final String subjectId;
  final String subjectName;
  final String iconName;
  final int colorValue;
  final int sessionsCompleted;
  final double accuracy;
  final int formulasMastered;
  final int totalFormulas;
  final int streakDays;
  final DateTime? lastStudied;

  double get masteryPercentage =>
      totalFormulas > 0 ? (formulasMastered / totalFormulas) * 100 : 0;

  String get performanceLevel {
    if (accuracy >= 0.9) return 'excellent';
    if (accuracy >= 0.7) return 'good';
    if (accuracy >= 0.5) return 'average';
    return 'needs_improvement';
  }

  @override
  List<Object?> get props => [
    subjectId,
    subjectName,
    sessionsCompleted,
    accuracy,
    formulasMastered,
    totalFormulas,
    streakDays,
    lastStudied,
  ];
}
