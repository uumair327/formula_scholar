import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_shell.dart';

/// Onboarding Step 1 — Location & Country selection.
///
/// Driven dynamically by OnboardingCubit fetching from Firestore.
class OnboardingStep1Page extends StatefulWidget {
  const OnboardingStep1Page({super.key});

  @override
  State<OnboardingStep1Page> createState() => _OnboardingStep1PageState();
}

class _OnboardingStep1PageState extends State<OnboardingStep1Page> {
  final _stateController = TextEditingController();

  @override
  void dispose() {
    _stateController.dispose();
    super.dispose();
  }

  void _onContinue() {
    context.read<OnboardingCubit>().confirmLocation();
    context.go(AppRoutes.onboardingStep2Path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.countries != curr.countries ||
          prev.states != curr.states ||
          prev.selectedCountry != curr.selectedCountry ||
          prev.selectedState != curr.selectedState,
      builder: (context, state) {
        if (state.status == OnboardingStatus.loading &&
            state.countries.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return OnboardingShell(
          currentStep: 1,
          totalSteps: 4,
          continueLabel: AppStrings.step1Continue,
          // Only allow continue if at least country is selected
          onContinue: state.selectedCountry != null ? _onContinue : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingStepHeading(
                tag: AppStrings.step1Tag,
                title: AppStrings.step1Title,
                subtitle: AppStrings.step1Subtitle,
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  final formCard = _LocationFormCard(
                    countries: state.countries.map((c) => c.name).toList(),
                    selectedCountry: state.selectedCountry?.name ?? 'India',
                    stateController: _stateController,
                    popularStates: state.states
                        .map((s) => s.name)
                        .take(10)
                        .toList(),
                    selectedState: state.selectedState?.name,
                    onCountryChanged: (val) {
                      final c = state.countries.firstWhere(
                        (e) => e.name == val,
                      );
                      context.read<OnboardingCubit>().selectCountry(c);
                    },
                    onStateSelected: (st) {
                      final s = state.states.firstWhere((e) => e.name == st);
                      context.read<OnboardingCubit>().selectStateRegion(s);
                      _stateController.text = st;
                    },
                    onStateChanged: (_) {},
                  );
                  final infoCards = _LocationInfoCards();

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: formCard),
                        const SizedBox(width: AppDimensions.paddingXL),
                        Expanded(flex: 5, child: infoCards),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      formCard,
                      const SizedBox(height: AppDimensions.paddingLG),
                      infoCards,
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Location form card ─────────────────────────────────────────────

class _LocationFormCard extends StatelessWidget {

  const _LocationFormCard({
    required this.countries,
    required this.selectedCountry,
    required this.stateController,
    required this.popularStates,
    required this.selectedState,
    required this.onCountryChanged,
    required this.onStateSelected,
    required this.onStateChanged,
  });
  final List<String> countries;
  final String selectedCountry;
  final TextEditingController stateController;
  final List<String> popularStates;
  final String? selectedState;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String> onStateSelected;
  final ValueChanged<String> onStateChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        boxShadow: const [AppShadows.ghost],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Country dropdown
          DropdownButtonFormField<String>(
            initialValue: selectedCountry,
            onChanged: onCountryChanged,
            items: countries
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            decoration: InputDecoration(
              labelText: AppStrings.step1CountryLabel,
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant.withValues(
                  alpha: AppDimensions.opacityMedium,
                ),
                fontWeight: FontWeight.w600,
              ),
              floatingLabelStyle: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: AppDimensions.paddingMD),
                child: Icon(
                  LucideIcons.globe,
                  size: AppDimensions.iconDefault,
                  color: AppColors.outline,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: AppDimensions.avatarMD,
              ),
              filled: true,
              fillColor: AppColors.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  width: AppDimensions.borderWidth,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMD,
                vertical: AppDimensions.paddingMD,
              ),
            ),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),

          // State search
          AppTextField(
            controller: stateController,
            onChanged: onStateChanged,
            label: AppStrings.step1StateLabel,
            hintText: AppStrings.step1StateHint,
            prefixIcon: LucideIcons.mapPin,
            suffixIcon: const Icon(
              LucideIcons.search,
              size: AppDimensions.iconDefault,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),

          // Suggestion chips
          Wrap(
            spacing: AppDimensions.paddingXS,
            runSpacing: AppDimensions.paddingXS,
            children: popularStates.map((state) {
              final isActive = state == selectedState;
              return GestureDetector(
                onTap: () => onStateSelected(state),
                child: AnimatedContainer(
                  duration: AppDurations.animationFast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMD,
                    vertical: AppDimensions.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.secondaryContainer
                        : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusXXL,
                    ),
                  ),
                  child: Text(
                    state,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isActive
                          ? AppColors.onSecondaryContainer
                          : AppColors.onSurfaceVariant,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Info cards ──────────────────────────────────────────────────────

class _LocationInfoCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Localized content card
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          decoration: BoxDecoration(
            color: AppColors.primaryFixed.withValues(
              alpha: AppDimensions.opacitySubtle,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppDimensions.avatarMD,
                height: AppDimensions.avatarMD,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  boxShadow: [AppShadows.subtle],
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: AppDimensions.iconDefault,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              Text(
                AppStrings.step1LocalizedTitle,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXS),
              Text(
                AppStrings.step1LocalizedDesc,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onPrimaryContainer.withValues(
                    alpha: AppDimensions.opacityHigh,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        // Privacy badge
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.shieldCheck,
                color: AppColors.secondary,
                size: AppDimensions.iconLG,
              ),
              const SizedBox(width: AppDimensions.paddingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.step1PrivacyTitle,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXXS),
                    Text(
                      AppStrings.step1PrivacyDesc,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
