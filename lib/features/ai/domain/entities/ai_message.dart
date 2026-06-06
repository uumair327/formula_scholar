import 'package:equatable/equatable.dart';

import 'ai_action_request.dart';

enum AiMessageRole { user, assistant }

class AiMessage extends Equatable {
  const AiMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.actionRequest,
    this.widgetConfig,
    this.isStreaming = false,
  });

  final String id;
  final AiMessageRole role;
  final String content;
  final DateTime createdAt;
  final AiActionRequest? actionRequest;
  final Map<String, dynamic>? widgetConfig;
  final bool isStreaming;

  AiMessage copyWith({
    String? id,
    AiMessageRole? role,
    String? content,
    DateTime? createdAt,
    Object? actionRequest = _unset,
    Object? widgetConfig = _unset,
    bool? isStreaming,
  }) {
    return AiMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      actionRequest: identical(actionRequest, _unset)
          ? this.actionRequest
          : actionRequest as AiActionRequest?,
      widgetConfig: identical(widgetConfig, _unset)
          ? this.widgetConfig
          : widgetConfig as Map<String, dynamic>?,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  @override
  List<Object?> get props => [
    id,
    role,
    content,
    createdAt,
    actionRequest,
    widgetConfig,
    isStreaming,
  ];
}

const Object _unset = Object();
