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
const { buildLocalizedSubjectFields, buildLocalizedChapterFields } = require('./seed_locale_helpers');

async function seedSubjects() {
  console.log('Seeding Subjects, Chapters and Mastery Tools...');

  // Firestore batches are limited to 500 ops — use multiple if needed.
  const batch = db.batch();

  const masteryTools = [
    {
      id: 'video_lessons',
      label: 'Video Lessons',
      iconName: 'graduationCap',
      category: 'guided_learning',
      isEnabled: false,
      supportSubtitle:
        'Video Lessons are currently being prepared. Contact support if you need access to guided tutorial content.',
      displayOrder: 1,
    },
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

  function seedMasteryTools(subjectRef) {
    for (const tool of masteryTools) {
      batch.set(subjectRef.collection('mastery_tools').doc(tool.id), tool);
    }
  }

  const subjectsData = {
    math_001: {
      name: 'Mathematics',
      description: 'Polynomials & Geometrical Proofs. Detailed CBSE compliant formula sheets for algebraic identities and theorems.',
      category: 'Mathematics',
      iconName: 'calculator',
      colorValue: 0xFF3B82F6,
      badgeText: 'CBSE CURATED',
      subtitle: 'Algebra, Geometry, Trigonometry & more.',
      unitCount: 7,
      formulaCount: 14,
      isFeatured: true,
      chapters: [
        { id: 'chap_01', name: 'Polynomials & Algebra', subtitle: 'Algebraic Identities & Factoring' },
        { id: 'chap_02', name: 'Trigonometry', subtitle: 'Ratios, Identities & Equations' },
        { id: 'chap_03', name: 'Triangles', subtitle: 'Geometry & Theorems' },
        { id: 'chap_04', name: 'Quadratic Equations', subtitle: 'Roots & Discriminant' },
        { id: 'chap_05', name: 'Coordinate Geometry', subtitle: 'Distance & Section Formula' },
        { id: 'chap_06', name: 'Statistics', subtitle: 'Mean, Median & Mode' },
        { id: 'chap_07', name: 'Probability', subtitle: 'Random Experiments & Events' },
      ]
    },
    physics_001: {
      name: 'Physics',
      description: 'Mastering Motion & Laws of Forces',
      category: 'Science',
      iconName: 'rocket',
      colorValue: 0xFF059669,
      subtitle: 'Mechanics, properties of matter, and the fundamental laws of motion.',
      unitCount: 5,
      formulaCount: 11,
      isFeatured: false,
      chapters: [
        { id: 'chap_01', name: 'Motion & Kinematics', subtitle: 'Equations of Motion' },
        { id: 'chap_02', name: "Forces & Newton's Laws", subtitle: 'Dynamics & Momentum' },
        { id: 'chap_03', name: 'Gravitation', subtitle: 'Universal Law & Free Fall' },
        { id: 'chap_04', name: 'Work, Energy & Power', subtitle: 'Conservation Laws' },
        { id: 'chap_05', name: 'Sound', subtitle: 'Waves, Frequency & Resonance' },
      ]
    },
    biology_001: {
      name: 'Biology',
      description: 'Cell: The Fundamental Unit',
      category: 'Science',
      iconName: 'microscope',
      colorValue: 0xFF9333EA,
      subtitle: 'Explore cell structures, genetics, and life processes.',
      unitCount: 4,
      formulaCount: 5,
      isFeatured: false,
      chapters: [
        { id: 'chap_01', name: 'Cell Biology & Genetics', subtitle: 'Cell Division & Heredity' },
        { id: 'chap_02', name: 'Tissues', subtitle: 'Plant & Animal Tissues' },
        { id: 'chap_03', name: 'Life Processes', subtitle: 'Nutrition, Respiration & Transport' },
        { id: 'chap_04', name: 'Heredity & Evolution', subtitle: 'Genetics & Natural Selection' },
      ]
    },
    chemistry_001: {
      name: 'Chemistry',
      description: 'Structure of Atom',
      category: 'Science',
      iconName: 'flask-conical',
      colorValue: 0xFFEA580C,
      subtitle: 'Atomic models, valency, and isotopes combined.',
      unitCount: 5,
      formulaCount: 5,
      isFeatured: false,
      chapters: [
        { id: 'chap_01', name: 'Atomic Structure & Quantum', subtitle: 'Bohr Model & Photon Energy' },
        { id: 'chap_02', name: 'Chemical Bonding', subtitle: 'Ionic & Covalent Bonds' },
        { id: 'chap_03', name: 'Periodic Table', subtitle: 'Groups, Periods & Trends' },
        { id: 'chap_04', name: 'Chemical Reactions & Stoichiometry', subtitle: 'Moles & Equations' },
        { id: 'chap_05', name: 'Acids, Bases & Salts', subtitle: 'pH Scale & Neutralization' },
      ]
    }
  };

  for (const [subId, sub] of Object.entries(subjectsData)) {
    const subjectRef = db.collection('subjects').doc(subId);
    const { chapters, ...subjectDoc } = sub;
    batch.set(subjectRef, {
      ...subjectDoc,
      localized: buildLocalizedSubjectFields(subjectDoc)
    });

    for (const ch of chapters) {
      const ref = subjectRef.collection('chapters').doc(ch.id);
      batch.set(ref, {
        name: ch.name,
        subtitle: ch.subtitle,
        localized: buildLocalizedChapterFields(ch)
      });
    }

    seedMasteryTools(subjectRef);
  }


  await batch.commit();
  console.log('Successfully seeded Subjects, Chapters, and Mastery Tools! ✅');
}

seedSubjects().catch(console.error);
