import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: CurriculumDataSourcePort)
class CurriculumFirebaseAdapter implements CurriculumDataSourcePort {
  const CurriculumFirebaseAdapter(this._firestore, this._firebaseAuth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<SelectedCurriculum?> loadCurriculum() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return null;
    }

    final snapshot = await _firestore.collection('users').doc(uid).get();
    return _mapCurriculum(snapshot.data());
  }

  @override
  Future<void> saveCurriculum(SelectedCurriculum curriculum) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const ServerException(message: 'No authenticated user found');
    }

    await _firestore.collection('users').doc(uid).set({
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
    }, SetOptions(merge: true));
  }

  @override
  Stream<SelectedCurriculum?> watchCurriculum() {
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

          documentSubscription = _firestore
              .collection('users')
              .doc(user.uid)
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
