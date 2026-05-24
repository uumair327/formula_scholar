import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class FirestoreClientPort {
  DocumentReference<Map<String, dynamic>> doc(String path);
  CollectionReference<Map<String, dynamic>> collection(String path);
  Query collectionGroup(String path);
  WriteBatch batch();

  Future<T> execute<T>(
    Future<T> Function() operation, {
    String? tag,
    Duration timeout = const Duration(seconds: 15),
    int maxRetries = 2,
  });

  Future<T> runTransaction<T>(
    Future<T> Function(Transaction) handler, {
    String? tag,
    Duration timeout = const Duration(seconds: 15),
    int maxRetries = 2,
  });

  Stream<T> stream<T>(
    Stream<T> Function() operation, {
    String? tag,
  });
}
