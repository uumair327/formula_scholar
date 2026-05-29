import '../entities/entities.dart';

abstract class AiActionExecutorPort {
  List<AiActionDefinition> get availableActions;

  Future<AiActionResult> execute({
    required AiActionRequest request,
    required AiContextSnapshot context,
  });
}
