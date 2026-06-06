import 'package:equatable/equatable.dart';

import 'ai_action_request.dart';
import 'ai_action_result.dart';

class AiTurnResult extends Equatable {
  const AiTurnResult({
    required this.message,
    this.actionRequest,
    this.actionResult,
    this.widgetConfig,
    this.usedLocalFallback = false,
  });

  final String message;
  final AiActionRequest? actionRequest;
  final AiActionResult? actionResult;
  final Map<String, dynamic>? widgetConfig;
  final bool usedLocalFallback;

  @override
  List<Object?> get props => [
    message,
    actionRequest,
    actionResult,
    widgetConfig,
    usedLocalFallback,
  ];
}
