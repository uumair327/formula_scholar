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
    this.isStreaming = false,
  });

  final String id;
  final AiMessageRole role;
  final String content;
  final DateTime createdAt;
  final AiActionRequest? actionRequest;
  final bool isStreaming;

  AiMessage copyWith({
    String? id,
    AiMessageRole? role,
    String? content,
    DateTime? createdAt,
    Object? actionRequest = _unset,
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
    isStreaming,
  ];
}

const Object _unset = Object();
