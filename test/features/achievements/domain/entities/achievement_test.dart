import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/features/achievements/domain/entities/achievement.dart';

void main() {
  group('Achievement', () {
    const bronze = AchievementTier.bronze;
    const silver = AchievementTier.silver;
    const gold = AchievementTier.gold;
    const diamond = AchievementTier.diamond;

    test('isUnlocked returns false when unlockedAt is null', () {
      const a = Achievement(
        id: 'test',
        title: 'Test',
        description: 'Desc',
        tier: bronze,
        target: 1,
      );
      expect(a.isUnlocked, false);
    });

    test('isUnlocked returns true when unlockedAt is set', () {
      final a = Achievement(
        id: 'test',
        title: 'Test',
        description: 'Desc',
        tier: bronze,
        target: 1,
        unlockedAt: DateTime.now(),
      );
      expect(a.isUnlocked, true);
    });

    test('progressFraction clamps to 1.0', () {
      const a = Achievement(
        id: 'test',
        title: 'Test',
        description: 'Desc',
        tier: bronze,
        target: 10,
        progress: 15,
      );
      expect(a.progressFraction, 1.0);
    });

    test('progressFraction returns correct ratio', () {
      const a = Achievement(
        id: 'test',
        title: 'Test',
        description: 'Desc',
        tier: silver,
        target: 10,
        progress: 3,
      );
      expect(a.progressFraction, 0.3);
    });

    test('isNew returns true for recently unlocked achievements', () {
      final a = Achievement(
        id: 'test',
        title: 'Test',
        description: 'Desc',
        tier: gold,
        target: 1,
        unlockedAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      expect(a.isNew, true);
    });

    test('isNew returns false for old achievements', () {
      final a = Achievement(
        id: 'test',
        title: 'Test',
        description: 'Desc',
        tier: diamond,
        target: 1,
        unlockedAt: DateTime.now().subtract(const Duration(days: 2)),
      );
      expect(a.isNew, false);
    });

    test('copyWith preserves unchanged fields', () {
      const a = Achievement(
        id: 'test',
        title: 'Test',
        description: 'Desc',
        tier: bronze,
        target: 5,
        progress: 2,
      );
      final copy = a.copyWith(progress: 4);
      expect(copy.id, 'test');
      expect(copy.title, 'Test');
      expect(copy.progress, 4);
    });

    test('copyWith with clearUnlock removes unlockedAt', () {
      final a = Achievement(
        id: 'test',
        title: 'Test',
        description: 'Desc',
        tier: bronze,
        target: 1,
        unlockedAt: DateTime.now(),
      );
      final copy = a.copyWith(clearUnlock: true);
      expect(copy.unlockedAt, isNull);
    });

    test('toJson/fromJson round-trip with unlockedAt', () {
      final now = DateTime(2026, 5, 16, 12, 30, 0);
      final a = Achievement(
        id: 'test_id',
        title: 'Test Title',
        description: 'Test description',
        tier: AchievementTier.gold,
        target: 10,
        progress: 7,
        unlockedAt: now,
      );
      final json = a.toJson();
      final restored = Achievement.fromJson(json);
      expect(restored.id, a.id);
      expect(restored.title, a.title);
      expect(restored.description, a.description);
      expect(restored.tier, a.tier);
      expect(restored.target, a.target);
      expect(restored.progress, a.progress);
      expect(restored.unlockedAt, a.unlockedAt);
    });

    test('toJson/fromJson round-trip without unlockedAt', () {
      const a = Achievement(
        id: 'locked_test',
        title: 'Locked',
        description: 'Still locked',
        tier: AchievementTier.bronze,
        target: 1,
      );
      final json = a.toJson();
      final restored = Achievement.fromJson(json);
      expect(restored.id, a.id);
      expect(restored.unlockedAt, isNull);
      expect(restored.isUnlocked, false);
    });

    test('equality works correctly', () {
      const a = Achievement(
        id: 'eq',
        title: 'T',
        description: 'D',
        tier: bronze,
        target: 1,
      );
      const b = Achievement(
        id: 'eq',
        title: 'T',
        description: 'D',
        tier: bronze,
        target: 1,
      );
      const c = Achievement(
        id: 'diff',
        title: 'T',
        description: 'D',
        tier: bronze,
        target: 1,
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
