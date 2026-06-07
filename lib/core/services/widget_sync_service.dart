import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

/// Service responsible for syncing app state data to native home screen widgets.
class WidgetSyncService {
  static const String appGroupId = 'group.app.formulascholar.widgets';
  
  static const String iOSStreakWidgetName = 'StreakCalendarWidget';
  static const String androidStreakWidgetName = 'StreakWidgetProvider';

  static const String iOSPlannerWidgetName = 'StudyPlannerWidget';
  static const String androidPlannerWidgetName = 'PlannerWidgetProvider';

  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
      
      // Handle app opened from a widget when the app was terminated
      final initialUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      if (initialUri != null) {
        _handleWidgetRouting(initialUri);
      }

      // Handle app opened from a widget while app is running
      HomeWidget.widgetClicked.listen(_handleWidgetRouting);

      debugPrint('WidgetSyncService: Initialized successfully.');
    } catch (e) {
      debugPrint('WidgetSyncService: Failed to initialize. Error: $e');
    }
  }

  static void _handleWidgetRouting(Uri? uri) {
    if (uri == null) return;
    try {
      final host = uri.host;
      if (host == 'streak') {
        // AppRouter.router.go(AppRoutes.profilePath) // Depending on where streak is shown
      } else if (host == 'planner') {
        // AppRouter.router.go(AppRoutes.studyPlannerPath)
      }
    } catch (e) {
      debugPrint('Widget routing failed: $e');
    }
  }

  /// Updates the Streak Calendar Widget data.
  /// Converts the streak details into a JSON payload for the native side.
  static Future<void> updateStreakWidget({
    required bool isLoggedIn,
    required int currentStreak,
    required int maxStreak,
    required Map<String, bool> weekHistory, // e.g. {"Mon": true, "Tue": false, ...}
  }) async {
    try {
      final payload = {
        'isLoggedIn': isLoggedIn,
        'currentStreak': currentStreak,
        'maxStreak': maxStreak,
        'weekHistory': weekHistory,
      };

      await HomeWidget.saveWidgetData<String>('streak_data', jsonEncode(payload));
      
      // Update iOS Widget
      await HomeWidget.updateWidget(
        iOSName: iOSStreakWidgetName,
      );
      
      // Update Android Widget
      await HomeWidget.updateWidget(
        androidName: androidStreakWidgetName,
      );

      debugPrint('WidgetSyncService: Streak widget updated successfully.');
    } catch (e) {
      debugPrint('WidgetSyncService: Failed to update streak widget. Error: $e');
    }
  }

  /// Updates the Study Planner Widget data.
  /// Converts the upcoming tasks into a JSON payload for the native side.
  static Future<void> updatePlannerWidget({
    required bool isLoggedIn,
    required List<Map<String, dynamic>> upcomingTasks,
  }) async {
    try {
      final payload = {
        'isLoggedIn': isLoggedIn,
        'tasks': upcomingTasks,
      };

      await HomeWidget.saveWidgetData<String>('planner_data', jsonEncode(payload));
      
      // Update iOS Widget
      await HomeWidget.updateWidget(
        iOSName: iOSPlannerWidgetName,
      );
      
      // Update Android Widget
      await HomeWidget.updateWidget(
        androidName: androidPlannerWidgetName,
      );

      debugPrint('WidgetSyncService: Planner widget updated successfully.');
    } catch (e) {
      debugPrint('WidgetSyncService: Failed to update planner widget. Error: $e');
    }
  }
}
