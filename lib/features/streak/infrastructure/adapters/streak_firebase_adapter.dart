import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';

@Injectable(as: StreakRepository)
class StreakFirebaseAdapter implements StreakRepository {
  StreakFirebaseAdapter({
    required FirestoreClientPort firestoreClient,
    required FirebaseAuth firebaseAuth,
  })  : _firestoreClient = firestoreClient,
        _firebaseAuth = firebaseAuth;

  final FirestoreClientPort _firestoreClient;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<Result<StreakHistoryMonth>> getMonthHistory(int year, int month) async {
    return safeOperation(
      tag: 'StreakFirebaseAdapter',
      operation: 'getMonthHistory',
      execute: () async {
        final uid = _firebaseAuth.currentUser?.uid;
        if (uid == null) throw Exception('User not logged in');
        final yearMonth = '$year-${month.toString().padLeft(2, '0')}';
      
      final snapshot = await _firestoreClient
          .doc('users/$uid/activity_history/$yearMonth')
          .get();

      if (!snapshot.exists) {
        return StreakHistoryMonth(
          year: year,
          month: month,
          activeDays: const [],
          freezeDays: const [],
        );
      }

      final data = snapshot.data()!;
      final activeDaysList = data['activeDays'] as List<dynamic>? ?? [];
      final activeDays = activeDaysList.map((e) => (e as num).toInt()).toList();
      
      final freezeDaysList = data['freezeDays'] as List<dynamic>? ?? [];
      final freezeDays = freezeDaysList.map((e) => (e as num).toInt()).toList();

      return StreakHistoryMonth(
        year: year,
        month: month,
        activeDays: activeDays,
        freezeDays: freezeDays,
      );
    });
  }

  @override
  Future<Result<DateTime?>> getJoinDate() async {
    return safeOperation(
      tag: 'StreakFirebaseAdapter',
      operation: 'getJoinDate',
      execute: () async {
        return _firebaseAuth.currentUser?.metadata.creationTime;
      },
    );
  }

  @override
  Future<Result<int>> getAvailableFreezes() async {
    return safeOperation(
      tag: 'StreakFirebaseAdapter',
      operation: 'getAvailableFreezes',
      execute: () async {
        final uid = _firebaseAuth.currentUser?.uid;
        if (uid == null) return 0;
        final snapshot = await _firestoreClient
            .doc(AppFirestoreCollections.userStatsCurrent(uid))
            .get();
      
      if (!snapshot.exists) return 0;
      final data = snapshot.data()!;
      return (data['freezes'] as num?)?.toInt() ?? 0;
    });
  }
}
