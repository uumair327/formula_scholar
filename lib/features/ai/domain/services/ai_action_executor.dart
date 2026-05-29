import '../entities/entities.dart';
import '../ports/ai_action_executor_port.dart';
import 'ai_action_registry.dart';
import 'ai_permission_service.dart';

class AiActionExecutor implements AiActionExecutorPort {
  const AiActionExecutor({
    required AiActionRegistry registry,
    required AiPermissionService permissionService,
  }) : _registry = registry,
       _permissionService = permissionService;

  final AiActionRegistry _registry;
  final AiPermissionService _permissionService;

  @override
  List<AiActionDefinition> get availableActions => _registry.definitions;

  @override
  Future<AiActionResult> execute({
    required AiActionRequest request,
    required AiContextSnapshot context,
  }) async {
    final action = _registry.resolve(request.action);
    if (action == null) {
      return AiActionResult(
        success: false,
        message: 'I cannot perform ${request.action} yet.',
      );
    }

    final decision = _permissionService.validate(
      definition: action.definition,
      context: context,
    );
    if (!decision.isAllowed) {
      return AiActionResult(success: false, message: decision.message!);
    }

    return action.execute(request: request, context: context);
  }
}
