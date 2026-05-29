import 'package:equatable/equatable.dart';

import 'ai_action_request.dart';

class AiProviderResponse extends Equatable {
  const AiProviderResponse({
    required this.message,
    this.actionRequest,
    this.requiresClarification = false,
  });

  final String message;
  final AiActionRequest? actionRequest;
  final bool requiresClarification;

  @override
  List<Object?> get props => [message, actionRequest, requiresClarification];
}
