import 'package:cloud_firestore/cloud_firestore.dart';

/// Shared utility for managing the `users/{uid}/stats/current` accumulator.
///
/// Used by both the formulas and practice adapters to keep stats
/// (formulas mastered, streak, points) consistent and DRY.
class UserStatsAccumulator {
  const UserStatsAccumulator(this._firestore);
  final FirebaseFirestore _firestore;

  /// Points awarded per newly mastered formula.
  static const int pointsPerMastery = 10;

  DocumentReference<Map<String, dynamic>> _statsRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('stats')
        .doc('current');
  }

  /// Increments formulas mastered count, awards points, and bumps streak.
  Future<void> incrementMasteredFormulas(String uid, int delta) async {
    final todayKey = _dateKey(DateTime.now().toUtc());

    await _firestore.runTransaction((tx) async {
      final snapshot = await tx.get(_statsRef(uid));
      final data = snapshot.data() ?? const <String, dynamic>{};

      final currentFormulas = (data['formulas'] as num?)?.toInt() ?? 0;
      final updatedFormulas = (currentFormulas + delta).clamp(0, 1000000);

      final currentPoints = (data['points'] as num?)?.toInt() ?? 0;
      final pointsDelta = delta > 0 ? delta * pointsPerMastery : 0;
      final updatedPoints = (currentPoints + pointsDelta).clamp(0, 99999999);

      final currentStreak = (data['streak'] as num?)?.toInt() ?? 0;
      final lastStudyDate = (data['lastStudyDate'] as String?) ?? '';
      final updatedStreak = calculateNextStreak(
        lastStudyDate,
        todayKey,
        fallbackCurrentStreak: currentStreak,
      );

      tx.set(_statsRef(uid), {
        'formulas': updatedFormulas,
        'points': updatedPoints,
        'streak': updatedStreak,
        'lastStudyDate': todayKey,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  /// Bumps streak without changing formulas or points (e.g. opening a chapter).
  Future<void> touchDailyStreak(String uid) async {
    final todayKey = _dateKey(DateTime.now().toUtc());

    await _firestore.runTransaction((tx) async {
      final snapshot = await tx.get(_statsRef(uid));
      final data = snapshot.data() ?? const <String, dynamic>{};
      final lastStudyDate = (data['lastStudyDate'] as String?) ?? '';

      if (lastStudyDate == todayKey) return; // Already touched today.

      final currentStreak = (data['streak'] as num?)?.toInt() ?? 0;
      final updatedStreak = calculateNextStreak(
        lastStudyDate,
        todayKey,
        fallbackCurrentStreak: currentStreak,
      );

      tx.set(_statsRef(uid), {
        'streak': updatedStreak,
        'lastStudyDate': todayKey,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  /// Adds points (e.g. from practice quizzes) and bumps the streak.
  Future<void> addPoints(String uid, int points) async {
    final todayKey = _dateKey(DateTime.now().toUtc());

    await _firestore.runTransaction((tx) async {
      final snapshot = await tx.get(_statsRef(uid));
      final data = snapshot.data() ?? const <String, dynamic>{};

      final currentPoints = (data['points'] as num?)?.toInt() ?? 0;
      final updatedPoints = (currentPoints + points).clamp(0, 99999999);

      final currentStreak = (data['streak'] as num?)?.toInt() ?? 0;
      final lastStudyDate = (data['lastStudyDate'] as String?) ?? '';
      final updatedStreak = calculateNextStreak(
        lastStudyDate,
        todayKey,
        fallbackCurrentStreak: currentStreak,
      );

      tx.set(_statsRef(uid), {
        'points': updatedPoints,
        'streak': updatedStreak,
        'lastStudyDate': todayKey,
        'lastQuizAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  /// Calculates the next streak value based on consecutive study days.
  static int calculateNextStreak(
    String lastStudyDate,
    String todayKey, {
    required int fallbackCurrentStreak,
  }) {
    if (lastStudyDate.isEmpty) return 1;
    if (lastStudyDate == todayKey) {
      return fallbackCurrentStreak > 0 ? fallbackCurrentStreak : 1;
    }
    final parsedLast = DateTime.tryParse(lastStudyDate);
    final parsedToday = DateTime.tryParse(todayKey);
    if (parsedLast == null || parsedToday == null) return 1;
    final dayDelta = parsedToday.difference(parsedLast).inDays;
    if (dayDelta == 1) return fallbackCurrentStreak + 1;
    return 1;
  }

  /// Formats a UTC [DateTime] as `YYYY-MM-DD`.
  static String _dateKey(DateTime utcDate) {
    final month = utcDate.month.toString().padLeft(2, '0');
    final day = utcDate.day.toString().padLeft(2, '0');
    return '${utcDate.year}-$month-$day';
  }
}
