# Firebase/Firestore Seeding System

## Overview

Complete production-level data seeding system for Formula Scholar. Includes countries, states, boards, subjects, chapters, formulas, quizzes, practice questions, and curriculum/content registry metadata.

## Features

### ✅ Implemented

- **Hierarchical Geographic Data**: Countries → States → Boards → Grades
- **Subject-Chapter-Content Structure**: Subjects with chapters containing formulas and quizzes
- **30+ Production Formulas**: With LaTeX rendering, examples, tags, and audience targeting
- **6+ Production Quizzes**: With 20+ practice questions and difficulty levels
- **Curriculum Registry**: Tracks curricula for CBSE, ICSE (Classes 8-12)
- **Content Registry**: Chapter-level metadata with student engagement stats
- **Dashboard Indexes**: Quick lookups by subject and board
- **Batch Operations**: Optimized writes with configurable batch sizes
- **Graceful Error Handling**: Continue on individual script failure
- **Progress Reporting**: Real-time feedback with timing and statistics

### 📊 Data Volumes

| Entity           | Count | Details                                               |
| ---------------- | ----- | ----------------------------------------------------- |
| Subjects         | 4     | Math, Physics, Chemistry, Biology                     |
| Chapters         | 6+    | Polynomials, Motion, Atomic Structure, Genetics, etc. |
| Formulas         | 30+   | With LaTeX, examples, tags, audiences                 |
| Quizzes          | 6+    | With 20+ practice questions                           |
| Curricula        | 3     | CBSE Class 10/11, ICSE Class 10                       |
| Content Registry | 3+    | Chapter-level metadata                                |

## Quick Start

### Installation

```bash
cd formula_scholar/firestore-seeder
npm install
```

### Run Production Seed

```bash
npm run seed:production /path/to/firebase-adminsdk.json
```

### Run Individual Seeders

```bash
npm run seed:base                  # Base hierarchy
npm run seed:subjects              # Subjects and chapters
npm run seed:formulas:enhanced     # Production formulas
npm run seed:practice:enhanced     # Quizzes and questions
npm run seed:registry:enhanced     # Curriculum metadata
npm run seed:all                   # Legacy all seeders
```

## Scripts

### Foundation Scripts

#### `seed.js` - Geographic & Hierarchical Data

Sets up the foundation:

- Countries (India)
- States (Maharashtra, Delhi, Karnataka)
- Boards (CBSE, ICSE, State Board, Private)
- Grades (8, 9, 10, 11, 12)

#### `seed_subjects.js` - Subject Structure

Creates subjects and chapters:

- Mathematics, Physics, Chemistry, Biology
- 4+ chapters per subject
- Mastery tools and learning objectives

### Enhanced Content Scripts

#### `seed_formulas_enhanced.js` - Production Formulas

**NEW!** Production-level formula data with:

- 30+ formulas with LaTeX rendering
- Detailed descriptions
- Real-world examples
- Category and difficulty ratings
- Target audience specifications
- Related tags and references

**Example Formulas**:

- Math: Quadratic formula, Difference of squares, Trigonometric identities
- Physics: Equations of motion, Newton's laws, Energy formulas
- Chemistry: Photon energy, Molarity calculations
- Biology: Hardy-Weinberg equation, Cell division

#### `seed_practice_enhanced.js` - Quizzes & Questions

**NEW!** Production-level practice data with:

- 6+ quizzes across subjects
- 20+ practice questions with multiple question types
- Multiple choice questions with explanations
- Short answer questions with correct answers
- Difficulty levels (easy, intermediate, hard)
- Time estimates and passing scores
- Related formula references

**Example Quizzes**:

- Quadratic Equations & Factoring (10 questions)
- Trigonometric Identities (8 questions)
- Equations of Motion (6 questions)
- Energy & Photons (7 questions)

#### `seed_registry_enhanced.js` - Curriculum & Content Registry

**NEW!** Dashboard metadata with:

- Curriculum registry (3 curricula for CBSE/ICSE)
- Content registry with chapter-level metadata
- Student engagement statistics
- Learning outcomes and prerequisites
- Lookup indexes for fast queries

**Includes**:

- CBSE Class 10 (2024): 15 chapters, 85 formulas, 120 questions
- CBSE Class 11 (2024): 18 chapters, 120 formulas, 180 questions
- ICSE Class 10 (2024): 14 chapters, 75 formulas, 100 questions

### Dashboard Scripts

#### `seed_curriculum_registry.js` - Curriculum Control

Original curriculum metadata for dashboard control.

#### `seed_content_registry.js` - Content Control

Original content metadata for dashboard management.

#### `seed_status.js` - Sync Metadata

Dashboard seed/sync tracking and status.

## Production Seeding Workflow

### Execution Order

```
1. seed.js                      [Foundation: 2s]
   ↓
2. seed_subjects.js             [Structure: 3s]
   ↓
3. seed_formulas_enhanced.js    [Content: 4s]
   ↓
4. seed_practice_enhanced.js    [Content: 4s]
   ↓
5. seed_registry_enhanced.js    [Dashboard: 8s]
   ↓
6. seed_curriculum_registry.js  [Dashboard: 3s]
   ↓
7. seed_content_registry.js     [Dashboard: 2s]
   ↓
8. seed_status.js               [Dashboard: 2s]

Total: ~30 seconds (all stages)
```

## Data Structure

### Collections Overview

```
subjects/
├─ math_001/
│  ├─ chapters/
│  │  ├─ chap_01/ (Polynomials)
│  │  │  ├─ formulas/
│  │  │  │  ├─ formula_poly_001 (Quadratic Formula)
│  │  │  │  └─ ... (4+ formulas)
│  │  │  └─ quizzes/
│  │  │     ├─ quiz_poly_001/
│  │  │     │  └─ questions/ (10+ questions)
│  │  │     └─ quiz_poly_002/
│  │  └─ chap_02/ (Trigonometry)
│  │     └─ ... (formulas, quizzes)
│  └─ ...
│
├─ physics_001/, chemistry_001/, biology_001/
│
curriculumRegistry/
├─ cbse_10_2024 (CBSE Class 10)
├─ cbse_11_2024 (CBSE Class 11)
└─ icse_10_2024 (ICSE Class 10)

contentRegistry/
├─ content_math_polynomials
├─ content_trig_identities
└─ content_physics_motion

indexes/
├─ subjects
└─ boards
```

### Formula Document Structure

```javascript
{
  id: "formula_poly_001",
  title: "Quadratic Formula",
  latex: "x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}",
  description: "Solves quadratic equations...",
  category: "algebraic",
  difficulty: "intermediate",
  isGeneralContent: true,
  audiences: ["IN_cbse_10", "IN_cbse_11", "IN_icse_10"],
  examples: ["x² + 5x + 6 = 0 → x = -2, -3", ...],
  tags: ["algebra", "quadratic", "roots", "discriminant"],
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### Quiz Document Structure

```javascript
{
  id: "quiz_poly_001",
  title: "Quadratic Equations & Factoring",
  description: "Master quadratic equations...",
  difficulty: "intermediate",
  duration: 15, // minutes
  totalQuestions: 10,
  passingScore: 70,
  createdAt: timestamp,
  questions/: {  // subcollection
    q1: {
      type: "multiple-choice",
      question: "Find the roots...",
      options: [
        { id: "a", text: "x = 2, 3", isCorrect: true },
        // ...
      ],
      explanation: "Using factorization...",
      relatedFormulas: ["formula_poly_001"]
    }
  }
}
```

### Curriculum Registry Structure

```javascript
{
  id: "cbse_10_2024",
  board: "CBSE",
  class: 10,
  year: 2024,
  name: "CBSE Class 10 (2024)",
  subjects: ["math_001", "physics_001", ...],
  totalChapters: 15,
  totalFormulas: 85,
  totalQuestions: 120,
  status: "published",
  coverage: {
    formulas: 85,
    quizzes: 12,
    practiceQuestions: 120
  },
  stats: {
    averageDifficulty: "intermediate",
    estimatedCompletionHours: 45,
    activeStudents: 1250
  },
  publishedAt: timestamp,
  lastUpdatedAt: timestamp
}
```

## Usage Examples

### Run Full Production Seed

```bash
npm run seed:production /path/to/adminsdk.json
```

### Run Specific Seeder

```bash
npm run seed:formulas:enhanced /path/to/adminsdk.json
```

### With Environment Variable

```bash
export FIREBASE_SERVICE_ACCOUNT_PATH=/path/to/adminsdk.json
npm run seed:production
```

## Customization Guide

### Add New Formulas

Edit `seed_formulas_enhanced.js`:

```javascript
const formulaData = {
  math_001: {
    chapters: {
      chap_03: {
        // New chapter
        name: "Linear Algebra",
        formulas: [
          {
            id: "formula_la_001",
            title: "Matrix Determinant",
            latex: "...",
            // ... metadata
          },
        ],
      },
    },
  },
};
```

### Add New Quizzes

Edit `seed_practice_enhanced.js`:

```javascript
const practiceData = {
  math_001: {
    chap_03: {
      chapterName: 'Linear Algebra',
      quizzes: [
        {
          id: 'quiz_la_001',
          title: 'Matrix Operations',
          questions: [...]
        }
      ]
    }
  }
};
```

### Add New Curricula

Edit `seed_registry_enhanced.js`:

```javascript
const curriculumRegistry = [
  {
    id: "state_board_10",
    board: "State Board",
    class: 10,
    // ... metadata
  },
];
```

## Verification

### In Firestore Console

1. Go to Firebase Console
2. Select Formula Scholar project
3. Navigate to Firestore Database
4. Verify collections exist:
   - `subjects` with chapters/formulas/quizzes
   - `curriculumRegistry` with 3+ entries
   - `contentRegistry` with 3+ entries
   - `indexes` with subjects/boards

### Query Examples

```javascript
// Get all formulas in Polynomials chapter
db.collection("subjects")
  .doc("math_001")
  .collection("chapters")
  .doc("chap_01")
  .collection("formulas")
  .get();

// Get CBSE Class 10 curriculum
db.collection("curriculumRegistry")
  .where("board", "==", "CBSE")
  .where("class", "==", 10)
  .get();

// Get content for Mathematics
db.collection("contentRegistry").where("subject", "==", "math_001").get();
```

## Performance

### Seeding Time Breakdown

- Foundation: 2-3 seconds
- Structure: 2-3 seconds
- Formulas: 3-5 seconds
- Quizzes: 3-5 seconds
- Registry: 8-12 seconds
- Total: 25-35 seconds

### Optimization Techniques

- Batch writes (100 operations per batch)
- Nested collections for related data
- Concurrent operations where possible
- Minimal field data to reduce write size

## Troubleshooting

| Issue                            | Solution                                                           |
| -------------------------------- | ------------------------------------------------------------------ |
| "Service account file not found" | Use absolute path: `/absolute/path/to/adminsdk.json`               |
| "Quota exceeded"                 | Wait 1-2 minutes between large seeds                               |
| Script fails but others continue | Check individual script with: `npm run seed:formulas:enhanced ...` |
| No data appears in Firestore     | Verify service account has write permissions                       |
| Slow seeding                     | Check network connection, try again during off-peak hours          |

## Integration

### Angular Dashboard

Query `curriculumRegistry` and `contentRegistry` for:

- Curriculum listing by board/class
- Content statistics and student engagement
- Learning outcomes and prerequisites
- Chapter coverage information

### Flutter App

Query `subjects`, `chapters`, `formulas`, and `quizzes`:

- Display formulas with LaTeX rendering
- Show quizzes with questions
- Track student progress and scores
- Support offline access with caching

## Next Steps

1. **Run Production Seed**: Execute `npm run seed:production` with your Firebase credentials
2. **Verify Data**: Check Firestore Console for all collections and documents
3. **Test Queries**: Run sample queries to ensure data structure is correct
4. **Dashboard Integration**: Update Angular dashboard to fetch and display data
5. **App Integration**: Update Flutter app to use formulas and quizzes
6. **Performance Monitoring**: Track query performance and adjust indexes if needed
7. **Backup Strategy**: Implement regular Firestore backups

## License

Part of the Formula Scholar project

## Support

For issues or suggestions, refer to the main project documentation or file an issue.

---

**Last Updated**: May 3, 2026
**Version**: 2.0 Production Edition
