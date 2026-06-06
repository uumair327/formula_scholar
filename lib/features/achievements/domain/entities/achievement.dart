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

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    tier: AchievementTier.values.firstWhere(
      (t) => t.name == json['tier'],
      orElse: () => AchievementTier.bronze,
    ),
    progress: json['progress'] as int? ?? 0,
    target: json['target'] as int? ?? 1,
    unlockedAt: json['unlockedAt'] != null
        ? DateTime.tryParse(json['unlockedAt'] as String)
        : null,
  );

  final String id;
  final String title;
  final String description;
  final AchievementTier tier;
  final int progress;
  final int target;
  final DateTime? unlockedAt;

  bool get isUnlocked => unlockedAt != null;
  double get progressFraction => (progress / target).clamp(0.0, 1.0);
  bool get isNew =>
      isUnlocked &&
      unlockedAt!.isAfter(DateTime.now().subtract(const Duration(days: 1)));

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'tier': tier.name,
    'progress': progress,
    'target': target,
    'unlockedAt': unlockedAt?.toIso8601String(),
  };

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
  List<Object?> get props => [id, title, tier, progress, target, unlockedAt];
}
