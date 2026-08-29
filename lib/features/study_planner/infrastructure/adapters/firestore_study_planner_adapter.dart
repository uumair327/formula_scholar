import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

@LazySingleton(as: StudyPlannerPort)
class FirestoreStudyPlannerAdapter implements StudyPlannerPort {
  FirestoreStudyPlannerAdapter(this._api);

  final FirestoreClientPort _api;

  CollectionReference _plansRef(String userId) =>
      _api.collection(AppFirestoreCollections.userStudyPlans(userId));

  @override
  Stream<List<StudyPlan>> watchPlans(String userId) {
    AppLogger.trace(
      'watchPlans($userId)',
      tag: AppLogTags.studyPlannerDataSource,
    );
    return _api.stream(
      () => _plansRef(userId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map(_docToPlan).toList()),
      tag: AppLogTags.studyPlannerDataSource,
    );
  }

  DateTime _parseDate(dynamic d) {
    if (d is Timestamp) return d.toDate();
    if (d is String) return DateTime.tryParse(d) ?? DateTime.now();
    return DateTime.now();
  }

  StudyPlan _docToPlan(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final sessionsData = (data['sessions'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((s) => _sessionFromMap(Map<String, dynamic>.from(s)))
        .toList();
    return StudyPlan(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String?,
      sessions: sessionsData,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
    );
  }

  ScheduledSession _sessionFromMap(Map<String, dynamic> data) {
    return ScheduledSession(
      id: data['id'] as String? ?? '',
      subjectId: data['subjectId'] as String? ?? '',
      chapterId: data['chapterId'] as String?,
      scheduledDate: _parseDate(data['scheduledDate']),
      durationMinutes: (data['durationMinutes'] as num?)?.toInt() ?? 30,
      status: SessionStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => SessionStatus.scheduled,
      ),
      score: (data['score'] as num?)?.toInt(),
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> _planToMap(StudyPlan plan) {
    return {
      'title': plan.title,
      'description': plan.description,
      'sessions': plan.sessions.map(_sessionToMap).toList(),
      'isActive': plan.isActive,
      'createdAt': Timestamp.fromDate(plan.createdAt),
      'updatedAt': Timestamp.fromDate(plan.updatedAt),
    };
  }

  Map<String, dynamic> _sessionToMap(ScheduledSession session) {
    return {
      'id': session.id,
      'subjectId': session.subjectId,
      'chapterId': session.chapterId,
      'scheduledDate': Timestamp.fromDate(session.scheduledDate),
      'durationMinutes': session.durationMinutes,
      'status': session.status.name,
      'score': session.score,
      'notes': session.notes,
    };
  }

  @override
  Future<void> createPlan({
    required String userId,
    required StudyPlan plan,
  }) async {
    AppLogger.trace(
      'createPlan($userId, ${plan.id})',
      tag: AppLogTags.studyPlannerDataSource,
    );
    await _api.execute(
      () => _plansRef(userId).doc(plan.id).set(_planToMap(plan)),
      tag: AppLogTags.studyPlannerDataSource,
    );
  }

  @override
  Future<void> updatePlan({
    required String userId,
    required StudyPlan plan,
  }) async {
    AppLogger.trace(
      'updatePlan($userId, ${plan.id})',
      tag: AppLogTags.studyPlannerDataSource,
    );
    await _api.execute(
      () => _plansRef(userId).doc(plan.id).set(
        _planToMap(plan),
        SetOptions(merge: true),
      ),
      tag: AppLogTags.studyPlannerDataSource,
    );
  }

  @override
  Future<void> deletePlan({
    required String userId,
    required String planId,
  }) async {
    AppLogger.trace(
      'deletePlan($userId, $planId)',
      tag: AppLogTags.studyPlannerDataSource,
    );
    await _api.execute(
      () => _plansRef(userId).doc(planId).delete(),
      tag: AppLogTags.studyPlannerDataSource,
    );
  }

  @override
  Future<void> updateSessionStatus({
    required String userId,
    required String planId,
    required String sessionId,
    SessionStatus? status,
  }) async {
    AppLogger.trace(
      'updateSessionStatus($userId, $planId, $sessionId, status: $status)',
      tag: AppLogTags.studyPlannerDataSource,
    );
    final docRef = _plansRef(userId).doc(planId);
    final snap = await _api.execute(
      () => docRef.get(),
      tag: AppLogTags.studyPlannerDataSource,
    );
    final data = snap.data() as Map<String, dynamic>?;
    if (data == null) {
      AppLogger.warning(
        'updateSessionStatus: plan $planId not found',
        tag: AppLogTags.studyPlannerDataSource,
      );
      return;
    }
    final sessions = (data['sessions'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((s) => Map<String, dynamic>.from(s))
        .toList();
    final idx = sessions.indexWhere((s) => s['id'] == sessionId);
    if (idx == -1) {
      AppLogger.warning(
        'updateSessionStatus: session $sessionId not found in plan $planId',
        tag: AppLogTags.studyPlannerDataSource,
      );
      return;
    }

    final currentStatusStr = sessions[idx]['status'] as String?;
    final targetStatus = status?.name ??
        (currentStatusStr == SessionStatus.completed.name
            ? SessionStatus.scheduled.name
            : SessionStatus.completed.name);

    sessions[idx]['status'] = targetStatus;
    await _api.execute(
      () => docRef.set({
        'sessions': sessions,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true)),
      tag: AppLogTags.studyPlannerDataSource,
    );
  }
}
