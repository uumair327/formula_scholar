import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/flashcards/flashcards.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> flashcardRoutes() {
  return [
    GoRoute(
      path: AppRoutes.flashcardsPath,
      name: AppRoutes.flashcardsName,
      pageBuilder: (context, state) {
        final extra = state.extra;
        return AppPageTransitions.fadeTransition(
          state: state,
          child: extra is FlashcardsCubit
              ? BlocProvider.value(
                  value: extra,
                  child: const FlashcardsPage(),
                )
              : BlocProvider(
                  create: (_) => getIt<FlashcardsCubit>(),
                  child: const FlashcardsPage(),
                ),
        );
      },
    ),
  ];
}

