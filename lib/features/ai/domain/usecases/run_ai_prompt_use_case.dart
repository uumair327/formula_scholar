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
    required AiSanitizer sanitizer,
  }) : _settingsRepository = settingsRepository,
       _contextEngine = contextEngine,
       _actionExecutor = actionExecutor,
       _providerFactory = providerFactory,
       _promptBuilder = promptBuilder,
       _sanitizer = sanitizer;

  final AiSettingsRepositoryPort _settingsRepository;
  final AiContextEnginePort _contextEngine;
  final AiActionExecutorPort _actionExecutor;
  final AiProviderFactory _providerFactory;
  final AiPromptBuilder _promptBuilder;
  final AiSanitizer _sanitizer;

  Future<AiTurnResult> call({
    required String prompt,
    required List<AiMessage> conversation,
  }) async {
    final context = await _contextEngine.buildSnapshot();
    final settings = await _settingsRepository.loadSettings();
    final apiKey = await _settingsRepository.readApiKey(settings.provider);

    AppLogger.debug(
      'RunAiPromptUseCase: provider=${settings.provider.id}, apiKey=${apiKey != null ? "exists (length: ${apiKey.length})" : "null"}',
      tag: AppLogTags.aiAssistant,
    );

    AiProviderResponse providerResponse;
    const usedLocalFallback = false;

    if (apiKey == null || apiKey.isEmpty) {
      return AiTurnResult(
        message:
            'No API key found for ${settings.provider.label}. Please configure it in AI Settings.',
      );
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
          'AI provider unavailable',
          tag: AppLogTags.aiAssistant,
          error: error,
          stackTrace: stackTrace,
        );
        return AiTurnResult(
          message:
              'Connection failed: $error\nIf you are using OpenAI or Claude on Flutter Web, they may be blocked by the browser (CORS). Please use Gemini, or try the desktop app.',
        );
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
      widgetConfig: providerResponse.widgetConfig,
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
