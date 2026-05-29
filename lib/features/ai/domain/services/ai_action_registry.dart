import '../entities/entities.dart';
import 'ai_application_action.dart';

class AiActionRegistry {
  AiActionRegistry(List<AiApplicationAction> actions)
    : _actions = {for (final action in actions) action.definition.id: action};

  final Map<String, AiApplicationAction> _actions;

  List<AiActionDefinition> get definitions {
    return _actions.values.map((action) => action.definition).toList();
  }

  AiApplicationAction? resolve(String actionId) {
    return _actions[actionId.trim().toUpperCase()];
  }
}
