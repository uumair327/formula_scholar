import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Firebase adapter for formula data retrieval.
///
/// Reads formulas from `subjects/{subjectId}/chapters/{chapterId}/formulas`.
/// Falls back to seeding mock formulas if the subcollection is empty,
/// guaranteeing the UI always has data to display.
@LazySingleton(as: FormulasDataSourcePort)
class FormulasFirebaseAdapter implements FormulasDataSourcePort {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FormulasFirebaseAdapter(this._firestore, this._firebaseAuth);

  @override
  Future<List<Formula>> getFormulas(String subjectId, String chapterId) async {
    AppLogger.trace(
      'getFormulas($subjectId, $chapterId) fetching from Firestore',
      tag: AppLogTags.formulasDataSource,
    );

    final snapshot = await _firestore
        .collection('subjects')
        .doc(subjectId)
        .collection('chapters')
        .doc(chapterId)
        .collection('formulas')
        .get();

    Set<String> bookmarkedIds = {};
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      final bookmarksSnap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookmarks')
          .get();
      bookmarkedIds = bookmarksSnap.docs.map((d) => d.id).toSet();
    }

    if (snapshot.docs.isEmpty) {
      // Seed representative formulas if the subcollection doesn't exist yet
      await _seedFormulas(subjectId, chapterId);
      final reFetch = await _firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .collection('formulas')
          .get();
      return reFetch.docs
          .map((doc) => _docToFormula(doc, bookmarkedIds.contains(doc.id)))
          .toList();
    }

    return snapshot.docs
        .map((doc) => _docToFormula(doc, bookmarkedIds.contains(doc.id)))
        .toList();
  }

  Formula _docToFormula(QueryDocumentSnapshot doc, bool isBookmarked) {
    final data = doc.data() as Map<String, dynamic>;
    return Formula(
      id: data['id'] ?? doc.id,
      title: data['title'] ?? '',
      latex: data['latex'] ?? '',
      description: data['description'] ?? '',
      isMastered: data['isMastered'] ?? false,
      isBookmarked: isBookmarked,
    );
  }

  @override
  Future<void> toggleBookmark(Formula formula, String subjectName) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User must be logged in to bookmark formulas');
    }

    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc(formula.id);

    if (formula.isBookmarked) {
      await docRef.delete();
      AppLogger.info(
        'Removed bookmark for ${formula.id}',
        tag: AppLogTags.formulasDataSource,
      );
    } else {
      await docRef.set({
        'id': formula.id,
        'title': formula.title,
        'subject': subjectName,
        'formula': formula.latex,
        'savedAt': FieldValue.serverTimestamp(),
      });
      AppLogger.info(
        'Added bookmark for ${formula.id}',
        tag: AppLogTags.formulasDataSource,
      );
    }
  }

  Future<void> _seedFormulas(String subjectId, String chapterId) async {
    AppLogger.info(
      'Seeding formulas for $subjectId/$chapterId',
      tag: AppLogTags.formulasDataSource,
    );

    final batch = _firestore.batch();
    final ref = _firestore
        .collection('subjects')
        .doc(subjectId)
        .collection('chapters')
        .doc(chapterId)
        .collection('formulas');

    final seedData = [
      {
        'id': 'f1',
        'title': 'Core Identity I',
        'latex': r'(a + b)^2 = a^2 + 2ab + b^2',
        'description':
            'Square of a binomial sum — the most fundamental algebraic expansion.',
        'isMastered': true,
      },
      {
        'id': 'f2',
        'title': 'Core Identity II',
        'latex': r'(a - b)^2 = a^2 - 2ab + b^2',
        'description': 'Square of a binomial difference.',
        'isMastered': true,
      },
      {
        'id': 'f3',
        'title': 'Difference of Squares',
        'latex': r'a^2 - b^2 = (a+b)(a-b)',
        'description': 'Factoring a difference of two perfect squares.',
        'isMastered': false,
      },
      {
        'id': 'f4',
        'title': 'Cubic Sum',
        'latex': r'(a+b)^3 = a^3 + 3a^2b + 3ab^2 + b^3',
        'description': 'Expansion of the cube of a binomial sum.',
        'isMastered': false,
      },
    ];

    for (final f in seedData) {
      batch.set(ref.doc(f['id'] as String), f);
    }
    await batch.commit();
  }
}
