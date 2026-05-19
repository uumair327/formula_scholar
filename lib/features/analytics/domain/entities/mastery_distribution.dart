import 'package:equatable/equatable.dart';

class MasteryDistribution extends Equatable {
  const MasteryDistribution({
    required this.mastered,
    required this.inProgress,
    required this.notStarted,
  });

  final int mastered;
  final int inProgress;
  final int notStarted;

  int get total => mastered + inProgress + notStarted;
  double get masteredFraction => total > 0 ? mastered / total : 0;

  @override
  List<Object?> get props => [mastered, inProgress, notStarted];
}
