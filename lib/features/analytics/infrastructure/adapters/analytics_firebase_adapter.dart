import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: AnalyticsDataSourcePort)
class AnalyticsFirebaseAdapter implements AnalyticsDataSourcePort {
  AnalyticsFirebaseAdapter(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<AnalyticsData> fetchAnalytics() async {
    AppLogger.trace('fetchAnalytics started', tag: AppLogTags.analyticsDataSource);

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return _emptyAnalytics();
    }

    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final results = await _firestore
        .collection('users')
        .doc(userId)
        .collection('quiz_results')
        .orderBy('completedAt', descending: true)
        .limit(50)
        .get();

    final weekResults = results.docs.where((d) {
      final ts = (d.data()['completedAt'] as Timestamp?)?.toDate();
      return ts != null && ts.isAfter(weekAgo);
    }).toList();

    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayValues = List.filled(7, 0);

    for (final doc in weekResults) {
      final ts = (doc.data()['completedAt'] as Timestamp).toDate();
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
    final accuracy = totalQuestions > 0 ? correctQuestions / totalQuestions : 0.0;

    var totalFormulas = 0;
    final subjects = await _firestore.collection('subjects').get();
    for (final subject in subjects.docs) {
      final chapters = await _firestore
          .collection('subjects')
          .doc(subject.id)
          .collection('chapters')
          .get();
      for (final chapter in chapters.docs) {
        final formulas = await _firestore
            .collection('subjects')
            .doc(subject.id)
            .collection('chapters')
            .doc(chapter.id)
            .collection('formulas')
            .where('isActive', isEqualTo: true)
            .count()
            .get();
        totalFormulas += formulas.count ?? 0;
      }
    }

    final streakDoc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('stats')
        .doc('streak')
        .get();
    final daysStreak = (streakDoc.data()?['currentStreak'] as num?)?.toInt() ?? 0;

    final recentList = results.docs.take(5).map((doc) {
      final data = doc.data();
      final ts = (data['completedAt'] as Timestamp).toDate();
      final diff = now.difference(ts);
      final timeAgo = diff.inDays > 1
          ? '${diff.inDays} days ago'
          : diff.inHours > 1
              ? '${diff.inHours} hours ago'
              : '${diff.inMinutes} minutes ago';
      final correct = (data['correctCount'] as num?)?.toInt() ?? 0;
      final total = (data['totalQuestions'] as num?)?.toInt() ?? 0;
      return RecentActivityItem(
        id: doc.id,
        title: 'Quiz: $correct/$total correct',
        timeAgo: timeAgo,
        iconName: correct >= total * 0.8 ? 'check_circle' : 'trending_up',
        isPositive: correct >= total * 0.5,
      );
    }).toList();

    AppLogger.info(
      'fetchAnalytics: $totalFormulas formulas, $daysStreak day streak, '
      '${(accuracy * 100).toStringAsFixed(0)}% accuracy',
      tag: AppLogTags.analyticsDataSource,
    );

    return AnalyticsData(
      totalFormulas: totalFormulas,
      daysStreak: daysStreak,
      quizAccuracy: accuracy,
      weeklyActivity: WeeklyActivity(dayLabels: dayLabels, values: dayValues),
      masteryDistribution: MasteryDistribution(
        mastered: (accuracy * totalFormulas).round(),
        inProgress: totalFormulas ~/ 3,
        notStarted: totalFormulas - (accuracy * totalFormulas).round() - totalFormulas ~/ 3,
      ),
      recentActivity: recentList,
    );
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
        mastered: 0, inProgress: 0, notStarted: 0,
      ),
      recentActivity: [],
    );
  }
}
