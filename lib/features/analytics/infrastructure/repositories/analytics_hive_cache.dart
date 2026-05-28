import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';

@LazySingleton(as: AnalyticsCachePort)
class AnalyticsHiveCache implements AnalyticsCachePort {
  static const String _boxName = 'analytics_cache';

  Future<Box<dynamic>> _box() => Hive.openBox<dynamic>(_boxName);

  @override
  Future<void> cacheAnalytics(AnalyticsData data) async {
    final box = await _box();
    await box.put('analytics_data', {
      'totalFormulas': data.totalFormulas,
      'daysStreak': data.daysStreak,
      'quizAccuracy': data.quizAccuracy,
      'weeklyActivity': {
        'dayLabels': data.weeklyActivity.dayLabels,
        'values': data.weeklyActivity.values,
      },
      'masteryDistribution': {
        'mastered': data.masteryDistribution.mastered,
        'inProgress': data.masteryDistribution.inProgress,
        'notStarted': data.masteryDistribution.notStarted,
      },
      'recentActivity': data.recentActivity
          .map(
            (item) => {
              'id': item.id,
              'title': item.title,
              'timeAgo': item.timeAgo,
              'iconName': item.iconName,
              'isPositive': item.isPositive,
            },
          )
          .toList(),
    });
  }

  @override
  Future<AnalyticsData?> getCachedAnalytics() async {
    final box = await _box();
    final cached = box.get('analytics_data') as Map<dynamic, dynamic>?;
    if (cached == null) return null;

    final m = Map<String, dynamic>.from(cached);
    final weeklyActivity = m['weeklyActivity'] as Map<String, dynamic>?;
    final masteryDistribution =
        m['masteryDistribution'] as Map<String, dynamic>?;
    final recentActivity =
        (m['recentActivity'] as List<dynamic>?)
            ?.map((item) => Map<String, dynamic>.from(item as Map))
            .map(
              (item) => RecentActivityItem(
                id: item['id'] as String? ?? '',
                title: item['title'] as String? ?? '',
                timeAgo: item['timeAgo'] as String? ?? '',
                iconName: item['iconName'] as String? ?? '',
                isPositive: item['isPositive'] as bool? ?? false,
              ),
            )
            .toList() ??
        [];

    return AnalyticsData(
      totalFormulas: m['totalFormulas'] as int? ?? 0,
      daysStreak: m['daysStreak'] as int? ?? 0,
      quizAccuracy: (m['quizAccuracy'] as num?)?.toDouble() ?? 0.0,
      weeklyActivity: WeeklyActivity(
        dayLabels:
            (weeklyActivity?['dayLabels'] as List<dynamic>?)?.cast<String>() ??
            [],
        values:
            (weeklyActivity?['values'] as List<dynamic>?)?.cast<int>() ?? [],
      ),
      masteryDistribution: MasteryDistribution(
        mastered: masteryDistribution?['mastered'] as int? ?? 0,
        inProgress: masteryDistribution?['inProgress'] as int? ?? 0,
        notStarted: masteryDistribution?['notStarted'] as int? ?? 0,
      ),
      recentActivity: recentActivity,
    );
  }
}
