import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../core/core.dart';

@LazySingleton(as: CurriculumDataSourcePort)
class CurriculumFirebaseAdapter implements CurriculumDataSourcePort {
  const CurriculumFirebaseAdapter(this._api, this._firebaseAuth);
  final FirestoreClientPort _api;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<SelectedCurriculum?> loadCurriculum() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      AppLogger.trace(
        'loadCurriculum: no authenticated user',
        tag: AppLogTags.curriculumDataSource,
      );
      return null;
    }

    AppLogger.trace(
      'loadCurriculum: uid=$uid',
      tag: AppLogTags.curriculumDataSource,
    );
    final snapshot = await _api.execute(
      () => _api.doc(AppFirestoreCollections.userDoc(uid)).get(),
      tag: AppLogTags.curriculumDataSource,
    );
    final curriculum = _mapCurriculum(snapshot.data());
    AppLogger.trace(
      'loadCurriculum: ${curriculum != null ? "found" : "not found"}',
      tag: AppLogTags.curriculumDataSource,
    );
    return curriculum;
  }

  @override
  Future<void> saveCurriculum(SelectedCurriculum curriculum) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const ServerException(message: 'No authenticated user found');
    }

    AppLogger.trace(
      'saveCurriculum: uid=$uid, board=${curriculum.boardId}, grade=${curriculum.gradeId}',
      tag: AppLogTags.curriculumDataSource,
    );

    await _api.execute(
      () => _api.doc(AppFirestoreCollections.userDoc(uid)).set({
        'boardId': curriculum.boardId,
        'boardName': curriculum.boardName,
        'gradeId': curriculum.gradeId,
        'gradeLabel': _canonicalGradeLabel(
          curriculum.gradeLabel,
          curriculum.gradeNumber,
        ),
        'gradeNumber': curriculum.gradeNumber,
        'countryId': curriculum.countryId,
        'stateId': curriculum.stateId,
        'countryName': curriculum.countryName,
        'stateName': curriculum.stateName,
      }, SetOptions(merge: true)),
      tag: AppLogTags.curriculumDataSource,
    );
  }

  @override
  Stream<SelectedCurriculum?> watchCurriculum() {
    return _api.stream(() {
      return Stream<SelectedCurriculum?>.multi((controller) {
        StreamSubscription<User?>? authSubscription;
        StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
        documentSubscription;

        Future<void> cancelDocumentSubscription() async {
          await documentSubscription?.cancel();
          documentSubscription = null;
        }

        authSubscription = _firebaseAuth.authStateChanges().listen(
          (user) async {
            await cancelDocumentSubscription();
            if (user == null) {
              controller.add(null);
              return;
            }

            documentSubscription = _api
                .doc(AppFirestoreCollections.userDoc(user.uid))
                .snapshots()
                .listen(
                  (snapshot) => controller.add(_mapCurriculum(snapshot.data())),
                  onError: controller.addError,
                );
          },
          onError: controller.addError,
          onDone: () async {
            await cancelDocumentSubscription();
            await controller.close();
          },
        );

        controller.onCancel = () async {
          await cancelDocumentSubscription();
          await authSubscription?.cancel();
        };
      });
    }, tag: AppLogTags.curriculumDataSource);
  }

  SelectedCurriculum? _mapCurriculum(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final boardId = data['boardId']?.toString();
    final boardName = data['boardName']?.toString();
    final gradeId = data['gradeId']?.toString();
    final gradeLabel = data['gradeLabel']?.toString();
    final gradeNumber = int.tryParse(data['gradeNumber']?.toString() ?? '');
    final countryId = data['countryId']?.toString();
    final stateId = data['stateId']?.toString();
    final countryName = data['countryName']?.toString();
    final stateName = data['stateName']?.toString();

    if (boardId == null ||
        boardName == null ||
        gradeId == null ||
        gradeLabel == null ||
        gradeNumber == null) {
      return null;
    }

    return SelectedCurriculum(
      boardId: boardId,
      boardName: boardName,
      gradeId: gradeId,
      gradeLabel: _canonicalGradeLabel(gradeLabel, gradeNumber),
      gradeNumber: gradeNumber,
      countryId: countryId,
      stateId: stateId,
      countryName: countryName,
      stateName: stateName,
    );
  }

  String _canonicalGradeLabel(String? gradeLabel, int gradeNumber) {
    if (gradeNumber > 0) {
      return 'Class $gradeNumber';
    }

    final cleaned = gradeLabel?.trim() ?? '';
    return cleaned.isEmpty ? AppStrings.unknownGrade : cleaned;
  }
}
