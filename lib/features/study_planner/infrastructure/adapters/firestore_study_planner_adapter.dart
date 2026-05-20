import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: StudyPlannerPort)
class FirestoreStudyPlannerAdapter implements StudyPlannerPort {
  FirestoreStudyPlannerAdapter(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference _plansRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('study_plans');

  @override
  Stream<List<StudyPlan>> watchPlans(String userId) {
    AppLogger.trace('watchPlans($userId)',
        tag: AppLogTags.studyPlannerDataSource);
    return _plansRef(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_docToPlan).toList());
  }

  StudyPlan _docToPlan(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final sessionsData = (data['sessions'] as List<dynamic>? ?? [])
        .map((s) => _sessionFromMap(s as Map<String, dynamic>))
        .toList();
    return StudyPlan(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String?,
      sessions: sessionsData,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  ScheduledSession _sessionFromMap(Map<String, dynamic> data) {
    return ScheduledSession(
      id: data['id'] as String? ?? '',
      subjectId: data['subjectId'] as String? ?? '',
      chapterId: data['chapterId'] as String?,
      scheduledDate: (data['scheduledDate'] as Timestamp).toDate(),
      durationMinutes: data['durationMinutes'] as int? ?? 30,
      status: SessionStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => SessionStatus.scheduled,
      ),
      score: data['score'] as int?,
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
  Future<void> createPlan({required String userId, required StudyPlan plan}) async {
    AppLogger.trace('createPlan($userId, ${plan.id})',
        tag: AppLogTags.studyPlannerDataSource);
    await _plansRef(userId).doc(plan.id).set(_planToMap(plan));
  }

  @override
  Future<void> updatePlan({required String userId, required StudyPlan plan}) async {
    AppLogger.trace('updatePlan($userId, ${plan.id})',
        tag: AppLogTags.studyPlannerDataSource);
    await _plansRef(userId).doc(plan.id).update(_planToMap(plan));
  }

  @override
  Future<void> deletePlan({required String userId, required String planId}) async {
    AppLogger.trace('deletePlan($userId, $planId)',
        tag: AppLogTags.studyPlannerDataSource);
    await _plansRef(userId).doc(planId).delete();
  }

  @override
  Future<void> updateSessionStatus({
    required String userId,
    required String planId,
    required String sessionId,
  }) async {
    AppLogger.trace('updateSessionStatus($userId, $planId, $sessionId)',
        tag: AppLogTags.studyPlannerDataSource);
    final docRef = _plansRef(userId).doc(planId);
    final snap = await docRef.get();
    final data = snap.data() as Map<String, dynamic>?;
    if (data == null) {
      AppLogger.warning(
          'updateSessionStatus: plan $planId not found',
          tag: AppLogTags.studyPlannerDataSource);
      return;
    }
    final sessions = (data['sessions'] as List<dynamic>)
        .map((s) => Map<String, dynamic>.from(s as Map))
        .toList();
    final idx = sessions.indexWhere((s) => s['id'] == sessionId);
    if (idx == -1) {
      AppLogger.warning(
          'updateSessionStatus: session $sessionId not found in plan $planId',
          tag: AppLogTags.studyPlannerDataSource);
      return;
    }
    sessions[idx]['status'] = SessionStatus.completed.name;
    await docRef.update({'sessions': sessions, 'updatedAt': Timestamp.now()});
  }
}
