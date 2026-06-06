import 'package:flutter_bloc/flutter_bloc.dart';

import '../../infrastructure/daily_challenges.dart';

class DailyChallengesState {
  DailyChallengesState({this.selected});
  final DailyChallenge? selected;

  DailyChallengesState copyWith({DailyChallenge? selected}) =>
      DailyChallengesState(selected: selected ?? this.selected);
}

class DailyChallengesCubit extends Cubit<DailyChallengesState> {
  DailyChallengesCubit() : super(DailyChallengesState()) {
    pickRandom();
  }

  void pickRandom() {
    final challenge = DailyChallenges.random();
    emit(DailyChallengesState(selected: challenge));
  }
}
