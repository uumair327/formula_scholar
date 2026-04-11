import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: OnboardingDataSourcePort)
class OnboardingFirebaseAdapter implements OnboardingDataSourcePort {
  final FirebaseFirestore _firestore;

  OnboardingFirebaseAdapter(this._firestore);

  @override
  Future<PaginatedResponse<Country>> getCountries({
    int limit = 20,
    String? startAfterId,
  }) async {
    AppLogger.trace(
      'getCountries() fetching from Firestore',
      tag: AppLogTags.onboardingDataSource,
    );

    // Simulate pagination for brevity or implement real firestore doc snapshots
    final snapshot = await _firestore
        .collection('countries')
        .limit(limit)
        .get();

    final data = snapshot.docs.map((doc) {
      final map = doc.data();
      return Country(
        id: doc.id,
        name: map['name'] ?? '',
        isoCode: map['isoCode'] ?? doc.id,
        flagUrl: map['flagUrl'] ?? '',
      );
    }).toList();

    return PaginatedResponse(
      data: data,
      hasMore: data.length == limit,
      lastCursorId: data.isNotEmpty ? data.last.id : null,
    );
  }

  @override
  Future<PaginatedResponse<StateRegion>> getStates(
    String countryId, {
    int limit = 20,
    String? startAfterId,
  }) async {
    AppLogger.trace(
      'getStates($countryId) fetching from Firestore',
      tag: AppLogTags.onboardingDataSource,
    );
    final snapshot = await _firestore
        .collection('countries')
        .doc(countryId)
        .collection('states')
        .limit(limit)
        .get();

    final data = snapshot.docs.map((doc) {
      final map = doc.data();
      return StateRegion(
        id: doc.id,
        countryId: countryId,
        name: map['name'] ?? '',
        stateCode: map['stateCode'] ?? doc.id,
      );
    }).toList();

    return PaginatedResponse(
      data: data,
      hasMore: data.length == limit,
      lastCursorId: data.isNotEmpty ? data.last.id : null,
    );
  }

  @override
  Future<PaginatedResponse<Board>> getBoards(
    String countryId, {
    String? stateId,
    int limit = 20,
    String? startAfterId,
  }) async {
    AppLogger.trace(
      'getBoards($countryId, $stateId) fetching from Firestore',
      tag: AppLogTags.onboardingDataSource,
    );

    Query query = _firestore
        .collection('boards')
        .where('countryId', isEqualTo: countryId);

    final snapshot = await query.limit(limit).get();
    var data = snapshot.docs.map((doc) {
      final map = doc.data() as Map<String, dynamic>;

      final typeStr = map['type'] as String? ?? 'state';
      BoardType type = BoardType.state;
      if (typeStr == 'national') type = BoardType.national;
      if (typeStr == 'private') type = BoardType.private;
      if (typeStr == 'examination') type = BoardType.examination;

      return Board(
        id: doc.id,
        countryId: map['countryId'] ?? countryId,
        stateId: map['stateId'],
        type: type,
        name: map['name'] ?? '',
        description: map['description'] ?? '',
      );
    }).toList();

    if (stateId != null) {
      data = data.where((b) {
        return b.type == BoardType.national ||
            b.type == BoardType.private ||
            b.stateId == stateId;
      }).toList();
    }

    return PaginatedResponse(
      data: data,
      hasMore: data.length == limit,
      lastCursorId: data.isNotEmpty ? data.last.id : null,
    );
  }

  @override
  Future<PaginatedResponse<Grade>> getGrades(
    String boardId, {
    int limit = 20,
    String? startAfterId,
  }) async {
    AppLogger.trace(
      'getGrades($boardId) fetching from Firestore',
      tag: AppLogTags.onboardingDataSource,
    );

    final snapshot = await _firestore
        .collection('boards')
        .doc(boardId)
        .collection(
          'classes',
        ) // changed from grades to classes conceptually, or keep 'grades' in DB
        .orderBy('classNumber')
        .limit(limit)
        .get();

    final data = snapshot.docs.map((doc) {
      final map = doc.data();
      return Grade(
        id: doc.id,
        label: map['label'] ?? '',
        classNumber: map['classNumber'] ?? 0,
        subtitle: map['subtitle'],
        isPopular: map['isPopular'] ?? false,
      );
    }).toList();

    return PaginatedResponse(
      data: data,
      hasMore: data.length == limit,
      lastCursorId: data.isNotEmpty ? data.last.id : null,
    );
  }
}
