import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/domain.dart';
import 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  AiChatCubit({
    required RunAiPromptUseCase runPrompt,
    required AiVoiceServicePort voiceService,
  }) : _runPrompt = runPrompt,
       _voiceService = voiceService,
       super(const AiChatState());

  final RunAiPromptUseCase _runPrompt;
  final AiVoiceServicePort _voiceService;

  Future<void> sendPrompt(String prompt) async {
    final trimmed = prompt.trim();
    if (trimmed.isEmpty || state.isBusy) return;

    final userMessage = AiMessage(
      id: _newId('user'),
      role: AiMessageRole.user,
      content: trimmed,
      createdAt: DateTime.now(),
    );
    final conversation = [...state.messages, userMessage];

    emit(
      state.copyWith(
        status: AiChatStatus.thinking,
        messages: conversation,
        errorMessage: null,
      ),
    );

    try {
      final result = await _runPrompt(
        prompt: trimmed,
        conversation: conversation,
      );
      await _streamAssistantResult(result);
    } catch (error) {
      emit(
        state.copyWith(
          status: AiChatStatus.error,
          errorMessage: 'The assistant could not complete that request.',
          messages: [
            ...state.messages,
            AiMessage(
              id: _newId('assistant'),
              role: AiMessageRole.assistant,
              content: 'I could not complete that request. Please try again.',
              createdAt: DateTime.now(),
            ),
          ],
        ),
      );
    }
  }

  Future<void> startListening({String localeId = 'en_US'}) async {
    if (state.isBusy) return;
    emit(
      state.copyWith(
        status: AiChatStatus.listening,
        voiceTranscript: '',
        errorMessage: null,
      ),
    );
    await _voiceService.startListening(
      localeId: localeId,
      onResult: (recognizedWords, {required isFinal}) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: isFinal ? AiChatStatus.idle : AiChatStatus.listening,
            voiceTranscript: recognizedWords,
          ),
        );
        if (isFinal) {
          unawaited(_voiceService.stopListening());
        }
      },
    );
  }

  Future<void> stopListening() async {
    await _voiceService.stopListening();
    emit(state.copyWith(status: AiChatStatus.idle));
  }

  Future<void> speak(String text) {
    return _voiceService.speak(text);
  }

  Future<void> stopSpeaking() {
    return _voiceService.stopSpeaking();
  }

  Future<void> _streamAssistantResult(AiTurnResult result) async {
    final assistantId = _newId('assistant');
    final createdAt = DateTime.now();
    emit(
      state.copyWith(
        status: AiChatStatus.streaming,
        messages: [
          ...state.messages,
          AiMessage(
            id: assistantId,
            role: AiMessageRole.assistant,
            content: '',
            createdAt: createdAt,
            actionRequest: result.actionRequest,
            widgetConfig: result.widgetConfig,
            isStreaming: true,
          ),
        ],
      ),
    );

    final words = result.message.split(RegExp(r'(\s+)'));
    final buffer = StringBuffer();
    for (final word in words) {
      if (isClosed) return;
      buffer.write(word);
      _replaceAssistantMessage(
        assistantId,
        content: buffer.toString(),
        isStreaming: true,
        actionRequest: result.actionRequest,
        widgetConfig: result.widgetConfig,
      );
      await Future<void>.delayed(const Duration(milliseconds: 12));
    }

    _replaceAssistantMessage(
      assistantId,
      content: result.message,
      isStreaming: false,
      actionRequest: result.actionRequest,
      widgetConfig: result.widgetConfig,
    );
    emit(state.copyWith(status: AiChatStatus.idle));
  }

  void _replaceAssistantMessage(
    String id, {
    required String content,
    required bool isStreaming,
    AiActionRequest? actionRequest,
    Map<String, dynamic>? widgetConfig,
  }) {
    final updated = state.messages
        .map((message) {
          if (message.id != id) return message;
          return message.copyWith(
            content: content,
            isStreaming: isStreaming,
            actionRequest: actionRequest,
            widgetConfig: widgetConfig,
          );
        })
        .toList(growable: false);
    emit(state.copyWith(messages: updated));
  }

  String _newId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }
}
