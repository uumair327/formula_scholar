import 'package:equatable/equatable.dart';

import 'ai_action_definition.dart';
import 'ai_message.dart';
import 'ai_provider_type.dart';

class AiProviderRequest extends Equatable {
  const AiProviderRequest({
    required this.provider,
    required this.apiKey,
    required this.model,
    required this.systemPrompt,
    required this.messages,
    required this.tools,
  });

  final AiProviderType provider;
  final String apiKey;
  final String model;
  final String systemPrompt;
  final List<AiMessage> messages;
  final List<AiActionDefinition> tools;

  @override
  List<Object?> get props => [provider, model, systemPrompt, messages, tools];
}
