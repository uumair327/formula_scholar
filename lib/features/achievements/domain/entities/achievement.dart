import 'package:equatable/equatable.dart';

enum AchievementTier { bronze, silver, gold, diamond }

class Achievement extends Equatable {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.tier,
    this.progress = 0,
    this.target = 1,
    this.unlockedAt,
  });

  final String id;
  final String title;
  final String description;
  final AchievementTier tier;
  final int progress;
  final int target;
  final DateTime? unlockedAt;

  bool get isUnlocked => unlockedAt != null;
  double get progressFraction => (progress / target).clamp(0.0, 1.0);
  bool get isNew => isUnlocked && unlockedAt!.isAfter(
    DateTime.now().subtract(const Duration(days: 1)),
  );

  Achievement copyWith({
    int? progress,
    DateTime? unlockedAt,
    bool clearUnlock = false,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      tier: tier,
      progress: progress ?? this.progress,
      target: target,
      unlockedAt: clearUnlock ? null : (unlockedAt ?? this.unlockedAt),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    tier,
    progress,
    target,
    unlockedAt,
  ];
}
