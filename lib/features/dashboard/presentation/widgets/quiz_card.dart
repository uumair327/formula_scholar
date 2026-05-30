library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';

import '../cubit/daily_challenges_cubit.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import 'daily_challenge_dialog.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      color: colorScheme.primary.withValues(
        alpha: AppDimensions.opacityOverlay,
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      border: Border.all(
        color: colorScheme.primary.withValues(
          alpha: AppDimensions.opacityFaint,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconCircle(
                icon: LucideIcons.helpCircle,
                size: AppDimensions.avatarMD,
                backgroundColor: colorScheme.primaryContainer,
                iconSize: AppDimensions.iconLG,
                borderRadius: AppDimensions.radiusXL,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSM,
                  vertical: AppDimensions.paddingXXS,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Text(
                  context.l10n.dashboardLive,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onError,
                    fontSize: AppDimensions.fontSizeXXSPlus,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.boardReadyQuizTitle,
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    context.l10n.boardReadyQuizDescription,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          SizedBox(
            width: double.infinity,
            child: Semantics(
              label: context.l10n.startQuiz,
              button: true,
              child: BlocBuilder<DailyChallengesCubit, DailyChallengesState>(
                builder: (context, challengeState) {
                  final challenge = challengeState.selected;
                  return BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, dashState) {
                      return ElevatedButton(
                        onPressed: challenge == null
                            ? null
                            : () {
                                DailyChallengeDialog.show(
                                  context: context,
                                  formulaTitle: challenge.formulaTitle,
                                  formulaLatex: challenge.formulaLatex,
                                  question: challenge.question,
                                  options: challenge.options,
                                  correctIndex: challenge.correctIndex,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.progressBarMD,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXL,
                            ),
                          ),
                          textStyle: AppTextStyles.labelLarge,
                        ),
                        child: Text(
                          context.l10n.startNowLabel,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
