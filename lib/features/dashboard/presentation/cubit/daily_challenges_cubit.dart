import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/daily_challenge.dart';
import '../../domain/usecases/get_random_daily_challenge_use_case.dart';

class DailyChallengesState {
  DailyChallengesState({this.selected});
  final DailyChallenge? selected;

  DailyChallengesState copyWith({DailyChallenge? selected}) =>
      DailyChallengesState(selected: selected ?? this.selected);
}

@injectable
class DailyChallengesCubit extends Cubit<DailyChallengesState> {
  DailyChallengesCubit(this._getRandomDailyChallengeUseCase)
      : super(DailyChallengesState()) {
    pickRandom();
  }

  final GetRandomDailyChallengeUseCase _getRandomDailyChallengeUseCase;

  void pickRandom() {
    final challenge = _getRandomDailyChallengeUseCase();
    emit(DailyChallengesState(selected: challenge));
  }
}
