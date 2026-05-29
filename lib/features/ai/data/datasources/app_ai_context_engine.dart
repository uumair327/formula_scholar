import 'dart:ui';

import '../../../auth/auth.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

class AppAiContextEngine implements AiContextEnginePort {
  const AppAiContextEngine({
    required AiNavigationPort navigation,
    required GetCurrentAuthUserUseCase getCurrentAuthUser,
    required CurriculumCubit curriculumCubit,
    required SubjectSelectionCubit subjectSelectionCubit,
  }) : _navigation = navigation,
       _getCurrentAuthUser = getCurrentAuthUser,
       _curriculumCubit = curriculumCubit,
       _subjectSelectionCubit = subjectSelectionCubit;

  final AiNavigationPort _navigation;
  final GetCurrentAuthUserUseCase _getCurrentAuthUser;
  final CurriculumCubit _curriculumCubit;
  final SubjectSelectionCubit _subjectSelectionCubit;

  @override
  Future<AiContextSnapshot> buildSnapshot() async {
    final user = _getCurrentAuthUser();
    final curriculum = _curriculumCubit.state.curriculum;
    final subject = _subjectSelectionCubit.state.subject;
    final isAuthenticated = user != null;

    return AiContextSnapshot(
      currentRoute: _navigation.currentLocation,
      userRole: isAuthenticated ? 'student' : 'guest',
      isAuthenticated: isAuthenticated,
      permissions: isAuthenticated
          ? const ['ai_navigation', 'read_learning_context']
          : const [],
      availableFeatures: const [
        'dashboard',
        'subjects',
        'chapters',
        'formulas',
        'practice',
        'saved',
        'profile',
        'analytics',
        'study_planner',
        'flashcards',
        'cheat_sheet',
        'help_support',
        'ai_settings',
      ],
      curriculumLabel: curriculum?.displayBadge,
      curriculumKey: curriculum?.curriculumKey,
      selectedSubject: subject?.name,
      localeCode: PlatformDispatcher.instance.locale.toLanguageTag(),
    );
  }
}
