# Firestore Seeding and Dashboard/App Sync

This document defines the production-safe seeding flow and the shared Firestore contract used by:

- Flutter app (`formula_scholar`)
- Angular control dashboard (`formula_dashboard/formula_control_app`)

## Golden Rules Alignment

- UI does not call Firestore admin APIs directly.
- Seeding is done by controlled scripts only.
- Collection names and grade id formats are documented (no magic values).
- Dashboard governance data path is observable by source (`api`, `firestore`, `mock`).
- Service account private key must stay server-side and must never be embedded in frontend code.

## Prerequisites

- Node.js installed for `firestore-seeder` scripts
- Dart/Flutter installed for app seeding scripts
- A valid Firebase Admin service-account JSON available locally

Environment option:

- `FIREBASE_SERVICE_ACCOUNT_PATH` can be used instead of passing a file path argument.

## Recommended Seed Order

1. Seed common curriculum baseline (Node):

```bash
node firestore-seeder/seed_all.js <path-to-service-account.json>
```

2. Verify dashboard registries exist (Dart):

```bash
dart run scripts/verify_dashboard_registries.dart <path-to-service-account.json>
```

3. Seed app-specific data and test user (Dart):

```bash
dart run scripts/populate_firestore.dart <path-to-service-account.json>
```

4. Seed additional MSBSHSE board data (Dart):

```bash
dart run scripts/populate_msbshse.dart <path-to-service-account.json>
```

## NPM Shortcuts

From `formula_scholar/firestore-seeder`:

```bash
npm run seed:all -- <path-to-service-account.json>
npm run seed:base -- <path-to-service-account.json>
npm run seed:subjects -- <path-to-service-account.json>
npm run seed:formulas -- <path-to-service-account.json>
npm run seed:practice -- <path-to-service-account.json>
npm run seed:curriculum-registry -- <path-to-service-account.json>
npm run seed:content-registry -- <path-to-service-account.json>
npm run seed:status -- <path-to-service-account.json>
```

## Shared Firestore Contract

### Core curriculum data (Flutter app)

- `countries/{countryId}`
- `countries/{countryId}/states/{stateId}`
- `boards/{boardId}`
- `boards/{boardId}/classes/{gradeId}`
- `boards/{boardId}/grades/{gradeId}` (legacy compatibility)
- `subjects/{subjectId}`
- `subjects/{subjectId}/chapters/{chapterId}`
- `subjects/{subjectId}/chapters/{chapterId}/formulas/{formulaId}`
- `subjects/{subjectId}/mastery_tools/{toolId}`
- `practice_questions/{questionId}`
- `users/{uid}`
- `users/{uid}/stats/current`
- `users/{uid}/recent_studies/{itemId}`

### Dashboard governance data (Angular dashboard)

- `dashboard_governance_audit/{eventId}`
- `dashboard_curriculum_registry/current`
- `dashboard_content_registry/current`
- `dashboard_seed_status/current`

Notes:

- Dashboard first prefers API endpoints if configured.
- If API is unavailable and Firebase web config is set, dashboard writes/reads Firestore governance audit.
- `dashboard_curriculum_registry/current` is seeded from canonical curriculum collections for structure control visibility.
- `dashboard_content_registry/current` stores the editable content registry used by the dashboard content manager.
- Registry nodes include `countries`, `states`, `boards`, `grades`, `subjects`, `chapters`, `formulas`, `mastery-tools`, `practice-questions`, and `saved-notes`.
- Dashboard seed-status panel reads `dashboard_seed_status/current` for freshness/health.
- Otherwise dashboard falls back to in-memory mock.

## Grade Id Normalization Rule

Allowed grade id formats:

- `class_9`, `class_10`, ...
- `9`, `10`, ...

Adapters normalize between both formats when needed. Prefer `class_<number>` when writing new documents.

## Post-Seed Sanity Checks

- Onboarding shows country/state/board/grade options.
- Dashboard subject cards load for selected board+grade.
- Chapters and formulas load for selected subject.
- Practice questions load for selected board+grade.
- Dashboard governance panel shows source and can persist audit entries.

## Security

- Never commit Admin SDK service-account JSON files.
- Rotate credentials immediately if a private key is exposed.
- Frontend apps must use Firebase Web config only.
