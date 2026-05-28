Localization Migration Checklist

Purpose: grouped list of remaining `AppStrings.*` usages and recommended action (presentation vs adapters).

Presentation (consider refactor or UI mapping):

- lib/features/chapters/presentation/cubit/subject_stats_cubit.dart: fallback `AppStrings.unknownGrade` (gradeLabel)
- lib/features/chapters/presentation/cubit/formulas_cubit.dart: `chapterName ?? AppStrings.chapterLabel` (used when marking chapter started)
- lib/features/dashboard/presentation/cubit/dashboard_state.dart: many fallbacks still use `AppStrings.*` (hero badge/title/description, vault desc, resume labels, quick action labels, live/quiz labels, noRecent, openChapters). Note: `DashboardState` is context-free; it uses `localizedContent` and `AppStrings` as fallback — recommended approach: keep AppStrings in state, map to `context.l10n` in UI where possible, or inject a localized fallback provider into state.

Cubits (error messages migrated where possible):

- lib/features/dashboard/presentation/cubit/dashboard_cubit.dart: now emits `errorKey` (done)
- lib/features/dashboard/presentation/cubit/curriculum_options_cubit.dart: now emits `errorKey` (done)
- lib/features/profile/presentation/cubit/profile_cubit.dart: now emits `errorKey` (done)
- lib/features/chapters/presentation/cubit/formulas_cubit.dart: emits `errorKey` for failures (done)

Adapters / Domain (keep AppStrings; avoid UI context):

- lib/shared/infrastructure/adapters/curriculum_firebase_adapter.dart: unknown grade fallback
- lib/features/onboarding/infrastructure/adapters/onboarding_firebase_adapter.dart: unknown grade fallback
- lib/features/profile/infrastructure/adapters/profile_firebase_adapter.dart: many item labels (formulasMastered, daysStreak, totalPoints, accountInformation, myBookmarks, studyPlanner, subtitles, achievements, notifications, languageAndLocalization, appearance, helpAndSupport, logout, etc.) — these are adapter-provided labels used as payload metadata; recommended to keep `AppStrings` here.

Shared widgets already migrated in this pass:

- lib/shared/widgets/states/app_error_state.dart
- lib/shared/widgets/coming_soon_sheet.dart
- lib/shared/widgets/legal_footer.dart
- lib/shared/widgets/legal_effective_date_badge.dart
- lib/shared/widgets/legal_page.dart

Next recommended actions:

1. Run `flutter gen-l10n` locally to regenerate localization getters.
2. Decide how to handle `DashboardState` fallbacks: leave AppStrings, or inject a localization provider into state constructors.
3. If desired, I can migrate the remaining presentation cubit fallbacks by:
   - Moving fallbacks into widgets (use `context.l10n`) and passing localized values into cubit calls, or
   - Refactoring state to accept an `AppLocalizations`-like provider.

If you want me to continue automatically, choose one:

- A: Migrate presentation fallbacks by moving localized defaults into UI (preferred, minimal scope).
- B: Refactor `DashboardState` to accept a localization provider (larger change).
- C: Stop here so you can run `flutter gen-l10n` and test locally.

Generated: LOCALIZATION_MIGRATION_CHECKLIST.md
