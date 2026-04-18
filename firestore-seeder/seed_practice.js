/**
 * Seed Practice Questions into Firestore.
 *
 * Collection: practice_questions
 *
 * Each document stores a complete quiz question with:
 *   - boardId / gradeId for curriculum-scoped filtering
 *   - category, topic, questionText
 *   - options array [{id, text}]
 *   - correctOptionId
 *   - points
 *   - imageUrl (optional)
 */

const path = require('path');
const admin = require('firebase-admin');

const serviceAccountPath =
  process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

if (!serviceAccountPath) {
  throw new Error(
    'Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.'
  );
}

const serviceAccount = require(path.resolve(serviceAccountPath));

if (!admin.apps.length) {
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
}

const db = admin.firestore();

// ─────────────────────────── Question Bank ───────────────────────────

const questions = [
  // ──── Mathematics ────
  {
    id: 'math_q01',
    boardId: 'cbse',
    gradeId: '10',
    category: 'ALGEBRA',
    topic: 'Polynomials',
    questionText:
      'If p(x) = x² − 5x + 6, what are the zeroes of the polynomial?',
    imageUrl: '',
    options: [
      { id: 'A', text: '2 and 3' },
      { id: 'B', text: '-2 and -3' },
      { id: 'C', text: '1 and 6' },
      { id: 'D', text: '-1 and -6' },
    ],
    correctOptionId: 'A',
    points: 10,
  },
  {
    id: 'math_q02',
    boardId: 'cbse',
    gradeId: '10',
    category: 'ALGEBRA',
    topic: 'Polynomials',
    questionText:
      'Which of the following is the correct expansion of (a + b)²?',
    imageUrl: '',
    options: [
      { id: 'A', text: 'a² + b²' },
      { id: 'B', text: 'a² + 2ab + b²' },
      { id: 'C', text: 'a² − 2ab + b²' },
      { id: 'D', text: '2a² + 2b²' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
  {
    id: 'math_q03',
    boardId: 'cbse',
    gradeId: '10',
    category: 'GEOMETRY',
    topic: 'Triangles',
    questionText:
      'In a right-angled triangle, if the two legs are 3 cm and 4 cm, what is the hypotenuse?',
    imageUrl: '',
    options: [
      { id: 'A', text: '5 cm' },
      { id: 'B', text: '7 cm' },
      { id: 'C', text: '6 cm' },
      { id: 'D', text: '25 cm' },
    ],
    correctOptionId: 'A',
    points: 10,
  },
  {
    id: 'math_q04',
    boardId: 'cbse',
    gradeId: '10',
    category: 'GEOMETRY',
    topic: 'Circles',
    questionText:
      'Which of the following formulas correctly represents the area of a circle with radius r?',
    imageUrl: '',
    options: [
      { id: 'A', text: '2πr' },
      { id: 'B', text: 'πr²' },
      { id: 'C', text: 'πd' },
      { id: 'D', text: '4πr²' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
  {
    id: 'math_q05',
    boardId: 'cbse',
    gradeId: '10',
    category: 'ALGEBRA',
    topic: 'Quadratic Equations',
    questionText:
      'What is the discriminant of the equation 2x² + 3x − 5 = 0?',
    imageUrl: '',
    options: [
      { id: 'A', text: '49' },
      { id: 'B', text: '-31' },
      { id: 'C', text: '9' },
      { id: 'D', text: '41' },
    ],
    correctOptionId: 'A',
    points: 10,
  },

  // ──── Physics ────
  {
    id: 'phys_q01',
    boardId: 'cbse',
    gradeId: '10',
    category: 'MECHANICS',
    topic: 'Kinematics',
    questionText:
      'An object starts from rest and accelerates at 2 m/s². What is its velocity after 5 seconds?',
    imageUrl: '',
    options: [
      { id: 'A', text: '5 m/s' },
      { id: 'B', text: '10 m/s' },
      { id: 'C', text: '15 m/s' },
      { id: 'D', text: '20 m/s' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
  {
    id: 'phys_q02',
    boardId: 'cbse',
    gradeId: '10',
    category: 'MECHANICS',
    topic: 'Laws of Motion',
    questionText: "According to Newton's second law, F equals:",
    imageUrl: '',
    options: [
      { id: 'A', text: 'mv' },
      { id: 'B', text: 'ma' },
      { id: 'C', text: 'mg' },
      { id: 'D', text: 'mv²' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
  {
    id: 'phys_q03',
    boardId: 'cbse',
    gradeId: '10',
    category: 'MECHANICS',
    topic: 'Gravitation',
    questionText:
      'What is the acceleration due to gravity on the surface of the Earth (approximate)?',
    imageUrl: '',
    options: [
      { id: 'A', text: '8.9 m/s²' },
      { id: 'B', text: '9.8 m/s²' },
      { id: 'C', text: '10.8 m/s²' },
      { id: 'D', text: '6.7 m/s²' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
  {
    id: 'phys_q04',
    boardId: 'cbse',
    gradeId: '10',
    category: 'MECHANICS',
    topic: 'Kinematics',
    questionText: 'The SI unit of acceleration is:',
    imageUrl: '',
    options: [
      { id: 'A', text: 'm/s' },
      { id: 'B', text: 'm/s²' },
      { id: 'C', text: 'km/h' },
      { id: 'D', text: 'N' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
  {
    id: 'phys_q05',
    boardId: 'cbse',
    gradeId: '10',
    category: 'MECHANICS',
    topic: 'Work & Energy',
    questionText: 'The kinetic energy of a body of mass m moving with velocity v is given by:',
    imageUrl: '',
    options: [
      { id: 'A', text: 'mv' },
      { id: 'B', text: '½mv²' },
      { id: 'C', text: 'mv²' },
      { id: 'D', text: '2mv²' },
    ],
    correctOptionId: 'B',
    points: 10,
  },

  // ──── Chemistry ────
  {
    id: 'chem_q01',
    boardId: 'cbse',
    gradeId: '10',
    category: 'ATOMIC STRUCTURE',
    topic: 'Atoms & Molecules',
    questionText: "What is the atomic number of Carbon?",
    imageUrl: '',
    options: [
      { id: 'A', text: '4' },
      { id: 'B', text: '6' },
      { id: 'C', text: '8' },
      { id: 'D', text: '12' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
  {
    id: 'chem_q02',
    boardId: 'cbse',
    gradeId: '10',
    category: 'CHEMICAL REACTIONS',
    topic: 'Chemical Equations',
    questionText: 'In a balanced chemical equation, the number of atoms of each element on the reactant side equals:',
    imageUrl: '',
    options: [
      { id: 'A', text: 'Double the product side' },
      { id: 'B', text: 'Half the product side' },
      { id: 'C', text: 'The product side' },
      { id: 'D', text: 'Zero' },
    ],
    correctOptionId: 'C',
    points: 10,
  },
  {
    id: 'chem_q03',
    boardId: 'cbse',
    gradeId: '10',
    category: 'PERIODIC TABLE',
    topic: 'Elements',
    questionText: 'Which group of the periodic table contains noble gases?',
    imageUrl: '',
    options: [
      { id: 'A', text: 'Group 1' },
      { id: 'B', text: 'Group 7' },
      { id: 'C', text: 'Group 18' },
      { id: 'D', text: 'Group 2' },
    ],
    correctOptionId: 'C',
    points: 10,
  },

  // ──── Biology ────
  {
    id: 'bio_q01',
    boardId: 'cbse',
    gradeId: '10',
    category: 'CELL BIOLOGY',
    topic: 'Cell Division',
    questionText: 'Which organelle is known as the "powerhouse of the cell"?',
    imageUrl: '',
    options: [
      { id: 'A', text: 'Nucleus' },
      { id: 'B', text: 'Ribosome' },
      { id: 'C', text: 'Mitochondria' },
      { id: 'D', text: 'Golgi Body' },
    ],
    correctOptionId: 'C',
    points: 10,
  },
  {
    id: 'bio_q02',
    boardId: 'cbse',
    gradeId: '10',
    category: 'GENETICS',
    topic: 'Heredity',
    questionText: 'DNA stands for:',
    imageUrl: '',
    options: [
      { id: 'A', text: 'Deoxyribonucleic Acid' },
      { id: 'B', text: 'Dinitro Amino Acid' },
      { id: 'C', text: 'Deoxy Nucleic Acid' },
      { id: 'D', text: 'Dual Nucleotide Acid' },
    ],
    correctOptionId: 'A',
    points: 10,
  },

  // ── Duplicate set for 11th grade (same board, different grade) ──
  {
    id: 'math_11_q01',
    boardId: 'cbse',
    gradeId: '11',
    category: 'CALCULUS',
    topic: 'Limits & Derivatives',
    questionText: 'What is the derivative of x² with respect to x?',
    imageUrl: '',
    options: [
      { id: 'A', text: 'x' },
      { id: 'B', text: '2x' },
      { id: 'C', text: 'x²' },
      { id: 'D', text: '2' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
  {
    id: 'math_11_q02',
    boardId: 'cbse',
    gradeId: '11',
    category: 'TRIGONOMETRY',
    topic: 'Identities',
    questionText: 'sin²θ + cos²θ equals:',
    imageUrl: '',
    options: [
      { id: 'A', text: '0' },
      { id: 'B', text: '1' },
      { id: 'C', text: '2' },
      { id: 'D', text: 'sinθ' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
  {
    id: 'math_11_q03',
    boardId: 'cbse',
    gradeId: '11',
    category: 'ALGEBRA',
    topic: 'Complex Numbers',
    questionText: 'What is the value of i² (where i = √-1)?',
    imageUrl: '',
    options: [
      { id: 'A', text: '1' },
      { id: 'B', text: '-1' },
      { id: 'C', text: 'i' },
      { id: 'D', text: '0' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
  {
    id: 'phys_11_q01',
    boardId: 'cbse',
    gradeId: '11',
    category: 'MECHANICS',
    topic: 'Rotational Motion',
    questionText: 'The moment of inertia of a solid sphere about its diameter is:',
    imageUrl: '',
    options: [
      { id: 'A', text: '⅖ MR²' },
      { id: 'B', text: '⅔ MR²' },
      { id: 'C', text: 'MR²' },
      { id: 'D', text: '½ MR²' },
    ],
    correctOptionId: 'A',
    points: 10,
  },
  {
    id: 'phys_11_q02',
    boardId: 'cbse',
    gradeId: '11',
    category: 'THERMODYNAMICS',
    topic: 'Laws of Thermodynamics',
    questionText: 'The first law of thermodynamics is essentially a statement of:',
    imageUrl: '',
    options: [
      { id: 'A', text: 'Conservation of momentum' },
      { id: 'B', text: 'Conservation of energy' },
      { id: 'C', text: 'Conservation of mass' },
      { id: 'D', text: 'Entropy increase' },
    ],
    correctOptionId: 'B',
    points: 10,
  },

  // ── ICSE board questions ──
  {
    id: 'math_icse_q01',
    boardId: 'icse',
    gradeId: '10',
    category: 'ALGEBRA',
    topic: 'Quadratic Equations',
    questionText: 'The roots of the equation x² − 7x + 12 = 0 are:',
    imageUrl: '',
    options: [
      { id: 'A', text: '3 and 4' },
      { id: 'B', text: '-3 and -4' },
      { id: 'C', text: '2 and 6' },
      { id: 'D', text: '1 and 12' },
    ],
    correctOptionId: 'A',
    points: 10,
  },
  {
    id: 'phys_icse_q01',
    boardId: 'icse',
    gradeId: '10',
    category: 'OPTICS',
    topic: 'Light',
    questionText: 'The speed of light in vacuum is approximately:',
    imageUrl: '',
    options: [
      { id: 'A', text: '3 × 10⁶ m/s' },
      { id: 'B', text: '3 × 10⁸ m/s' },
      { id: 'C', text: '3 × 10¹⁰ m/s' },
      { id: 'D', text: '3 × 10⁴ m/s' },
    ],
    correctOptionId: 'B',
    points: 10,
  },

  // ── State Board (MSBSHSE) ──
  {
    id: 'math_mh_q01',
    boardId: 'msbshse',
    gradeId: '10',
    category: 'GEOMETRY',
    topic: 'Coordinate Geometry',
    questionText: 'The distance between points (0, 0) and (3, 4) is:',
    imageUrl: '',
    options: [
      { id: 'A', text: '7' },
      { id: 'B', text: '5' },
      { id: 'C', text: '25' },
      { id: 'D', text: '1' },
    ],
    correctOptionId: 'B',
    points: 10,
  },

  // ── 12th grade ──
  {
    id: 'math_12_q01',
    boardId: 'cbse',
    gradeId: '12',
    category: 'CALCULUS',
    topic: 'Integration',
    questionText: '∫ 2x dx equals:',
    imageUrl: '',
    options: [
      { id: 'A', text: 'x² + C' },
      { id: 'B', text: '2x² + C' },
      { id: 'C', text: 'x + C' },
      { id: 'D', text: '2 + C' },
    ],
    correctOptionId: 'A',
    points: 10,
  },
  {
    id: 'math_12_q02',
    boardId: 'cbse',
    gradeId: '12',
    category: 'LINEAR ALGEBRA',
    topic: 'Matrices',
    questionText: 'The determinant of a 2×2 identity matrix is:',
    imageUrl: '',
    options: [
      { id: 'A', text: '0' },
      { id: 'B', text: '1' },
      { id: 'C', text: '2' },
      { id: 'D', text: '-1' },
    ],
    correctOptionId: 'B',
    points: 10,
  },
];

async function seedPracticeQuestions() {
  console.log('Seeding Practice Questions...');

  const batch = db.batch();

  for (const q of questions) {
    const ref = db.collection('practice_questions').doc(q.id);
    batch.set(ref, q);
  }

  await batch.commit();
  console.log(
    `Successfully seeded ${questions.length} practice questions! ✅`
  );
}

seedPracticeQuestions().catch(console.error);
