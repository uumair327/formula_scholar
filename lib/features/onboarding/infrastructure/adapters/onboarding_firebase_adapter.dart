import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: OnboardingDataSourcePort)
class OnboardingFirebaseAdapter implements OnboardingDataSourcePort {
  OnboardingFirebaseAdapter(this._firestore);

  final FirebaseFirestore _firestore;

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

    final query = _firestore
        .collection('boards')
        .where('countryId', isEqualTo: countryId);

    final snapshot = await query.limit(limit).get();
    var data = snapshot.docs.map((doc) {
      final map = doc.data();

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

    // Prefer the normalized `classes` path, but support legacy `grades` data.
    final classesSnapshot = await _firestore
        .collection('boards')
        .doc(boardId)
        .collection('classes')
        .orderBy('classNumber')
        .limit(limit)
        .get();

    final snapshot = classesSnapshot.docs.isNotEmpty
        ? classesSnapshot
        : await _firestore
              .collection('boards')
              .doc(boardId)
              .collection('grades')
              .orderBy('classNumber')
              .limit(limit)
              .get();

    final parsedGrades = snapshot.docs.map((doc) {
      final map = doc.data();
      final rawLabel = (map['label'] ?? '').toString();
      final classNumber = _resolveClassNumber(
        rawClassNumber: map['classNumber'],
        gradeId: doc.id,
        gradeLabel: rawLabel,
      );

      return Grade(
        id: doc.id,
        label: _canonicalGradeLabel(classNumber, rawLabel),
        classNumber: classNumber,
        subtitle: map['subtitle']?.toString(),
        isPopular: map['isPopular'] == true,
      );
    }).toList();

    final data = _deduplicateAndSortGrades(parsedGrades);

    return PaginatedResponse(
      data: data,
      hasMore: data.length == limit,
      lastCursorId: data.isNotEmpty ? data.last.id : null,
    );
  }

  List<Grade> _deduplicateAndSortGrades(List<Grade> grades) {
    final deduped = <String, Grade>{};

    for (final grade in grades) {
      final key = grade.classNumber > 0
          ? 'class_${grade.classNumber}'
          : 'label_${grade.label.toLowerCase()}';
      final existing = deduped[key];
      if (existing == null ||
          _isPreferredGrade(candidate: grade, current: existing)) {
        deduped[key] = grade;
      }
    }

    final sorted = deduped.values.toList()
      ..sort((a, b) {
        if (a.classNumber != b.classNumber) {
          if (a.classNumber == 0) {
            return 1;
          }
          if (b.classNumber == 0) {
            return -1;
          }
          return a.classNumber.compareTo(b.classNumber);
        }

        return a.label.toLowerCase().compareTo(b.label.toLowerCase());
      });

    return sorted;
  }

  bool _isPreferredGrade({required Grade candidate, required Grade current}) {
    final candidateHasCanonicalId = candidate.id.startsWith('class_');
    final currentHasCanonicalId = current.id.startsWith('class_');
    if (candidateHasCanonicalId != currentHasCanonicalId) {
      return candidateHasCanonicalId;
    }

    if (candidate.isPopular != current.isPopular) {
      return candidate.isPopular;
    }

    return candidate.label.length < current.label.length;
  }

  String _canonicalGradeLabel(int classNumber, String rawLabel) {
    if (classNumber > 0) {
      return 'Class $classNumber';
    }

    final cleaned = rawLabel.trim();
    return cleaned.isEmpty ? AppStrings.unknownGrade : cleaned;
  }

  int _resolveClassNumber({
    required Object? rawClassNumber,
    required String gradeId,
    required String gradeLabel,
  }) {
    final direct = int.tryParse(rawClassNumber?.toString() ?? '');
    if (direct != null && direct > 0) {
      return direct;
    }

    final fromId = _extractFirstNumber(gradeId);
    if (fromId != null) {
      return fromId;
    }

    final fromLabel = _extractFirstNumber(gradeLabel);
    if (fromLabel != null) {
      return fromLabel;
    }

    return 0;
  }

  int? _extractFirstNumber(String input) {
    final match = RegExp(r'(\d{1,2})').firstMatch(input);
    if (match == null) {
      return null;
    }

    return int.tryParse(match.group(1)!);
  }
}
