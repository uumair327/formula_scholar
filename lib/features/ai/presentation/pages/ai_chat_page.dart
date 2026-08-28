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
        appBar: GlassAppBar(
          titleWidget: Text(
            'AI Assistant',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsetsDirectional.only(
                end: AppDimensions.paddingSM,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: IconButton(
                tooltip: 'AI settings',
                onPressed: () => context.pushNamed(AppRoutes.aiSettingsName),
                icon: Icon(
                  LucideIcons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<AiChatCubit, AiChatState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: state.messages.isEmpty
                      ? EmptyAssistantState(
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
                              return const TypingIndicator();
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
                ChatInputBar(
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

