import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

@LazySingleton(as: AnalyticsDataSourcePort)
class AnalyticsFirebaseAdapter implements AnalyticsDataSourcePort {
  AnalyticsFirebaseAdapter(this._api, this._auth);

  final FirestoreClientPort _api;
  final FirebaseAuth _auth;

  @override
  Future<AnalyticsData> fetchAnalytics() async {
    AppLogger.trace(
      'fetchAnalytics started',
      tag: AppLogTags.analyticsDataSource,
    );

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return _emptyAnalytics();
    }

    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final monthAgo = now.subtract(const Duration(days: 30));

    final results = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userQuizResults(userId))
          .orderBy('completedAt', descending: true)
          .limit(100)
          .get(),
      tag: AppLogTags.analyticsDataSource,
    );

    final weekResults = results.docs.where((d) {
      final ts = _parseDate(d.data()['completedAt']);
      return ts != null && ts.isAfter(weekAgo);
    }).toList();

    final monthResults = results.docs.where((d) {
      final ts = _parseDate(d.data()['completedAt']);
      return ts != null && ts.isAfter(monthAgo);
    }).toList();

    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayValues = List.filled(7, 0);

    for (final doc in weekResults) {
      final ts = _parseDate(doc.data()['completedAt']);
      if (ts == null) continue;
      final day = ts.weekday - 1;
      if (day >= 0 && day < 7) {
        dayValues[day] += (doc.data()['totalQuestions'] as num?)?.toInt() ?? 0;
      }
    }

    var totalQuestions = 0;
    var correctQuestions = 0;
    for (final doc in results.docs) {
      final data = doc.data();
      totalQuestions += (data['totalQuestions'] as num?)?.toInt() ?? 0;
      correctQuestions += (data['correctCount'] as num?)?.toInt() ?? 0;
    }
    final accuracy =
        totalQuestions > 0 ? correctQuestions / totalQuestions : 0.0;

    var totalFormulas = 0;
    try {
      final totalFormulasSnap = await _api.execute(
        () => _api
            .collectionGroup(AppFirestoreCollections.formulas)
            .where('isActive', isEqualTo: true)
            .count()
            .get(),
        tag: AppLogTags.analyticsDataSource,
      );
      totalFormulas = totalFormulasSnap.count ?? 0;
    } catch (e) {
      totalFormulas = await _fetchFormulaCountFallback();
    }

    // Real mastery distribution from user progress
    final masteryData = await _fetchRealMasteryDistribution(userId);
    final streakDoc = await _api.execute(
      () => _api
          .doc(AppFirestoreCollections.userStatsStreak(userId))
          .get(),
      tag: AppLogTags.analyticsDataSource,
    );
    final daysStreak =
        (streakDoc.data()?['currentStreak'] as num?)?.toInt() ?? 0;

    final recentList = results.docs.take(10).map((doc) {
      final data = doc.data();
      final ts = _parseDate(data['completedAt']) ?? now;
      final diff = now.difference(ts);
      final timeAgo = diff.inDays > 1
          ? '${diff.inDays} days ago'
          : diff.inHours > 1
              ? '${diff.inHours} hours ago'
              : '${diff.inMinutes} minutes ago';
      final correct = (data['correctCount'] as num?)?.toInt() ?? 0;
      final total = (data['totalQuestions'] as num?)?.toInt() ?? 0;
      final subjectName = data['subjectName'] as String? ?? '';
      return RecentActivityItem(
        id: doc.id,
        title: subjectName.isNotEmpty
            ? '$subjectName: $correct/$total correct'
            : 'Quiz: $correct/$total correct',
        timeAgo: timeAgo,
        iconName: correct >= total * 0.8 ? 'check_circle' : 'trending_up',
        isPositive: correct >= total * 0.5,
      );
    }).toList();

    final completedSessions = results.docs.length;
    final totalMinutes = monthResults.fold<int>(
      0,
      (total, d) =>
          total +
          ((d.data()['durationSeconds'] as num?)?.toInt() ?? 0) ~/ 60,
    );
    final uniqueDays = results.docs
        .map((d) {
          final ts = _parseDate(d.data()['completedAt']);
          return ts != null ? ts.toIso8601String().substring(0, 10) : '';
        })
        .where((s) => s.isNotEmpty)
        .toSet()
        .length;

    AppLogger.info(
      'fetchAnalytics: $totalFormulas formulas, $daysStreak day streak, '
      '${(accuracy * 100).toStringAsFixed(0)}% accuracy, '
      'mastered=${masteryData.mastered}, inProgress=${masteryData.inProgress}',
      tag: AppLogTags.analyticsDataSource,
    );

    return AnalyticsData(
      totalFormulas: totalFormulas,
      daysStreak: daysStreak,
      quizAccuracy: accuracy,
      weeklyActivity: WeeklyActivity(dayLabels: dayLabels, values: dayValues),
      masteryDistribution: masteryData,
      recentActivity: recentList,
      completedSessions: completedSessions,
      totalStudyMinutes: totalMinutes,
      daysActive: uniqueDays,
      longestStreak:
          (streakDoc.data()?['longestStreak'] as num?)?.toInt() ?? daysStreak,
    );
  }

  Future<int> _fetchFormulaCountFallback() async {
    var totalFormulas = 0;
    AppLogger.warning(
      'CollectionGroup query failed for formulas, falling back to chunked queries',
      tag: AppLogTags.analyticsDataSource,
    );

    final subjects = await _api.execute(
      () => _api.collection(AppFirestoreCollections.subjects).get(),
      tag: AppLogTags.analyticsDataSource,
    );

    final chapterSnapshots = await Future.wait(
      subjects.docs.map(
        (s) => _api.execute(
          () => _api
              .collection(AppFirestoreCollections.subjectChapters(s.id))
              .get(),
          tag: AppLogTags.analyticsDataSource,
        ),
      ),
    );

    final countQueryFns = <Future<AggregateQuerySnapshot> Function()>[];
    for (var i = 0; i < subjects.docs.length; i++) {
      final subjectId = subjects.docs[i].id;
      for (final chapter in chapterSnapshots[i].docs) {
        countQueryFns.add(
          () => _api.execute(
            () => _api
                .collection(
                  AppFirestoreCollections.chapterFormulas(
                    subjectId,
                    chapter.id,
                  ),
                )
                .where('isActive', isEqualTo: true)
                .count()
                .get(),
            tag: AppLogTags.analyticsDataSource,
          ),
        );
      }
    }

    for (var i = 0; i < countQueryFns.length; i += 10) {
      final chunk = countQueryFns.skip(i).take(10).map((f) => f()).toList();
      final chunkResults = await Future.wait(chunk);
      for (final r in chunkResults) {
        totalFormulas += (r.count ?? 0);
      }
    }

    return totalFormulas;
  }

  Future<MasteryDistribution> _fetchRealMasteryDistribution(
    String userId,
  ) async {
    try {
      // Fetch per-chapter formula mastery status
      final progressDocs = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.userProgressSummary(userId))
            .get(),
        tag: AppLogTags.analyticsDataSource,
      );

      if (progressDocs.docs.isNotEmpty) {
        var mastered = 0;
        var inProgress = 0;
        var notStarted = 0;

        for (final doc in progressDocs.docs) {
          final data = doc.data();
          // Try formula-level mastery in progress subcollection
          final formulasSnapshot = await _api.execute(
            () => _api
                .collection(AppFirestoreCollections.userProgressSummary(userId))
                .doc(doc.id)
                .collection('formulas')
                .get(),
            tag: AppLogTags.analyticsDataSource,
          );

          if (formulasSnapshot.docs.isNotEmpty) {
            for (final formulaDoc in formulasSnapshot.docs) {
              final status =
                  formulaDoc.data()['masteryStatus'] as String? ?? 'not_started';
              switch (status) {
                case 'mastered':
                  mastered++;
                  break;
                case 'in_progress':
                case 'reviewing':
                  inProgress++;
                  break;
                default:
                  notStarted++;
              }
            }
          } else {
            // Fallback: use chapter-level progress
            final pct =
                (data['masteryPercentage'] as num?)?.toDouble() ?? 0;
            final total = (data['totalFormulas'] as num?)?.toInt() ?? 0;
            if (total > 0) {
              mastered += (pct / 100 * total).round();
              notStarted += total - (pct / 100 * total).round();
            }
          }
        }

        final total = mastered + inProgress + notStarted;
        if (total > 0) {
          return MasteryDistribution(
            mastered: mastered,
            inProgress: inProgress,
            notStarted: notStarted,
          );
        }
      }

      // Fallback: derive from quiz accuracy
      final resultsSnap = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.userQuizResults(userId))
            .orderBy('completedAt', descending: true)
            .limit(50)
            .get(),
        tag: AppLogTags.analyticsDataSource,
      );

      var totalQ = 0;
      var correctQ = 0;
      for (final doc in resultsSnap.docs) {
        final data = doc.data();
        totalQ += (data['totalQuestions'] as num?)?.toInt() ?? 0;
        correctQ += (data['correctCount'] as num?)?.toInt() ?? 0;
      }

      final formulaCount = await _getTotalFormulaCount();
      final acc = totalQ > 0 ? correctQ / totalQ : 0.0;

      return MasteryDistribution(
        mastered: (acc * formulaCount * 0.4).round(),
        inProgress: (formulaCount * 0.35).round(),
        notStarted: formulaCount - (acc * formulaCount * 0.4).round() -
            (formulaCount * 0.35).round(),
      );
    } catch (e) {
      AppLogger.warning(
        'Failed to fetch real mastery distribution, using estimate: $e',
        tag: AppLogTags.analyticsDataSource,
      );
      return const MasteryDistribution(
        mastered: 0,
        inProgress: 0,
        notStarted: 0,
      );
    }
  }

  Future<int> _getTotalFormulaCount() async {
    try {
      final snap = await _api.execute(
        () => _api
            .collectionGroup(AppFirestoreCollections.formulas)
            .where('isActive', isEqualTo: true)
            .count()
            .get(),
        tag: AppLogTags.analyticsDataSource,
      );
      return snap.count ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<GrowthMetrics> fetchGrowthMetrics() async {
    AppLogger.trace(
      'fetchGrowthMetrics started',
      tag: AppLogTags.analyticsDataSource,
    );

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return _emptyGrowthMetrics();
    }

    final now = DateTime.now();

    // Fetch all quiz results for growth calculation
    final allResults = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userQuizResults(userId))
          .orderBy('completedAt', descending: true)
          .limit(500)
          .get(),
      tag: AppLogTags.analyticsDataSource,
    );

    final streakDoc = await _api.execute(
      () => _api
          .doc(AppFirestoreCollections.userStatsStreak(userId))
          .get(),
      tag: AppLogTags.analyticsDataSource,
    );

    // Calculate weekly growth (last 8 weeks)
    final weeklyPoints = <WeeklyGrowthPoint>[];
    for (var w = 7; w >= 0; w--) {
      final weekStart = now.subtract(Duration(days: w * 7 + 6));
      final weekEnd = now.subtract(Duration(days: w * 7));
      final weekDocs = allResults.docs.where((d) {
        final ts = _parseDate(d.data()['completedAt']);
        if (ts == null) return false;
        return ts.isAfter(weekStart) && ts.isBefore(weekEnd.add(const Duration(days: 1)));
      }).toList();

      final weekSessions = weekDocs.length;
      var weekMinutes = 0;
      var weekCorrect = 0;
      var weekTotal = 0;
      for (final doc in weekDocs) {
        final data = doc.data();
        weekMinutes += ((data['durationSeconds'] as num?)?.toInt() ?? 0) ~/ 60;
        weekCorrect += (data['correctCount'] as num?)?.toInt() ?? 0;
        weekTotal += (data['totalQuestions'] as num?)?.toInt() ?? 0;
      }

      weeklyPoints.add(WeeklyGrowthPoint(
        weekLabel: _formatWeekLabel(weekStart),
        sessions: weekSessions,
        minutes: weekMinutes,
        accuracy: weekTotal > 0 ? weekCorrect / weekTotal : 0,
        formulasLearned: weekDocs.length,
      ));
    }

    // Calculate monthly growth (last 6 months)
    final monthlyPoints = <MonthlyGrowthPoint>[];
    for (var m = 5; m >= 0; m--) {
      final monthStart = DateTime(now.year, now.month - m, 1);
      final monthEnd =
          DateTime(now.year, now.month - m + 1, 0);
      final monthDocs = allResults.docs.where((d) {
        final ts = _parseDate(d.data()['completedAt']);
        if (ts == null) return false;
        return ts.isAfter(monthStart) && ts.isBefore(monthEnd.add(const Duration(days: 1)));
      }).toList();

      var monthSessions = 0;
      var monthMinutes = 0;
      var monthCorrect = 0;
      var monthTotal = 0;
      for (final doc in monthDocs) {
        final data = doc.data();
        monthSessions++;
        monthMinutes += ((data['durationSeconds'] as num?)?.toInt() ?? 0) ~/ 60;
        monthCorrect += (data['correctCount'] as num?)?.toInt() ?? 0;
        monthTotal += (data['totalQuestions'] as num?)?.toInt() ?? 0;
      }

      monthlyPoints.add(MonthlyGrowthPoint(
        monthLabel: _formatMonthLabel(monthStart),
        sessions: monthSessions,
        minutes: monthMinutes,
        accuracy: monthTotal > 0 ? monthCorrect / monthTotal : 0,
        formulasLearned: monthSessions,
        newUsers: 0,
      ));
    }

    // Subject breakdown
    final subjects = await _api.execute(
      () => _api.collection(AppFirestoreCollections.subjects).get(),
      tag: AppLogTags.analyticsDataSource,
    );

    final subjectPerformance = <SubjectPerformance>[];
    for (final subjectDoc in subjects.docs) {
      final subData = subjectDoc.data();
      final subjectId = subjectDoc.id;
      final subjectName = subData['name'] as String? ?? '';

      final subjectResults = allResults.docs.where((d) {
        return d.data()['subjectId'] == subjectId;
      }).toList();

      if (subjectResults.isEmpty) continue;

      var subCorrect = 0;
      var subTotal = 0;
      for (final doc in subjectResults) {
        final data = doc.data();
        subCorrect += (data['correctCount'] as num?)?.toInt() ?? 0;
        subTotal += (data['totalQuestions'] as num?)?.toInt() ?? 0;
      }

      final totalFormulasInSubject =
          (subData['formulaCount'] as num?)?.toInt() ?? 0;
      final masteredInSubject =
          totalFormulasInSubject > 0
              ? ((subTotal > 0 ? subCorrect / subTotal : 0) *
                      totalFormulasInSubject *
                      0.5)
                  .round()
              : 0;

      subjectPerformance.add(SubjectPerformance(
        subjectId: subjectId,
        subjectName: subjectName,
        iconName: subData['iconName'] as String? ?? 'book-open',
        colorValue: (subData['colorValue'] as num?)?.toInt() ?? 0xFF00639A,
        sessionsCompleted: subjectResults.length,
        accuracy: subTotal > 0 ? subCorrect / subTotal : 0,
        formulasMastered: masteredInSubject,
        totalFormulas: totalFormulasInSubject,
        streakDays: 0,
        lastStudied: subjectResults.isNotEmpty
            ? _parseDate(subjectResults.first.data()['completedAt'])
            : null,
      ));
    }

    final totalSessions = allResults.docs.length;
    var totalMinutes = 0;
    for (final doc in allResults.docs) {
      totalMinutes +=
          ((doc.data()['durationSeconds'] as num?)?.toInt() ?? 0) ~/ 60;
    }
    final uniqueDays = allResults.docs
        .map((d) {
          final ts = _parseDate(d.data()['completedAt']);
          return ts != null ? ts.toIso8601String().substring(0, 10) : '';
        })
        .where((s) => s.isNotEmpty)
        .toSet()
        .length;

    return GrowthMetrics(
      totalSessions: totalSessions,
      totalStudyMinutes: totalMinutes,
      daysActive: uniqueDays,
      currentStreak:
          (streakDoc.data()?['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak:
          (streakDoc.data()?['longestStreak'] as num?)?.toInt() ?? 0,
      weeklyGrowth: weeklyPoints,
      monthlyGrowth: monthlyPoints,
      subjectBreakdown: subjectPerformance,
    );
  }

  GrowthMetrics _emptyGrowthMetrics() {
    return const GrowthMetrics(
      totalSessions: 0,
      totalStudyMinutes: 0,
      daysActive: 0,
      currentStreak: 0,
      longestStreak: 0,
      weeklyGrowth: [],
      monthlyGrowth: [],
      subjectBreakdown: [],
    );
  }

  String _formatWeekLabel(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatMonthLabel(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[date.month - 1];
  }

  AnalyticsData _emptyAnalytics() {
    return const AnalyticsData(
      totalFormulas: 0,
      daysStreak: 0,
      quizAccuracy: 0,
      weeklyActivity: WeeklyActivity(
        dayLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        values: [0, 0, 0, 0, 0, 0, 0],
      ),
      masteryDistribution: MasteryDistribution(
        mastered: 0,
        inProgress: 0,
        notStarted: 0,
      ),
      recentActivity: [],
      completedSessions: 0,
      totalStudyMinutes: 0,
      daysActive: 0,
      longestStreak: 0,
    );
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
