import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/domain.dart';
@LazySingleton(as: FlashcardCachePort)
class FlashcardHiveCache implements FlashcardCachePort {
  static const String _boxName = 'flashcard_cache';

  Future<Box<dynamic>> _box() => Hive.openBox<dynamic>(_boxName);

  String _key(String userId) => 'flashcards_$userId';

  @override
  Future<void> cacheReviews(String userId, List<Flashcard> cards) async {
    final box = await _box();
    await box.put(_key(userId), cards.map((c) => c.toJson()).toList());
  }

  @override
  Future<List<Flashcard>?> getCachedReviews(String userId) async {
    final box = await _box();
    final cached = box.get(_key(userId)) as List<dynamic>?;
    if (cached == null) return null;
    return cached
        .whereType<Map>()
        .map((item) => Flashcard.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<void> updateReview(String userId, Flashcard card) async {
    final cached = await getCachedReviews(userId);
    if (cached == null) return;
    final updated = cached.map((c) => c.id == card.id ? card : c).toList();
    await cacheReviews(userId, updated);
  }
}
