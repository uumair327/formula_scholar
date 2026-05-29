import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../ports/ports.dart';
import '../services/services.dart';

class RunAiPromptUseCase {
  const RunAiPromptUseCase({
    required AiSettingsRepositoryPort settingsRepository,
    required AiContextEnginePort contextEngine,
    required AiActionExecutorPort actionExecutor,
    required AiProviderFactory providerFactory,
    required AiPromptBuilder promptBuilder,
    required AiLocalIntentResolver localIntentResolver,
    required AiSanitizer sanitizer,
  }) : _settingsRepository = settingsRepository,
       _contextEngine = contextEngine,
       _actionExecutor = actionExecutor,
       _providerFactory = providerFactory,
       _promptBuilder = promptBuilder,
       _localIntentResolver = localIntentResolver,
       _sanitizer = sanitizer;

  final AiSettingsRepositoryPort _settingsRepository;
  final AiContextEnginePort _contextEngine;
  final AiActionExecutorPort _actionExecutor;
  final AiProviderFactory _providerFactory;
  final AiPromptBuilder _promptBuilder;
  final AiLocalIntentResolver _localIntentResolver;
  final AiSanitizer _sanitizer;

  Future<AiTurnResult> call({
    required String prompt,
    required List<AiMessage> conversation,
  }) async {
    final sanitizedPrompt = _sanitizer.sanitizeUserInput(prompt);
    final context = await _contextEngine.buildSnapshot();
    final settings = await _settingsRepository.loadSettings();
    final apiKey = await _settingsRepository.readApiKey(settings.provider);

    AiProviderResponse providerResponse;
    var usedLocalFallback = false;

    if (apiKey == null || apiKey.isEmpty) {
      providerResponse = _localIntentResolver.resolve(sanitizedPrompt);
      usedLocalFallback = true;
    } else {
      try {
        final client = _providerFactory.clientFor(settings.provider);
        providerResponse = await client.complete(
          AiProviderRequest(
            provider: settings.provider,
            apiKey: apiKey,
            model: settings.effectiveModel,
            systemPrompt: _promptBuilder.buildSystemPrompt(
              context: context,
              actions: _actionExecutor.availableActions,
            ),
            messages: conversation.takeLast(12).toList(),
            tools: _actionExecutor.availableActions,
          ),
        );
      } catch (error, stackTrace) {
        AppLogger.error(
          'AI provider unavailable; falling back to local intent resolver',
          tag: AppLogTags.aiAssistant,
          error: error,
          stackTrace: stackTrace,
        );
        providerResponse = _localIntentResolver.resolve(sanitizedPrompt);
        usedLocalFallback = true;
      }
    }

    final actionRequest = providerResponse.actionRequest;
    AiActionResult? actionResult;
    if (actionRequest != null && !providerResponse.requiresClarification) {
      actionResult = await _actionExecutor.execute(
        request: actionRequest,
        context: context,
      );
    }

    final baseMessage = _sanitizer.sanitizeAssistantOutput(
      providerResponse.message,
    );
    final message = actionResult == null
        ? baseMessage
        : '$baseMessage ${actionResult.message}'.trim();

    return AiTurnResult(
      message: message,
      actionRequest: actionRequest,
      actionResult: actionResult,
      usedLocalFallback: usedLocalFallback,
    );
  }
}

extension _TakeLast<T> on List<T> {
  Iterable<T> takeLast(int count) {
    if (length <= count) return this;
    return skip(length - count);
  }
}

abstract class AiProviderFactory {
  AiProviderClientPort clientFor(AiProviderType provider);
}
