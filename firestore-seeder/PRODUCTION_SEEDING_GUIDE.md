# Production Data Seeding Guide

## Overview

The Formula Scholar project includes comprehensive Firebase/Firestore data seeding scripts to populate production-level data. This guide explains the seeding architecture, how to run seeds, and what data is included.

## Quick Start

### Option 1: Production Seed (Recommended)

Seeds all data in correct dependency order with enhanced production content:

```bash
cd formula_scholar/firestore-seeder
npm install  # First time only
npm run seed:production ../path/to/service-account.json
```

### Option 2: Custom Seeding

Run individual seeders as needed:

```bash
npm run seed:base               # Countries, States, Boards, Grades
npm run seed:subjects           # Subjects, Chapters
npm run seed:formulas:enhanced  # Production formulas with examples
npm run seed:practice:enhanced  # Quizzes and practice questions
npm run seed:registry:enhanced  # Curriculum & content metadata
```

## Seeding Architecture

### Execution Stages

```
FOUNDATION STAGE
├─ seed.js                  → Countries, States, Boards, Grades (hierarchical)

STRUCTURE STAGE
├─ seed_subjects.js         → Subjects, Chapters, Mastery Tools

CONTENT STAGE (Enhanced)
├─ seed_formulas_enhanced.js   → 30+ formulas with LaTeX, examples, tags
├─ seed_practice_enhanced.js   → 6+ quizzes with 20+ practice questions

DASHBOARD STAGE
├─ seed_registry_enhanced.js   → Curriculum & content registry with student stats
├─ seed_curriculum_registry.js → Curriculum control metadata
├─ seed_content_registry.js    → Content control metadata
└─ seed_status.js              → Dashboard sync metadata
```

### Data Hierarchy

```
Countries (India)
├─ States (Maharashtra, Delhi, Karnataka)
├─ Boards (CBSE, ICSE, State Board)
│  └─ Grades (8, 9, 10, 11, 12)
│
Subjects (Math, Physics, Chemistry, Biology)
├─ Chapters (Polynomials, Motion, Atomic Structure, Genetics)
│  ├─ Formulas (30+ with LaTeX rendering)
│  ├─ Quizzes (6+ with 20+ questions)
│  └─ Practice Questions
│
Curriculum Registry
└─ Content Registry with Student Engagement Stats
```

## Enhanced Production Data

### Mathematics (math_001)

**Chapter 1: Polynomials & Algebra**

- Quadratic Formula: x = (-b ± √(b²-4ac)) / 2a
- Difference of Squares: a² - b² = (a-b)(a+b)
- Perfect Square Trinomial: (a±b)² = a² ± 2ab + b²
- Sum of Cubes, Difference of Cubes
- **Quizzes**: 2 quizzes, 10+ questions covering factoring and roots

**Chapter 2: Trigonometry**

- Pythagorean Identity: sin²θ + cos²θ = 1
- Law of Sines: a/sinA = b/sinB = c/sinC
- Angle Sum Formulas: sin(A±B), cos(A±B)
- **Quizzes**: 1 quiz, 8+ questions on identities and applications

### Physics (physics_001)

**Chapter 1: Motion & Kinematics**

- Displacement: s = ut + ½at²
- Velocity: v = u + at
- Third Equation: v² = u² + 2as
- **Quizzes**: 1 quiz, 6 questions on motion problems

**Chapter 2: Forces & Newton's Laws**

- Newton's Second Law: F = ma
- More formulas and quizzes for comprehensive coverage

### Chemistry (chemistry_001)

**Chapter 1: Atomic Structure**

- Energy of Photon: E = hν = hc/λ
- Molarity: M = n/V(L)
- **Quizzes**: 1 quiz with 7 questions on quantum mechanics

### Biology (biology_001)

**Chapter 1: Cell Biology & Genetics**

- Hardy-Weinberg Equation: p² + 2pq + q² = 1
- Mitotic Index calculation
- **Quizzes**: Genetic and cell division problems

## Production-Level Features

### Formula Metadata

Each formula includes:

```javascript
{
  id: 'formula_poly_001',
  title: 'Quadratic Formula',
  latex: 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}',
  description: 'Detailed explanation...',
  category: 'algebraic',
  difficulty: 'intermediate',
  examples: ['Example 1', 'Example 2'],
  audiences: ['IN_cbse_10', 'IN_cbse_11'],  // Board/class targeting
  tags: ['algebra', 'quadratic', 'roots'],
  relatedFormulas: ['formula_ref_001'],
  createdAt: serverTimestamp,
  updatedAt: serverTimestamp
}
```

### Quiz & Questions Metadata

```javascript
{
  id: 'quiz_poly_001',
  title: 'Quadratic Equations & Factoring',
  difficulty: 'intermediate',
  duration: 15,  // minutes
  passingScore: 70,  // percentage
  questions: [
    {
      id: 'q1',
      type: 'multiple-choice',
      question: 'Find roots...',
      options: [...],
      explanation: 'Detailed explanation...',
      relatedFormulas: ['formula_poly_001']
    }
  ]
}
```

### Curriculum Registry

Tracks curriculum-level aggregates:

```javascript
{
  id: 'cbse_10_2024',
  board: 'CBSE',
  class: 10,
  totalChapters: 15,
  totalFormulas: 85,
  totalQuestions: 120,
  status: 'published',
  coverage: { formulas: 85, quizzes: 12, practiceQuestions: 120 },
  stats: {
    averageDifficulty: 'intermediate',
    estimatedCompletionHours: 45,
    activeStudents: 1250
  }
}
```

### Content Registry

Tracks content-level metadata:

```javascript
{
  id: 'content_math_polynomials',
  contentType: 'chapter',
  subject: 'math_001',
  chapter: 'chap_01',
  formulas: ['formula_poly_001', ...],
  quizzes: ['quiz_poly_001', ...],
  metadata: {
    difficulty: 'easy-to-intermediate',
    estimatedHours: 8,
    prerequisites: [],
    targetAudiences: ['IN_cbse_8', 'IN_cbse_9', 'IN_cbse_10'],
    learningOutcomes: [...]
  },
  stats: {
    totalStudentsEnrolled: 5200,
    averageCompletion: 82,
    averageScore: 76
  }
}
```

## Data Statistics

### Coverage by Subject

| Subject     | Chapters | Formulas | Quizzes | Questions |
| ----------- | -------- | -------- | ------- | --------- |
| Mathematics | 2+       | 12+      | 2+      | 15+       |
| Physics     | 2+       | 4+       | 1+      | 6+        |
| Chemistry   | 1+       | 2+       | 1+      | 7+        |
| Biology     | 1+       | 2+       | 1+      | 8+        |
| **Total**   | **6+**   | **20+**  | **5+**  | **36+**   |

### Coverage by Board

| Board     | Classes  | Curricula | Total Formulas | Total Questions |
| --------- | -------- | --------- | -------------- | --------------- |
| CBSE      | 10, 11   | 2         | 205            | 300+            |
| ICSE      | 10       | 1         | 75             | 100             |
| **Total** | **8-12** | **3**     | **280+**       | **400+**        |

## Running Production Seed

### Step 1: Prepare Service Account

```bash
# Ensure you have the Firebase service account JSON
export FIREBASE_SERVICE_ACCOUNT_PATH=/path/to/adminsdk.json
```

### Step 2: Run Production Seeder

```bash
cd formula_scholar/firestore-seeder
npm install
npm run seed:production $FIREBASE_SERVICE_ACCOUNT_PATH
```

### Step 3: Monitor Progress

The seeder displays:

- Stage name and description
- Script name and estimated time
- Real-time progress with checkmarks
- Error handling with graceful continuation
- Final summary with timing breakdown

### Expected Output

```
══════════════════════════════════════════════════
🌱 FORMULA SCHOLAR - PRODUCTION DATA SEEDER 🌱
══════════════════════════════════════════════════

Service Account: /path/to/adminsdk.json

──────────────────────────────────────────────────
[1/8] FOUNDATION STAGE
──────────────────────────────────────────────────
▶ seed.js
  Base entities (Countries, States, Boards, Grades)

  Seeding Database...
  ✓ Created countries collection
  ✓ Created states for each country
  ✓ Created boards
  ✓ Created grades for each board

✅ Completed in 2.15s

[2/8] STRUCTURE STAGE
...

📊 SEEDING SUMMARY
═════════════════════════════════════════════════════

Total Time: 28.47s
Successful: ✅ 8/8
Failed: ❌ 0/8

✅ ALL SEEDERS COMPLETED SUCCESSFULLY!

📊 Your database is now populated with production-level data:
   • Multiple subjects (Math, Physics, Chemistry, Biology)
   • 4+ chapters per subject with comprehensive formulas
   • 30+ production formulas with LaTeX rendering
   • 6+ quizzes with 20+ practice questions
   • Curriculum registry for CBSE/ICSE boards (Classes 8-12)
   • Content registry with student engagement stats
   • Dashboard-ready metadata and indexes

🎉 Ready for production use!
```

## Verifying Seeded Data

### Check in Firestore Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your Formula Scholar project
3. Navigate to Firestore Database
4. Verify these collections exist:
   - `subjects` (with chapters → formulas → quizzes)
   - `curriculumRegistry` (with 3+ curricula)
   - `contentRegistry` (with 3+ content entries)
   - `indexes` (with subjects and boards indexes)

### Query Examples

**Get all formulas in a chapter:**

```javascript
db.collection("subjects")
  .doc("math_001")
  .collection("chapters")
  .doc("chap_01")
  .collection("formulas")
  .get();
```

**Get curriculum for CBSE Class 10:**

```javascript
db.collection("curriculumRegistry")
  .where("board", "==", "CBSE")
  .where("class", "==", 10)
  .get();
```

**Get content by subject:**

```javascript
db.collection("contentRegistry").where("subject", "==", "math_001").get();
```

## Customization

### Add More Formulas

Edit `seed_formulas_enhanced.js` and add to the `formulaData` object:

```javascript
const formulaData = {
  math_001: {
    chapters: {
      chap_03: {
        // New chapter
        name: "New Chapter",
        formulas: [
          {
            id: "formula_new_001",
            title: "New Formula",
            latex: "...",
            description: "...",
            // ... other metadata
          },
        ],
      },
    },
  },
};
```

### Add More Quizzes

Edit `seed_practice_enhanced.js` and add questions with multiple difficulty levels.

### Update Curricula

Edit `seed_registry_enhanced.js` to add new boards, classes, or years.

## Troubleshooting

### Issue: "Service account file not found"

**Solution**: Provide the correct path to your Firebase service account JSON:

```bash
npm run seed:production /absolute/path/to/adminsdk.json
```

### Issue: "Quota exceeded" errors

**Solution**: Firebase has write limits. Wait a few minutes between large seed operations, or delete existing data first.

### Issue: Some seeders fail but others succeed

**Solution**: This is normal for production seeding. Failed seeders often continue to next step. Check logs for specific errors and re-run failed seeders individually:

```bash
npm run seed:formulas:enhanced /path/to/adminsdk.json
```

### Issue: Data appears but is incomplete

**Solution**: Verify all seeder scripts ran successfully. Check the final summary for failed stages.

## Performance Considerations

### Seeding Time

- Foundation stage: ~2 seconds
- Structure stage: ~3 seconds
- Content stage: ~8 seconds
- Dashboard stage: ~15 seconds
- **Total**: ~30 seconds (varies with network)

### Database Size

- Formulas: ~30 documents + nested quizzes/questions
- Registry: ~50-100 documents
- Indexes: 2 documents
- **Total**: ~100-200 documents (varies with subject count)

### Optimization

- Batch writes (100 operations per batch)
- Concurrent writes where possible
- Nested collections for formulas/questions to optimize queries

## Next Steps

After seeding:

1. **Dashboard Integration**: Update Angular dashboard to query these collections
2. **App Integration**: Update Flutter app to fetch formulas and practice quizzes
3. **Analytics**: Monitor student engagement stats in contentRegistry
4. **Updates**: Re-seed on content updates (formulas, quizzes, curricula)
5. **Backups**: Export Firestore data regularly

## Production Checklist

- [ ] Service account JSON securely stored
- [ ] Production seed run successfully
- [ ] All collections verified in Firestore Console
- [ ] Sample queries tested from Flutter app
- [ ] Sample queries tested from Angular dashboard
- [ ] Dashboard displays curricula and formulas correctly
- [ ] App displays practice quizzes with questions
- [ ] Performance monitored (no slow queries)
- [ ] Data backup created
- [ ] Rollout plan documented for production

## Support

For issues or questions:

1. Check the troubleshooting section
2. Review Firebase documentation
3. Check Firestore logs in Firebase Console
4. File an issue with detailed error messages

---

**Last Updated**: May 3, 2026
**Seeding Version**: 2.0 (Production Edition)
