import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/widgets.dart';

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

  List<String> _filteredStateNames(List<StateRegion> states, String queryText) {
    final query = queryText.trim().toLowerCase();
    if (query.isEmpty) {
      return states.map((s) => s.name).toList();
    }
    return states
        .where((s) => s.name.toLowerCase().contains(query))
        .map((s) => s.name)
        .toList();
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
          prev.stateSearchQuery != curr.stateSearchQuery ||
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
          continueLabel: context.l10n.step1Continue,
          // Only allow continue if at least country is selected
          onContinue: state.selectedCountry != null ? _onContinue : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardingStepHeading(
                tag: context.l10n.step1Tag,
                title: context.l10n.step1Title,
                subtitle: context.l10n.step1Subtitle,
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  final formCard = LocationFormCard(
                    countries: state.countries.map((c) => c.name).toList(),
                    selectedCountry: state.selectedCountry?.name ?? 'India',
                    stateController: _stateController,
                    popularStates: _filteredStateNames(
                      state.states,
                      state.stateSearchQuery,
                    ),
                    selectedState: state.selectedState?.name,
                    onCountryChanged: (val) {
                      final c = state.countries.firstWhere(
                        (e) => e.name == val,
                      );
                      context.read<OnboardingCubit>().selectCountry(c);
                      _stateController.clear();
                    },
                    onStateSelected: (st) {
                      final s = state.states.firstWhere((e) => e.name == st);
                      context.read<OnboardingCubit>().selectStateRegion(s);
                      _stateController.text = st;
                    },
                    onStateChanged: context
                        .read<OnboardingCubit>()
                        .updateStateSearchQuery,
                  );
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: formCard),
                        const SizedBox(width: AppDimensions.paddingXL),
                        const Expanded(flex: 5, child: LocationInfoCards()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      formCard,
                      const SizedBox(height: AppDimensions.paddingLG),
                      const LocationInfoCards(),
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
