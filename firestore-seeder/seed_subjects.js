const path = require('path');
const admin = require('firebase-admin');

const serviceAccountPath = process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

if (!serviceAccountPath) {
  throw new Error(
    'Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.'
  );
}

const serviceAccount = require(path.resolve(serviceAccountPath));

// Check if already initialized to prevent errors in testing
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const db = admin.firestore();

async function seedSubjects() {
  console.log('Seeding Subjects and Chapters...');

  const batch = db.batch();

  // ----- 1. Mathematics -----
  const mathRef = db.collection('subjects').doc('math_001');
  batch.set(mathRef, {
    name: 'Mathematics',
    description: 'Polynomials & Geometrical Proofs. Detailed CBSE compliant formula sheets for algebraic identities and theorems.',
    category: 'Mathematics',
    iconName: 'calculator',
    colorValue: 0xFF3B82F6,      // blue-500
    badgeText: 'CBSE 9 CURRATED',
    subtitle: 'Detailed CBSE compliant formula sheets for algebraic identities...',
    unitCount: 12,
    formulaCount: 144,
    masteryPercentage: 12.0,
    isFeatured: true
  });

  const mathChap1 = mathRef.collection('chapters').doc('chap_01');
  batch.set(mathChap1, {
    name: 'Polynomials',
    subtitle: 'Algebraic Equations',
    completedFormulas: 8,
    totalFormulas: 12,
    progressPercent: 65,
    status: 'inProgress'
  });

  const mathChap2 = mathRef.collection('chapters').doc('chap_02');
  batch.set(mathChap2, {
    name: 'Triangles',
    subtitle: 'Geometry & Theorems',
    completedFormulas: 2,
    totalFormulas: 20,
    progressPercent: 10,
    status: 'notStarted'
  });

  const mathChap3 = mathRef.collection('chapters').doc('chap_03');
  batch.set(mathChap3, {
    name: 'Circles',
    subtitle: 'Theorems & Proofs',
    completedFormulas: 0,
    totalFormulas: 15,
    progressPercent: 0,
    status: 'locked'
  });


  // ----- 2. Physics -----
  const physicsRef = db.collection('subjects').doc('physics_001');
  batch.set(physicsRef, {
    name: 'Physics',
    description: 'Mastering Motion & Laws of Forces',
    category: 'Science',
    iconName: 'rocket',
    colorValue: 0xFF059669,      // green-600
    badgeText: 'NEW ADDITION',
    subtitle: 'Mechanics, properties of matter, and the fundamental laws of motion.',
    unitCount: 8,
    formulaCount: 96,
    masteryPercentage: 45.0,
    isFeatured: false
  });

  const physicsChap1 = physicsRef.collection('chapters').doc('chap_01');
  batch.set(physicsChap1, {
    name: 'Kinematics 1D',
    subtitle: 'Motion in a Straight Line',
    completedFormulas: 15,
    totalFormulas: 15,
    progressPercent: 100,
    status: 'inProgress' // Used visually in featured
  });


  // ----- 3. Biology -----
  const biologyRef = db.collection('subjects').doc('bio_001');
  batch.set(biologyRef, {
    name: 'Biology',
    description: 'Cell: The Fundamental Unit',
    category: 'Science',
    iconName: 'microscope',
    colorValue: 0xFF9333EA,      // purple-600
    badgeText: 'RECOMMENDED',
    subtitle: 'Recommended for Boards • Explore cell structures and functions.',
    unitCount: 5,
    formulaCount: 42,
    masteryPercentage: 80.0,
    isFeatured: false
  });

  const bioChap1 = biologyRef.collection('chapters').doc('chap_01');
  batch.set(bioChap1, {
    name: 'Cell Division',
    subtitle: 'Mitosis & Meiosis',
    completedFormulas: 3,
    totalFormulas: 5,
    progressPercent: 60,
    status: 'inProgress'
  });


  // ----- 4. Chemistry -----
  const chemRef = db.collection('subjects').doc('chem_001');
  batch.set(chemRef, {
    name: 'Chemistry',
    description: 'Structure of Atom',
    category: 'Science',
    iconName: 'flask-conical',
    colorValue: 0xFFEA580C,      // orange-600
    subtitle: 'Atomic models, valency, and isotopes combined.',
    unitCount: 14,
    formulaCount: 200,
    masteryPercentage: 0.0,
    isFeatured: false
  });

  const chemChap1 = chemRef.collection('chapters').doc('chap_01');
  batch.set(chemChap1, {
    name: 'Atomic Structure',
    subtitle: 'Bohr Model & Quantum',
    completedFormulas: 0,
    totalFormulas: 20,
    progressPercent: 0,
    status: 'locked'
  });

  await batch.commit();
  console.log('Successfully seeded Subjects and Chapters! ✅');
}

seedSubjects().catch(console.error);
