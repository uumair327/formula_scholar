import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/cubit.dart';

class AiSettingsPage extends StatefulWidget {
  const AiSettingsPage({super.key});

  @override
  State<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends State<AiSettingsPage> {
  late final TextEditingController _apiKeyController;
  late final TextEditingController _modelController;
  bool _obscureKey = true;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController();
    _modelController = TextEditingController();
    context.read<AiSettingsCubit>().load();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<AiSettingsCubit, AiSettingsState>(
      listenWhen: (previous, current) =>
          previous.settings != current.settings ||
          previous.message != current.message,
      listener: (context, state) {
        final model = state.settings.model ?? '';
        if (_modelController.text != model) {
          _modelController.text = model;
        }
        if (state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      builder: (context, state) {
        final isBusy =
            state.status == AiSettingsStatus.saving ||
            state.status == AiSettingsStatus.validating ||
            state.status == AiSettingsStatus.loading;

        return Scaffold(
          appBar: GlassAppBar(
            titleWidget: Text(
              'AI Settings',
              style: AppTextStyles.headlineSmall.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            children: [
              _SecurityBanner(settings: state.settings),
              const SizedBox(height: AppDimensions.paddingXL),
              EntranceWrapper.stagger(
                index: 0,
                child: AppGlassCard(
                  borderRadius: AppDimensions.radiusLG,
                  padding: const EdgeInsets.all(AppDimensions.paddingXL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'API Credentials',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXS),
                      Text(
                        'Configure your custom model settings and credentials below.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXL),
                      DropdownButtonFormField<AiProviderType>(
                        initialValue: state.settings.provider,
                        decoration: const InputDecoration(
                          labelText: 'AI Provider',
                          prefixIcon: Icon(LucideIcons.brain),
                        ),
                        items: [
                          for (final provider in AiProviderType.values)
                            DropdownMenuItem(
                              value: provider,
                              child: Text(provider.label),
                            ),
                        ],
                        onChanged: isBusy
                            ? null
                            : (provider) {
                                if (provider == null) return;
                                context.read<AiSettingsCubit>().selectProvider(
                                  provider,
                                );
                              },
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),
                      TextField(
                        controller: _modelController,
                        enabled: !isBusy,
                        decoration: InputDecoration(
                          labelText: 'Model',
                          hintText: state.settings.provider.defaultModel,
                          prefixIcon: const Icon(LucideIcons.code),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),
                      TextField(
                        controller: _apiKeyController,
                        enabled: !isBusy,
                        obscureText: _obscureKey,
                        decoration: InputDecoration(
                          labelText: state.settings.hasApiKey
                              ? 'Replace API Key'
                              : 'API Key',
                          helperText: state.settings.hasApiKey
                              ? 'Saved key: ${state.settings.maskedApiKey}'
                              : 'Stored with platform secure storage.',
                          prefixIcon: const Icon(LucideIcons.lock),
                          suffixIcon: IconButton(
                            tooltip: _obscureKey ? 'Show key' : 'Hide key',
                            onPressed:
                                () => setState(() => _obscureKey = !_obscureKey),
                            icon: Icon(
                              _obscureKey
                                  ? LucideIcons.eye
                                  : LucideIcons.eyeOff,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              EntranceWrapper.stagger(
                index: 1,
                child: Column(
                  children: [
                    AppGradientButton(
                      label: 'Save Configuration',
                      icon: LucideIcons.save,
                      isLoading: state.status == AiSettingsStatus.saving,
                      onPressed: isBusy
                          ? null
                          : () {
                              context.read<AiSettingsCubit>().save(
                                apiKey: _apiKeyController.text,
                                model: _modelController.text,
                              );
                              _apiKeyController.clear();
                            },
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.paddingMD,
                              ),
                            ),
                            onPressed: isBusy
                                ? null
                                : () => context
                                    .read<AiSettingsCubit>()
                                    .validate(),
                            icon: const Icon(LucideIcons.checkCircle2),
                            label: const Text('Validate Key'),
                          ),
                        ),
                        if (state.settings.hasApiKey) ...[
                          const SizedBox(width: AppDimensions.paddingMD),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: colorScheme.error,
                                side: BorderSide(
                                  color: colorScheme.error.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppDimensions.paddingMD,
                                ),
                              ),
                              onPressed: isBusy
                                  ? null
                                  : () => context
                                      .read<AiSettingsCubit>()
                                      .deleteApiKey(),
                              icon: const Icon(LucideIcons.trash2),
                              label: const Text('Delete Key'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (state.validationResult != null) ...[
                const SizedBox(height: AppDimensions.paddingXL),
                EntranceWrapper(
                  direction: EntranceDirection.up,
                  child: _ValidationResult(result: state.validationResult!),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SecurityBanner extends StatelessWidget {
  const _SecurityBanner({required this.settings});

  final AiSettings settings;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppGlassCard(
      borderRadius: AppDimensions.radiusLG,
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.shieldCheck, color: colorScheme.primary),
          const SizedBox(width: AppDimensions.paddingMD),
          Expanded(
            child: Text(
              'Provider keys are kept in platform secure storage and are never written to logs. The assistant can only run registered actions after permission checks.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurface,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidationResult extends StatelessWidget {
  const _ValidationResult({required this.result});

  final AiValidationResult result;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = result.isValid ? AppColors.successGreen : colorScheme.error;
    return AppGlassCard(
      borderRadius: AppDimensions.radiusLG,
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Row(
        children: [
          Icon(
            result.isValid ? LucideIcons.checkCircle2 : LucideIcons.xCircle,
            color: color,
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Expanded(
            child: Text(
              result.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
