import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum AiChatStatus { idle, thinking, streaming, listening, error }

class AiChatState extends Equatable {
  const AiChatState({
    this.status = AiChatStatus.idle,
    this.messages = const [],
    this.voiceTranscript = '',
    this.errorMessage,
  });

  final AiChatStatus status;
  final List<AiMessage> messages;
  final String voiceTranscript;
  final String? errorMessage;

  bool get isBusy =>
      status == AiChatStatus.thinking || status == AiChatStatus.streaming;

  bool get isListening => status == AiChatStatus.listening;

  AiChatState copyWith({
    AiChatStatus? status,
    List<AiMessage>? messages,
    String? voiceTranscript,
    Object? errorMessage = _unset,
  }) {
    return AiChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      voiceTranscript: voiceTranscript ?? this.voiceTranscript,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, messages, voiceTranscript, errorMessage];
}

const Object _unset = Object();
