import '../entities/entities.dart';

abstract class AiApplicationAction {
  AiActionDefinition get definition;

  Future<AiActionResult> execute({
    required AiActionRequest request,
    required AiContextSnapshot context,
  });
}
