import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

class LocationFormCard extends StatelessWidget {
  const LocationFormCard({
    super.key,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: AppDimensions.borderWidth,
        ),
        boxShadow: const [AppShadows.subtle],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedCountry,
            onChanged: onCountryChanged,
            items: countries
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            decoration: InputDecoration(
              labelText: context.l10n.step1CountryLabel,
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(
                  alpha: AppDimensions.opacityMedium,
                ),
                fontWeight: FontWeight.w600,
              ),
              floatingLabelStyle: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: AppDimensions.paddingMD,
                ),
                child: Icon(
                  LucideIcons.globe,
                  size: AppDimensions.iconDefault,
                  color: colorScheme.outline,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: AppDimensions.avatarMD,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: AppDimensions.borderWidthThick,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
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
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          AppTextField(
            controller: stateController,
            onChanged: onStateChanged,
            label: context.l10n.step1StateLabel,
            hintText: context.l10n.step1StateHint,
            prefixIcon: LucideIcons.mapPin,
            suffixIcon: Icon(
              LucideIcons.search,
              size: AppDimensions.iconDefault,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
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
                    horizontal: AppDimensions.paddingLG,
                    vertical: AppDimensions.paddingSM,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.secondaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusXXL,
                    ),
                    border: Border.all(
                      color: isActive ? AppColors.secondary : colorScheme.outlineVariant,
                      width: AppDimensions.borderWidth,
                    ),
                  ),
                  child: Text(
                    state,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isActive
                          ? AppColors.onSecondaryContainer
                          : colorScheme.onSurface,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
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
