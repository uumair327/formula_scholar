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
              EntranceWrapper(
                useScale: true,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradientOf(context),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.sparkles,
                    color: AppColors.white,
                    size: AppDimensions.iconXXL,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              EntranceWrapper.stagger(
                index: 0,
                child: Text(
                  'How can I help you study today?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              EntranceWrapper.stagger(
                index: 1,
                child: Text(
                  'Ask me to navigate, explain formulas, or help with your study plans.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              EntranceWrapper.stagger(
                index: 2,
                child: AiSuggestionChips(onSelected: onSuggestion),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXS),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMD,
          vertical: AppDimensions.paddingSM,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double progress = _controller.value;
                final double offset = index * 0.2;
                final double value = (progress - offset) % 1.0;
                final double fade = value < 0.5
                    ? (value * 2)
                    : (1.0 - (value - 0.5) * 2);
                final double alphaValue = 0.3 + 0.7 * fade;

                return Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withValues(alpha: alphaValue),
                  ),
                );
              },
            );
          }),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLG,
          vertical: AppDimensions.paddingMD,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.15),
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: state.isListening
                    ? colorScheme.errorContainer.withValues(alpha: 0.3)
                    : colorScheme.primaryContainer.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                tooltip: state.isListening ? 'Stop voice input' : 'Voice input',
                onPressed: state.isBusy ? null : onMicPressed,
                icon: Icon(
                  state.isListening ? Icons.stop : LucideIcons.mic,
                  color: state.isListening
                      ? colorScheme.error
                      : colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !state.isBusy,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Ask Formula Scholar...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL,
                    vertical: AppDimensions.paddingMD,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? colorScheme.surfaceContainerLow
                      : colorScheme.surfaceContainerLowest,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMD),
            IconButton.filled(
              tooltip: 'Send',
              onPressed: state.isBusy ? null : onSend,
              icon: const Icon(LucideIcons.arrowUp),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
