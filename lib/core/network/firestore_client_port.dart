import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formula_scholar/core/config/app_api.dart';

abstract interface class FirestoreClientPort {
  DocumentReference<Map<String, dynamic>> doc(String path);
  CollectionReference<Map<String, dynamic>> collection(String path);
  Query collectionGroup(String path);
  WriteBatch batch();

  Future<T> execute<T>(
    Future<T> Function() operation, {
    String? tag,
    Duration timeout = AppApiConfig.timeout,
    int maxRetries = AppApiConfig.maxRetries,
  });

  Future<T> runTransaction<T>(
    Future<T> Function(Transaction) handler, {
    String? tag,
    Duration timeout = AppApiConfig.timeout,
    int maxRetries = AppApiConfig.maxRetries,
  });

  Stream<T> stream<T>(Stream<T> Function() operation, {String? tag});
}
