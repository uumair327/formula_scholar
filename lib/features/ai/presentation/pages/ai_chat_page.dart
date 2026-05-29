import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/cubit.dart';
import '../widgets/widgets.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AiChatCubit, AiChatState>(
      listenWhen: (previous, current) =>
          previous.voiceTranscript != current.voiceTranscript ||
          previous.messages.length != current.messages.length,
      listener: (context, state) {
        if (state.voiceTranscript.isNotEmpty &&
            _controller.text != state.voiceTranscript) {
          _controller.text = state.voiceTranscript;
          _controller.selection = TextSelection.collapsed(
            offset: _controller.text.length,
          );
        }
        _scrollToBottom();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Assistant'),
          actions: [
            IconButton(
              tooltip: 'AI settings',
              onPressed: () => context.pushNamed(AppRoutes.aiSettingsName),
              icon: const Icon(LucideIcons.settings),
            ),
          ],
        ),
        body: BlocBuilder<AiChatCubit, AiChatState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: state.messages.isEmpty
                      ? _EmptyAssistantState(
                          onSuggestion: (value) => _send(context, value),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(
                            AppDimensions.paddingLG,
                            AppDimensions.paddingLG,
                            AppDimensions.paddingLG,
                            AppDimensions.paddingXXL,
                          ),
                          itemCount:
                              state.messages.length +
                              (state.status == AiChatStatus.thinking ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.messages.length) {
                              return const _TypingIndicator();
                            }
                            final message = state.messages[index];
                            return AiMessageBubble(
                              message: message,
                              onSpeak: (text) =>
                                  context.read<AiChatCubit>().speak(text),
                            );
                          },
                        ),
                ),
                _ChatInputBar(
                  controller: _controller,
                  state: state,
                  onSend: () => _send(context, _controller.text),
                  onMicPressed: () => _toggleVoice(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _send(BuildContext context, String value) {
    final prompt = value.trim();
    if (prompt.isEmpty) return;
    _controller.clear();
    context.read<AiChatCubit>().sendPrompt(prompt);
  }

  Future<void> _toggleVoice(BuildContext context, AiChatState state) async {
    final cubit = context.read<AiChatCubit>();
    if (state.isListening) {
      await cubit.stopListening();
      return;
    }
    await cubit.startListening();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: AppDurations.animationFast,
        curve: AppDurations.curvePremium,
      );
    });
  }
}

class _EmptyAssistantState extends StatelessWidget {
  const _EmptyAssistantState({required this.onSuggestion});

  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradientOf(context),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  color: AppColors.white,
                  size: AppDimensions.iconXXL,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Text(
                'Ask me to navigate, explain, or help with a study workflow.',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleMedium.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              AiSuggestionChips(onSelected: onSuggestion),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXS),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMD,
          vertical: AppDimensions.paddingSM,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
        child: Text(
          'Thinking...',
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.state,
    required this.onSend,
    required this.onMicPressed,
  });

  final TextEditingController controller;
  final AiChatState state;
  final VoidCallback onSend;
  final VoidCallback onMicPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: state.isListening ? 'Stop voice input' : 'Voice input',
              onPressed: state.isBusy ? null : onMicPressed,
              icon: Icon(
                state.isListening ? LucideIcons.pause : LucideIcons.mic,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingSM),
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !state.isBusy,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Ask Formula Scholar...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingSM),
            IconButton.filled(
              tooltip: 'Send',
              onPressed: state.isBusy ? null : onSend,
              icon: const Icon(LucideIcons.arrowRight),
            ),
          ],
        ),
      ),
    );
  }
}
