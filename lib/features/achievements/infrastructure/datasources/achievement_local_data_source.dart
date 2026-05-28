import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';

@LazySingleton(as: AchievementDataSourcePort)
class AchievementLocalDataSource implements AchievementDataSourcePort {
  static const _definitions = [
    _Definition(
      id: 'first_mastered',
      title: 'First Step',
      description: 'Master your first formula',
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _Definition(
      id: 'ten_mastered',
      title: 'Getting Started',
      description: 'Master 10 formulas',
      tier: AchievementTier.silver,
      target: 10,
    ),
    _Definition(
      id: 'fifty_mastered',
      title: 'Formula Scholar',
      description: 'Master 50 formulas',
      tier: AchievementTier.gold,
      target: 50,
    ),
    _Definition(
      id: 'first_flashcard',
      title: 'Flashcard Rookie',
      description: 'Complete your first flashcard session',
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _Definition(
      id: 'ten_flashcards',
      title: 'Study Streak',
      description: 'Complete 10 flashcard sessions',
      tier: AchievementTier.silver,
      target: 10,
    ),
    _Definition(
      id: 'first_note',
      title: 'Note Taker',
      description: 'Write your first note on a formula',
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _Definition(
      id: 'ten_notes',
      title: 'Study Notes',
      description: 'Write 10 notes',
      tier: AchievementTier.silver,
      target: 10,
    ),
    _Definition(
      id: 'daily_challenge',
      title: 'Daily Grind',
      description: 'Complete your first daily challenge',
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _Definition(
      id: 'seven_day_streak',
      title: 'Week Warrior',
      description: 'Use the app 7 days in a row',
      tier: AchievementTier.gold,
      target: 7,
    ),
    _Definition(
      id: 'all_subjects',
      title: 'Renaissance',
      description: 'View formulas from all subjects',
      tier: AchievementTier.diamond,
      target: 1,
    ),
  ];

  @override
  Future<List<Achievement>> getAchievements() async {
    return _definitions
        .map(
          (d) => Achievement(
            id: d.id,
            title: d.title,
            description: d.description,
            tier: d.tier,
            target: d.target,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveAchievementProgress(
    String id,
    int progress,
    DateTime? unlockedAt,
  ) async {
    // No-op: local data source is read-only (definitions only).
    // Progress is persisted via AchievementCachePort.
  }
}

class _Definition {
  const _Definition({
    required this.id,
    required this.title,
    required this.description,
    required this.tier,
    required this.target,
  });

  final String id;
  final String title;
  final String description;
  final AchievementTier tier;
  final int target;
}
