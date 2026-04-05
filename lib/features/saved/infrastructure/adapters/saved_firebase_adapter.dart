import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: SavedDataSourcePort)
class SavedFirebaseAdapter implements SavedDataSourcePort {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  SavedFirebaseAdapter(this._firestore, this._firebaseAuth);

  @override
  Future<List<BookmarkedFormula>> getBookmarks() async {
    AppLogger.trace('getBookmarks() fetching from Firestore', tag: AppLogTags.savedDataSource);
    
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return [];
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return BookmarkedFormula(
        id: data['id'] ?? doc.id,
        title: data['title'] ?? '',
        subject: data['subject'] ?? '',
        formula: data['formula'] ?? '',
        savedAt: (data['savedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  @override
  Future<void> removeBookmark(String formulaId) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User must be logged in to remove a bookmark');
    }
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc(formulaId)
        .delete();
  }
}
