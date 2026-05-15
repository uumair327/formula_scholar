import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum FlashcardsStatus { initial, ready, finished }

class FlashcardsState extends Equatable {
  const FlashcardsState({
    this.status = FlashcardsStatus.initial,
    this.session = const FlashcardSession(cards: []),
  });

  final FlashcardsStatus status;
  final FlashcardSession session;

  FlashcardsState copyWith({
    FlashcardsStatus? status,
    FlashcardSession? session,
  }) {
    return FlashcardsState(
      status: status ?? this.status,
      session: session ?? this.session,
    );
  }

  @override
  List<Object?> get props => [status, session];
}
