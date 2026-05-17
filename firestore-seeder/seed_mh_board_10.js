const path = require('path');
const admin = require('firebase-admin');

const serviceAccountPath = process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

if (!serviceAccountPath) {
  throw new Error(
    'Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.'
  );
}

const serviceAccount = require(path.resolve(serviceAccountPath));

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const db = admin.firestore();

async function seedMhBoard10() {
  console.log('Seeding Maharashtra Board 10th Standard Data...');

  const batch = db.batch();

  const masteryTools = [
    {
      id: 'practice_quiz',
      label: 'Practice Quiz',
      iconName: 'helpCircle',
      category: 'assessment',
      isEnabled: true,
      displayOrder: 2,
      routeName: 'practice',
    },
    {
      id: 'flashcards',
      label: 'Flashcards',
      iconName: 'creditCard',
      category: 'quick_reference',
      isEnabled: true,
      displayOrder: 2,
      routeName: 'flashcards',
    },
    {
      id: 'cheat_sheets',
      label: 'Cheat Sheets',
      iconName: 'fileText',
      category: 'quick_reference',
      isEnabled: true,
      displayOrder: 3,
      routeName: 'cheatSheet',
    },
    {
      id: 'visualizer_3d',
      label: 'Visualizer 3D',
      iconName: 'box',
      category: 'visual_learning',
      isEnabled: true,
      displayOrder: 4,
    },
  ];

  function addMasteryTools(subjectRef) {
    for (const tool of masteryTools) {
      batch.set(subjectRef.collection('mastery_tools').doc(tool.id), tool);
    }
  }

  const subjects = [
    {
      id: 'mh_algebra_10',
      data: {
        name: 'Algebra',
        description: 'Maharashtra Board Class 10 Algebra',
        category: 'Mathematics',
        iconName: 'calculator',
        colorValue: 0xFF3B82F6,
        badgeText: 'MH Board 10th',
        subtitle: 'Linear Equations, Quadratic Equations & More.',
        unitCount: 6,
        formulaCount: 6,
        isFeatured: true
      },
      chapters: [
        { id: 'chap_01', name: 'Linear Equations in Two Variables' },
        { id: 'chap_02', name: 'Quadratic Equations' },
        { id: 'chap_03', name: 'Arithmetic Progression' },
        { id: 'chap_04', name: 'Financial Planning' },
        { id: 'chap_05', name: 'Probability' },
        { id: 'chap_06', name: 'Statistics' }
      ]
    },
    {
      id: 'mh_geometry_10',
      data: {
        name: 'Geometry',
        description: 'Maharashtra Board Class 10 Geometry',
        category: 'Mathematics',
        iconName: 'triangle',
        colorValue: 0xFF10B981,
        badgeText: 'MH Board 10th',
        subtitle: 'Similarity, Pythagoras, Trigonometry & More.',
        unitCount: 7,
        formulaCount: 7,
        isFeatured: true
      },
      chapters: [
        { id: 'chap_01', name: 'Similarity' },
        { id: 'chap_02', name: 'Pythagoras Theorem' },
        { id: 'chap_03', name: 'Circle' },
        { id: 'chap_04', name: 'Geometric Constructions' },
        { id: 'chap_05', name: 'Co-ordinate Geometry' },
        { id: 'chap_06', name: 'Trigonometry' },
        { id: 'chap_07', name: 'Mensuration' }
      ]
    },
    {
      id: 'mh_sci1_10',
      data: {
        name: 'Sci Part 1',
        description: 'Maharashtra Board Class 10 Science Part 1',
        category: 'Science',
        iconName: 'rocket',
        colorValue: 0xFF8B5CF6,
        badgeText: 'MH Board 10th',
        subtitle: 'Physics and Chemistry concepts.',
        unitCount: 10,
        formulaCount: 10,
        isFeatured: true
      },
      chapters: [
        { id: 'chap_01', name: 'Gravitation' },
        { id: 'chap_02', name: 'Periodic Classification of Element' },
        { id: 'chap_03', name: 'Chemical reactions and equations' },
        { id: 'chap_04', name: 'Effects of electric current' },
        { id: 'chap_05', name: 'Heat' },
        { id: 'chap_06', name: 'Refraction of light' },
        { id: 'chap_07', name: 'Lenses' },
        { id: 'chap_08', name: 'Metallurgy' },
        { id: 'chap_09', name: 'Carbon compounds' },
        { id: 'chap_10', name: 'Space Missions' }
      ]
    },
    {
      id: 'mh_sci2_10',
      data: {
        name: 'Sci Part 2',
        description: 'Maharashtra Board Class 10 Science Part 2',
        category: 'Science',
        iconName: 'microscope',
        colorValue: 0xFFEC4899,
        badgeText: 'MH Board 10th',
        subtitle: 'Biology and Environmental Science concepts.',
        unitCount: 10,
        formulaCount: 10,
        isFeatured: true
      },
      chapters: [
        { id: 'chap_01', name: 'Heredity and Evolution' },
        { id: 'chap_02', name: 'Life Processes in Living Organisms Part -1' },
        { id: 'chap_03', name: 'Life Processes in Living Organisms Part - 2' },
        { id: 'chap_04', name: 'Environmental management' },
        { id: 'chap_05', name: 'Towards Green Energy' },
        { id: 'chap_06', name: 'Animal Classification' },
        { id: 'chap_07', name: 'Introduction to Microbiology' },
        { id: 'chap_08', name: 'Cell Biology and Biotechnology' },
        { id: 'chap_09', name: 'Social health' },
        { id: 'chap_10', name: 'Disaster Management' }
      ]
    }
  ];

  for (const subject of subjects) {
    const subjectRef = db.collection('subjects').doc(subject.id);
    batch.set(subjectRef, subject.data);
    addMasteryTools(subjectRef);

    let formulaCounter = 1;
    for (const chapter of subject.chapters) {
      const chapterRef = subjectRef.collection('chapters').doc(chapter.id);
      batch.set(chapterRef, {
        name: chapter.name,
        subtitle: `Important concepts for ${chapter.name}`
      });

      // Add a short note / formula for the chapter
      const formulaRef = chapterRef.collection('formulas').doc(`formula_${subject.id}_${formulaCounter}`);
      batch.set(formulaRef, {
        id: `formula_${subject.id}_${formulaCounter}`,
        title: `Short Note on ${chapter.name}`,
        latex: `\\text{Key concepts of } ${chapter.name.replace(/[^a-zA-Z0-9 ]/g, '')}`,
        description: `This is a short summary and note for ${chapter.name}. Ensure you understand the primary concepts and definitions.`,
        category: 'concept',
        difficulty: 'easy',
        isGeneralContent: false,
        audiences: ['IN_msbshse_10'],
        examples: [`Example question related to ${chapter.name}`],
        tags: ['maharashtra-board', '10th', chapter.name.toLowerCase().replace(/\\s+/g, '-')],
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      formulaCounter++;
    }
  }

  await batch.commit();
  console.log('Successfully seeded MH Board 10th Subjects, Chapters, and Notes! ✅');
}

seedMhBoard10().catch(console.error);
