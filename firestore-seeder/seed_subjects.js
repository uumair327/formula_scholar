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
      id: 'cheat_sheets',
      label: 'Cheat Sheets',
      iconName: 'fileText',
      category: 'quick_reference',
      isEnabled: false,
      supportSubtitle:
        'Cheat Sheets provide quick formula reference guides. Contact support to request this feature for your curriculum.',
      displayOrder: 3,
    },
    {
      id: 'visualizer_3d',
      label: 'Visualizer 3D',
      iconName: 'box',
      category: 'visual_learning',
      isEnabled: false,
      supportSubtitle:
        '3D Visualizer helps understand geometric concepts. Contact support to request 3D visualization tools.',
      displayOrder: 4,
    },
  ];

  function seedMasteryTools(subjectRef) {
    for (const tool of masteryTools) {
      batch.set(subjectRef.collection('mastery_tools').doc(tool.id), tool);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ──── 1. Mathematics ──────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════
  const mathRef = db.collection('subjects').doc('math_001');
  batch.set(mathRef, {
    name: 'Mathematics',
    description: 'Polynomials & Geometrical Proofs. Detailed CBSE compliant formula sheets for algebraic identities and theorems.',
    category: 'Mathematics',
    iconName: 'calculator',
    colorValue: 0xFF3B82F6,
    badgeText: 'CBSE 9 CURATED',
    subtitle: 'Detailed CBSE compliant formula sheets for algebraic identities...',
    unitCount: 12,
    formulaCount: 144,
    masteryPercentage: 12.0,
    isFeatured: true
  });

  // Chapters
  const mathChapters = [
    { id: 'chap_01', name: 'Polynomials', subtitle: 'Algebraic Equations', completed: 8, total: 12, progress: 65, status: 'inProgress' },
    { id: 'chap_02', name: 'Triangles', subtitle: 'Geometry & Theorems', completed: 2, total: 20, progress: 10, status: 'notStarted' },
    { id: 'chap_03', name: 'Circles', subtitle: 'Theorems & Proofs', completed: 0, total: 15, progress: 0, status: 'locked' },
    { id: 'chap_04', name: 'Quadratic Equations', subtitle: 'Roots & Discriminant', completed: 0, total: 10, progress: 0, status: 'notStarted' },
    { id: 'chap_05', name: 'Coordinate Geometry', subtitle: 'Distance & Section Formula', completed: 0, total: 8, progress: 0, status: 'locked' },
    { id: 'chap_06', name: 'Statistics', subtitle: 'Mean, Median & Mode', completed: 0, total: 6, progress: 0, status: 'locked' },
    { id: 'chap_07', name: 'Probability', subtitle: 'Random Experiments & Events', completed: 0, total: 5, progress: 0, status: 'locked' },
  ];

  for (const ch of mathChapters) {
    const ref = mathRef.collection('chapters').doc(ch.id);
    batch.set(ref, {
      name: ch.name,
      subtitle: ch.subtitle,
      completedFormulas: ch.completed,
      totalFormulas: ch.total,
      progressPercent: ch.progress,
      status: ch.status,
    });
  }

  seedMasteryTools(mathRef);


  // ═══════════════════════════════════════════════════════════════
  // ──── 2. Physics ──────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════
  const physicsRef = db.collection('subjects').doc('physics_001');
  batch.set(physicsRef, {
    name: 'Physics',
    description: 'Mastering Motion & Laws of Forces',
    category: 'Science',
    iconName: 'rocket',
    colorValue: 0xFF059669,
    badgeText: 'NEW ADDITION',
    subtitle: 'Mechanics, properties of matter, and the fundamental laws of motion.',
    unitCount: 8,
    formulaCount: 96,
    masteryPercentage: 45.0,
    isFeatured: false
  });

  const physicsChapters = [
    { id: 'chap_01', name: 'Kinematics 1D', subtitle: 'Motion in a Straight Line', completed: 15, total: 15, progress: 100, status: 'inProgress' },
    { id: 'chap_02', name: 'Laws of Motion', subtitle: "Newton's Three Laws", completed: 5, total: 12, progress: 42, status: 'inProgress' },
    { id: 'chap_03', name: 'Gravitation', subtitle: 'Universal Law & Free Fall', completed: 0, total: 10, progress: 0, status: 'notStarted' },
    { id: 'chap_04', name: 'Work, Energy & Power', subtitle: 'Conservation Laws', completed: 0, total: 14, progress: 0, status: 'locked' },
    { id: 'chap_05', name: 'Sound', subtitle: 'Waves, Frequency & Resonance', completed: 0, total: 8, progress: 0, status: 'locked' },
  ];

  for (const ch of physicsChapters) {
    const ref = physicsRef.collection('chapters').doc(ch.id);
    batch.set(ref, {
      name: ch.name,
      subtitle: ch.subtitle,
      completedFormulas: ch.completed,
      totalFormulas: ch.total,
      progressPercent: ch.progress,
      status: ch.status,
    });
  }

  seedMasteryTools(physicsRef);


  // ═══════════════════════════════════════════════════════════════
  // ──── 3. Biology ──────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════
  const biologyRef = db.collection('subjects').doc('bio_001');
  batch.set(biologyRef, {
    name: 'Biology',
    description: 'Cell: The Fundamental Unit',
    category: 'Science',
    iconName: 'microscope',
    colorValue: 0xFF9333EA,
    badgeText: 'RECOMMENDED',
    subtitle: 'Recommended for Boards • Explore cell structures and functions.',
    unitCount: 5,
    formulaCount: 42,
    masteryPercentage: 80.0,
    isFeatured: false
  });

  const bioChapters = [
    { id: 'chap_01', name: 'Cell Division', subtitle: 'Mitosis & Meiosis', completed: 3, total: 5, progress: 60, status: 'inProgress' },
    { id: 'chap_02', name: 'Tissues', subtitle: 'Plant & Animal Tissues', completed: 0, total: 8, progress: 0, status: 'notStarted' },
    { id: 'chap_03', name: 'Life Processes', subtitle: 'Nutrition, Respiration & Transport', completed: 0, total: 12, progress: 0, status: 'notStarted' },
    { id: 'chap_04', name: 'Heredity & Evolution', subtitle: 'Genetics & Natural Selection', completed: 0, total: 10, progress: 0, status: 'locked' },
  ];

  for (const ch of bioChapters) {
    const ref = biologyRef.collection('chapters').doc(ch.id);
    batch.set(ref, {
      name: ch.name,
      subtitle: ch.subtitle,
      completedFormulas: ch.completed,
      totalFormulas: ch.total,
      progressPercent: ch.progress,
      status: ch.status,
    });
  }

  seedMasteryTools(biologyRef);


  // ═══════════════════════════════════════════════════════════════
  // ──── 4. Chemistry ────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════
  const chemRef = db.collection('subjects').doc('chem_001');
  batch.set(chemRef, {
    name: 'Chemistry',
    description: 'Structure of Atom',
    category: 'Science',
    iconName: 'flask-conical',
    colorValue: 0xFFEA580C,
    subtitle: 'Atomic models, valency, and isotopes combined.',
    unitCount: 14,
    formulaCount: 200,
    masteryPercentage: 0.0,
    isFeatured: false
  });

  const chemChapters = [
    { id: 'chap_01', name: 'Atomic Structure', subtitle: 'Bohr Model & Quantum', completed: 0, total: 20, progress: 0, status: 'notStarted' },
    { id: 'chap_02', name: 'Chemical Bonding', subtitle: 'Ionic & Covalent Bonds', completed: 0, total: 15, progress: 0, status: 'locked' },
    { id: 'chap_03', name: 'Periodic Table', subtitle: 'Groups, Periods & Trends', completed: 0, total: 12, progress: 0, status: 'locked' },
    { id: 'chap_04', name: 'Chemical Reactions', subtitle: 'Types & Balancing Equations', completed: 0, total: 18, progress: 0, status: 'locked' },
    { id: 'chap_05', name: 'Acids, Bases & Salts', subtitle: 'pH Scale & Neutralization', completed: 0, total: 10, progress: 0, status: 'locked' },
  ];

  for (const ch of chemChapters) {
    const ref = chemRef.collection('chapters').doc(ch.id);
    batch.set(ref, {
      name: ch.name,
      subtitle: ch.subtitle,
      completedFormulas: ch.completed,
      totalFormulas: ch.total,
      progressPercent: ch.progress,
      status: ch.status,
    });
  }

  seedMasteryTools(chemRef);


  await batch.commit();
  console.log('Successfully seeded Subjects, Chapters, and Mastery Tools! ✅');
}

seedSubjects().catch(console.error);
