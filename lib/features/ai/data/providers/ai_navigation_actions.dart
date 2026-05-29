import '../../../../core/core.dart';
import '../../domain/domain.dart';

class AiNavigationAction implements AiApplicationAction {
  const AiNavigationAction({
    required this.definition,
    required AiNavigationPort navigation,
    required this.routeName,
    this.usePush = false,
  }) : _navigation = navigation;

  @override
  final AiActionDefinition definition;

  final AiNavigationPort _navigation;
  final String routeName;
  final bool usePush;

  @override
  Future<AiActionResult> execute({
    required AiActionRequest request,
    required AiContextSnapshot context,
  }) async {
    if (usePush) {
      _navigation.pushNamed(routeName);
    } else {
      _navigation.goNamed(routeName);
    }
    return AiActionResult(
      success: true,
      message: 'Done.',
      data: {'route': routeName},
    );
  }
}

class AiGoBackAction implements AiApplicationAction {
  const AiGoBackAction(this._navigation);

  final AiNavigationPort _navigation;

  @override
  AiActionDefinition get definition => const AiActionDefinition(
    id: 'GO_BACK',
    description: 'Navigate back one screen when there is a previous screen.',
    permission: 'ai_navigation',
  );

  @override
  Future<AiActionResult> execute({
    required AiActionRequest request,
    required AiContextSnapshot context,
  }) async {
    final popped = await _navigation.maybePop();
    return AiActionResult(
      success: popped,
      message: popped ? 'Done.' : 'There is no previous screen to go back to.',
    );
  }
}

List<AiApplicationAction> buildFormulaScholarAiActions(
  AiNavigationPort navigation,
) {
  const permission = 'ai_navigation';
  return [
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.dashboardName,
      definition: const AiActionDefinition(
        id: 'OPEN_DASHBOARD',
        description: 'Open the Formula Scholar dashboard/home screen.',
        permission: permission,
      ),
    ),
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.chaptersName,
      definition: const AiActionDefinition(
        id: 'OPEN_SUBJECTS',
        description: 'Open the subjects and chapters screen.',
        permission: permission,
      ),
    ),
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.practiceName,
      definition: const AiActionDefinition(
        id: 'OPEN_PRACTICE',
        description: 'Open the practice quiz screen.',
        permission: permission,
      ),
    ),
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.savedName,
      definition: const AiActionDefinition(
        id: 'OPEN_SAVED',
        description: 'Open saved formulas, bookmarks, and notes.',
        permission: permission,
      ),
    ),
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.profileName,
      definition: const AiActionDefinition(
        id: 'OPEN_PROFILE',
        description: 'Open the user profile and settings screen.',
        permission: permission,
      ),
    ),
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.analyticsName,
      usePush: true,
      definition: const AiActionDefinition(
        id: 'OPEN_ANALYTICS',
        description: 'Open learning analytics and progress insights.',
        permission: permission,
      ),
    ),
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.studyPlannerName,
      usePush: true,
      definition: const AiActionDefinition(
        id: 'OPEN_STUDY_PLANNER',
        description: 'Open the study planner workflow.',
        permission: permission,
      ),
    ),
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.flashcardsName,
      usePush: true,
      definition: const AiActionDefinition(
        id: 'OPEN_FLASHCARDS',
        description: 'Open flashcards for spaced repetition.',
        permission: permission,
      ),
    ),
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.cheatSheetName,
      usePush: true,
      definition: const AiActionDefinition(
        id: 'OPEN_CHEAT_SHEET',
        description: 'Open the formula cheat sheet.',
        permission: permission,
      ),
    ),
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.helpSupportName,
      usePush: true,
      definition: const AiActionDefinition(
        id: 'OPEN_HELP_SUPPORT',
        description: 'Open Help and Support for questions or tickets.',
        permission: permission,
      ),
    ),
    AiNavigationAction(
      navigation: navigation,
      routeName: AppRoutes.aiSettingsName,
      usePush: true,
      definition: const AiActionDefinition(
        id: 'OPEN_AI_SETTINGS',
        description: 'Open AI provider, model, and API key settings.',
        permission: permission,
      ),
    ),
    AiGoBackAction(navigation),
  ];
}
