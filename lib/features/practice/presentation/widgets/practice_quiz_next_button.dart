import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';

import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';

class QuizNextButton extends StatelessWidget {
  const QuizNextButton({super.key, required this.state});
  final PracticeState state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppDimensions.paddingLG,
      left: AppDimensions.paddingXXL,
      right: AppDimensions.paddingXXL,
      child: SafeArea(
        child: AppGradientButton(
          label: state.isLastQuestion
              ? context.l10n.quizCompleteTitle
              : context.l10n.nextQuestion,
          onPressed: () => context.read<PracticeCubit>().nextQuestion(),
        ),
      ),
    );
  }
}
