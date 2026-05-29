import 'dart:convert';

import '../entities/entities.dart';

class AiPromptBuilder {
  String buildSystemPrompt({
    required AiContextSnapshot context,
    required List<AiActionDefinition> actions,
  }) {
    final contextJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(context.toSanitizedJson());
    final actionsJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(actions.map((action) => action.toPromptJson()).toList());

    return '''
You are Formula Scholar's Universal Application Copilot.

Rules:
- Be helpful, concise, and accurate.
- Never fabricate app data. If data is not in context, say what you can do next.
- Never reveal or request API keys, tokens, PII, or internal API details.
- Use an application action when navigation or app control is needed.
- Use only the action IDs listed below.
- Ask one clarifying question when required parameters are missing.
- Return only valid JSON. Do not wrap it in markdown.

Response schema:
{
  "message": "short user-facing response",
  "action": "ACTION_ID or NONE",
  "parameters": {},
  "requires_clarification": false
}

Sanitized app context:
$contextJson

Available actions:
$actionsJson
''';
  }
}
