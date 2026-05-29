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
          appBar: AppBar(title: const Text('AI Settings')),
          body: ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            children: [
              _SecurityBanner(settings: state.settings),
              const SizedBox(height: AppDimensions.paddingXL),
              DropdownButtonFormField<AiProviderType>(
                value: state.settings.provider,
                decoration: const InputDecoration(
                  labelText: 'AI Provider',
                  border: OutlineInputBorder(),
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
                  border: const OutlineInputBorder(),
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
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(LucideIcons.lock),
                  suffixIcon: IconButton(
                    tooltip: _obscureKey ? 'Show key' : 'Hide key',
                    onPressed: () => setState(() => _obscureKey = !_obscureKey),
                    icon: Icon(
                      _obscureKey ? LucideIcons.eye : LucideIcons.eyeOff,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              Wrap(
                spacing: AppDimensions.paddingMD,
                runSpacing: AppDimensions.paddingMD,
                children: [
                  FilledButton.icon(
                    onPressed: isBusy
                        ? null
                        : () {
                            context.read<AiSettingsCubit>().save(
                              apiKey: _apiKeyController.text,
                              model: _modelController.text,
                            );
                            _apiKeyController.clear();
                          },
                    icon: const Icon(LucideIcons.save),
                    label: const Text('Save'),
                  ),
                  OutlinedButton.icon(
                    onPressed: isBusy
                        ? null
                        : () => context.read<AiSettingsCubit>().validate(),
                    icon: const Icon(LucideIcons.checkCircle2),
                    label: const Text('Validate'),
                  ),
                  OutlinedButton.icon(
                    onPressed: isBusy || !state.settings.hasApiKey
                        ? null
                        : () => context.read<AiSettingsCubit>().deleteApiKey(),
                    icon: const Icon(LucideIcons.trash2),
                    label: const Text('Delete Key'),
                  ),
                ],
              ),
              if (state.validationResult != null) ...[
                const SizedBox(height: AppDimensions.paddingXL),
                _ValidationResult(result: state.validationResult!),
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
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.22)),
      ),
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
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
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
