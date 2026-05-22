import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/flashcards_cubit.dart';
import '../cubit/flashcards_state.dart';
import '../widgets/flashcard_start_view.dart';
import '../widgets/flashcard_study_view.dart';

class FlashcardsPage extends StatelessWidget {
  const FlashcardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        titleWidget: Text(
          AppStrings.flashcardStudy,
          style: AppTextStyles.titleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: BlocBuilder<FlashcardsCubit, FlashcardsState>(
        builder: (context, state) {
          return switch (state.status) {
            FlashcardsStatus.initial ||
            FlashcardsStatus.loading =>
              const FlashcardStartView(),
            FlashcardsStatus.ready =>
              FlashcardStudyView(state: state),
            FlashcardsStatus.finished =>
              FlashcardCompleteView(state: state),
          };
        },
      ),
    );
  }
}
