import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/app_strings.dart';
import '../../core/error/exceptions.dart';
import '../../core/utils/app_logger.dart';
import 'firestore_client_port.dart';
import 'network_info_port.dart';

@LazySingleton(as: FirestoreClientPort)
class FirestoreApiClient implements FirestoreClientPort {
  FirestoreApiClient(this._firestore, this._networkInfo, this._auth);

  final FirebaseFirestore _firestore;
  final NetworkInfoPort _networkInfo;
  final FirebaseAuth _auth;

  @override
  DocumentReference<Map<String, dynamic>> doc(String path) =>
      _firestore.doc(path);

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _firestore.collection(path);

  @override
  Query collectionGroup(String path) => _firestore.collectionGroup(path);

  @override
  WriteBatch batch() => _firestore.batch();

  @override
  Future<T> execute<T>(
    Future<T> Function() operation, {
    String? tag,
    Duration timeout = const Duration(seconds: 15),
    int maxRetries = 2,
  }) async {
    final uid = _auth.currentUser?.uid ?? 'anonymous';
    final effectiveTag = tag ?? 'Firestore';

    if (!await _networkInfo.isConnected) {
      AppLogger.warning('$effectiveTag: no connectivity', tag: effectiveTag);
      throw const ServerException(message: AppStrings.noInternetConnection);
    }

    var attempts = 0;
    while (true) {
      try {
        AppLogger.trace(
          '$effectiveTag: executing (attempt ${attempts + 1}) uid=$uid',
          tag: effectiveTag,
        );
        return await operation().timeout(timeout);
      } on TimeoutException {
        attempts++;
        AppLogger.warning(
          '$effectiveTag: timeout after ${timeout.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: effectiveTag,
        );
        if (attempts >= maxRetries) {
          throw const ServerException(message: AppStrings.firestoreTimeout);
        }
      } catch (e, st) {
        if (_isNonRetryable(e)) {
          AppLogger.error(
            '$effectiveTag: non-retryable error: $e',
            tag: effectiveTag,
            error: e,
            stackTrace: st,
          );
          rethrow;
        }
        attempts++;
        AppLogger.error(
          '$effectiveTag: error (attempt $attempts/$maxRetries): $e',
          tag: effectiveTag,
          error: e,
          stackTrace: st,
        );
        if (attempts >= maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: 200 * (1 << attempts)));
      }
    }
  }

  @override
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction) handler, {
    String? tag,
    Duration timeout = const Duration(seconds: 15),
    int maxRetries = 2,
  }) async {
    return execute(
      () => _firestore.runTransaction(handler),
      tag: tag,
      timeout: timeout,
      maxRetries: maxRetries,
    );
  }

  @override
  Stream<T> stream<T>(
    Stream<T> Function() operation, {
    String? tag,
  }) {
    final effectiveTag = tag ?? 'Firestore';
    return operation().handleError((Object e, StackTrace st) {
      AppLogger.error(
        '$effectiveTag: stream error: $e',
        tag: effectiveTag,
        error: e,
        stackTrace: st,
      );
    });
  }

  bool _isNonRetryable(Object e) {
    if (e is ServerException) return true;
    if (e is FirebaseException &&
        (e.code == 'permission-denied' ||
            e.code == 'not-found' ||
            e.code == 'already-exists')) {
      return true;
    }
    return false;
  }
}
