import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'widget_sync_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_firestore_collections.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      debugPrint("Native called background task: $task");

      // Initialize Firebase in background isolate
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Logged out state
        await WidgetSyncService.updateStreakWidget(
          isLoggedIn: false,
          currentStreak: 0,
          maxStreak: 0,
          weekHistory: {},
        );
        await WidgetSyncService.updatePlannerWidget(
          isLoggedIn: false,
          upcomingTasks: [],
        );
        return Future.value(true);
      }

      // Fetch real streak data from Firestore
      final streakDoc = await FirebaseFirestore.instance
          .doc(AppFirestoreCollections.userStatsStreak(user.uid))
          .get();
      
      final streakData = streakDoc.data();
      final currentStreak = (streakData?['currentStreak'] as num?)?.toInt() ?? 0;
      final maxStreak = (streakData?['longestStreak'] as num?)?.toInt() ?? 0;
      
      // We don't have weekHistory stored easily in streak doc, so we could mock it or compute it
      // For now, let's just use empty or mock. In a real app we'd fetch recent quiz results.
      
      await WidgetSyncService.updateStreakWidget(
        isLoggedIn: true,
        currentStreak: currentStreak,
        maxStreak: maxStreak,
        weekHistory: {}, // TODO: Compute actual week history
      );

      // Fetch study planner tasks
      final plannerSnapshot = await FirebaseFirestore.instance
          .collection(AppFirestoreCollections.userStudyPlans(user.uid))
          .where('isActive', isEqualTo: true)
          .get();

      final tasks = <Map<String, dynamic>>[];
      for (final doc in plannerSnapshot.docs) {
        final data = doc.data();
        final sessions = data['sessions'] as List<dynamic>? ?? [];
        for (final s in sessions) {
          if (s is Map<String, dynamic> && s['status'] != 'completed') {
            final ts = s['scheduledDate'] as Timestamp?;
            if (ts != null) {
              tasks.add({
                'id': s['id'] ?? doc.id,
                'title': data['title'] ?? 'Study Session',
                'timestamp': ts.toDate().millisecondsSinceEpoch,
              });
            }
          }
        }
      }

      // Sort tasks by time
      tasks.sort((a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int));

      await WidgetSyncService.updatePlannerWidget(
        isLoggedIn: true,
        upcomingTasks: tasks.take(3).toList(),
      );

      return Future.value(true);
    } catch (err) {
      debugPrint("BackgroundWorkerService error: $err");
      return Future.value(false); // Return false on error so Workmanager knows it failed
    }
  });
}

/// Service to manage background synchronization of data using workmanager.
class BackgroundWorkerService {
  static const String _syncTaskName = 'com.formulascholar.widgetSyncTask';

  /// Initializes WorkManager and registers the background task.
  static Future<void> initialize() async {
    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );
      
      debugPrint('BackgroundWorkerService: Initialized successfully.');
    } catch (e) {
      debugPrint('BackgroundWorkerService: Failed to initialize. Error: $e');
    }
  }

  /// Registers a periodic background task to update widgets every 15 minutes.
  static void registerPeriodicSync() {
    try {
      Workmanager().registerPeriodicTask(
        "1",
        _syncTaskName,
        frequency: const Duration(minutes: 15),
      );
      debugPrint('BackgroundWorkerService: Registered periodic sync task.');
    } catch (e) {
      debugPrint('BackgroundWorkerService: Failed to register periodic task. Error: $e');
    }
  }
}
