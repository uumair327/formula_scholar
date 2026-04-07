# Universal Formula App - Industry Grade Architecture Plan

You requested a massive transition to make Formula Scholar a truly **Universal Formula App** with industry-grade backend patterns, pagination, multi-level hierarchy (Country -> State -> Boards -> Class -> Subject), and dynamically isolated content. I have successfully laid the Clean Architecture domain foundation for this. 

Here is exactly how the entire system expands to serve millions of students seamlessly.

## 1. The Onboarding Domain Transformation (Completed)
I have just overhauled the `Onboarding` feature's domain layer completely behind the scenes.
Instead of a simple "Board & Grade" list, the DI graph and Use Cases now fully support:
- `getCountries()` 
- `getStates(countryId)`
- `getBoards(countryId, stateId)` (Differentiated by Enum `national`, `state`, `private`, `examination`)
- `getGrades(boardId)`
All of these now return a `PaginatedResponse<T>` conforming to standard industry cursors to support infinite arrays of data!

## 2. Dynamic Content Resolution Engine
Instead of duplicating a "Kinematics 1D" chapter across *CBSE Class 11*, *ICSE Class 11*, and *Maharashtra State Board Class 11*, we operate on **Universal Content Mapping**.
- Every generic formula/chapter document in Firestore will receive a `targetAudiences` tag array.
- E.g. `topics/kinematics` -> `targetAudiences: ["IN_cbse_11", "IN_icse_11", "IN_mhstate_11", "US_ap_physics_11"]`.
- The flutter application reads the user's saved Onboarding preferences and constructs their unique `identityToken` (e.g. `IN_cbse_11`).
- The `SubjectsRepository` uses a Firestore `ArrayContains` query to perfectly filter only the Universal Content tagged for that student's specific curriculum perfectly quickly without client-side sorting.

## 3. Database Schema Overview

```typescript
// 1. Geography & Curriculum Trees
/countries/{isoCode}            // { name: "India", flagUrl: "..." }
  /states/{stateCode}           // { name: "Maharashtra" }

/boards/{boardId}               // { countryId: "IN", stateId: "MH", type: "state", name: "MSBSHSE" }
  /classes/{classId}            // { classNumber: 10, label: "Class 10" }

// 2. Universal Content Trees 
/subjects/{subjectId}           // { name: "Physics", icon: "atom", audiences: ["IN_cbse_11", ...] }
  /chapters/{chapterId}         // { name: "Kinematics", order: 2, audiences: [...] }
     /formulas/{formulaId}      // { title: "v = u + at", isGeneralContent: true, ... }

// 3. User & Saved Data
/users/{uid}                    // { identityToken: "IN_cbse_11", hasCompletedOnboarding: true }
  /bookmarks/{bookmarkId}       // Pointer to specific formulaId
```

## 4. Next Implementation Steps for Me

1. **Restructure UI (Onboarding Steps 1-4)**: 
   Currently, your Step 1 and Step 2 UI pages have hardcoded strings (e.g., `['India', 'USA']`). I will wire these up to the `OnboardingCubit` to dynamically draw from Firestore using our new Use Cases.
2. **Setup User Identity Token Persistence**:
   Capture the 4 choices in Onboarding, write them to the authenticated user's `users/{uid}` document, and emit the combined `identityToken` into a global `UserSessionCubit`.
3. **Rewrite the Dashboard/Chapter queries**: 
   Change `lib/.../dashboard_firebase_adapter.dart` to inject `identityToken` to query dynamically filtered subjects/chapters.

Review this architecture! If you are satisfied, just type **"Continue with Step 1"** and I will rip out the hardcoded UI and build out the dynamic dropdowns!
