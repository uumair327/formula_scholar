import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../core/core.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';

@lazySingleton
class DashboardCommandListener {
  DashboardCommandListener(this._api);

  final FirestoreClientPort _api;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  final DateTime _appStartTime = DateTime.now();
  final Set<String> _processedCommandIds = {};

  void startListening() {
    if (_subscription != null) return;

    AppLogger.info(
      'Starting real-time Dashboard Command Listener (appStartTime: $_appStartTime)',
      tag: 'DashboardCommandListener',
    );

    // Listen to changes in the dashboard_commands collection
    _subscription = _api
        .collection('dashboard_commands')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(_appStartTime))
        .snapshots()
        .listen(
      (snapshot) async {
        for (final change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final doc = change.doc;
            final data = doc.data();
            if (data == null) continue;

            final commandId = data['commandId'] as String?;
            final status = data['status'] as String?;
            final docId = doc.id;



            if (_processedCommandIds.contains(docId)) continue;
            _processedCommandIds.add(docId);

            AppLogger.info(
              'Received dashboard command: $commandId (docId: $docId, status: $status)',
              tag: 'DashboardCommandListener',
            );

            if (commandId == 'force-refresh') {
              await _handleForceRefresh();
            }
          }
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.error(
          'Error in Dashboard Command Listener stream',
          tag: 'DashboardCommandListener',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  Future<void> _handleForceRefresh() async {
    AppLogger.info(
      'Executing force-refresh command: Clearing client caches & refreshing dashboard data',
      tag: 'DashboardCommandListener',
    );

    try {
      // Invalidate local Hive caches
      await _clearHiveCache('dashboard_cache');
      await _clearHiveCache('chapters_cache');
      await _clearHiveCache('formulas_cache');
      await _clearHiveCache('practice_cache');

      AppLogger.info(
        'Client caches cleared successfully. Triggering dashboard load...',
        tag: 'DashboardCommandListener',
      );

      // Force DashboardCubit to reload
      if (getIt.isRegistered<DashboardCubit>()) {
        await getIt<DashboardCubit>().retryLoadDashboard();
      }
    } catch (e, st) {
      AppLogger.error(
        'Failed to fully execute force-refresh command',
        tag: 'DashboardCommandListener',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> _clearHiveCache(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).clear();
      } else {
        final box = await Hive.openBox(boxName);
        await box.clear();
        await box.close();
      }
      AppLogger.debug('Cleared Hive box: $boxName', tag: 'DashboardCommandListener');
    } catch (e) {
      AppLogger.warning('Failed to clear Hive box $boxName: $e', tag: 'DashboardCommandListener');
    }
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    AppLogger.info('Stopped Dashboard Command Listener', tag: 'DashboardCommandListener');
  }
}
