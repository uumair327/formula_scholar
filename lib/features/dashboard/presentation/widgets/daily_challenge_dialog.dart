import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class DailyChallengeDialog extends StatelessWidget {
  const DailyChallengeDialog({
    super.key,
    required this.formulaTitle,
    required this.formulaLatex,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  final String formulaTitle;
  final String formulaLatex;
  final String question;
  final List<String> options;
  final int correctIndex;

  static void show({
    required BuildContext context,
    required String formulaTitle,
    required String formulaLatex,
    required String question,
    required List<String> options,
    required int correctIndex,
  }) {
    showDialog(
      context: context,
      builder: (_) => DailyChallengeDialog(
        formulaTitle: formulaTitle,
        formulaLatex: formulaLatex,
        question: question,
        options: options,
        correctIndex: correctIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.zap,
                size: 40,
                color: colorScheme.primary,
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              Text(
                AppStrings.dailyChallenge,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                AppStrings.dailyChallengeDesc,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.paddingLG),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Column(
                  children: [
                    Text(
                      formulaTitle,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Math.tex(
                        formulaLatex,
                        textStyle: AppTextStyles.headlineSmall.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Text(
                question,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              ...List.generate(options.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.paddingSM),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showResult(context, index == correctIndex);
                      },
                      child: Text(options[index]),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showResult(BuildContext context, bool isCorrect) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCorrect ? LucideIcons.checkCircle : LucideIcons.xCircle,
              size: 48,
              color: isCorrect ? Colors.green : Colors.red,
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Text(
              isCorrect ? 'Correct!' : 'Not quite',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              isCorrect
                  ? 'Great job! Keep up the daily practice.'
                  : 'Keep practicing! You will get it next time.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.gotIt),
          ),
        ],
      ),
    );
  }
}
