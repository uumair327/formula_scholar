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

async function seedFormulas() {
  console.log('Seeding Formulas into Chapters...');
  const batch = db.batch();

  // ─── 1. Mathematics -> Polynomials (math_001 -> chap_01) ───
  const mathChap1Ref = db.collection('subjects').doc('math_001').collection('chapters').doc('chap_01');

  const formula1 = mathChap1Ref.collection('formulas').doc('formula_01');
  batch.set(formula1, {
    title: 'Quadratic Formula',
    equation: 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}',
    description: 'Finds the roots of a quadratic equation ax^2 + bx + c = 0.',
    isGeneralContent: true,
    audiences: ['IN_cbse_10', 'IN_icse_10']
  });

  const formula2 = mathChap1Ref.collection('formulas').doc('formula_02');
  batch.set(formula2, {
    title: 'Difference of Squares',
    equation: 'a^2 - b^2 = (a - b)(a + b)',
    description: 'A fundamental algebraic identity.',
    isGeneralContent: true,
    audiences: ['IN_cbse_8', 'IN_cbse_9', 'IN_icse_8']
  });

  const formula3 = mathChap1Ref.collection('formulas').doc('formula_03');
  batch.set(formula3, {
    title: 'Perfect Square Trinomial',
    equation: '(a \\pm b)^2 = a^2 \\pm 2ab + b^2',
    description: 'Expansion of a binomial squared.',
    isGeneralContent: true,
    audiences: ['IN_cbse_8', 'IN_cbse_9']
  });

  // ─── 2. Physics -> Kinematics 1D (physics_001 -> chap_01) ───
  const physicsChap1Ref = db.collection('subjects').doc('physics_001').collection('chapters').doc('chap_01');

  const pFormula1 = physicsChap1Ref.collection('formulas').doc('formula_01');
  batch.set(pFormula1, {
    title: 'First Equation of Motion',
    equation: 'v = u + at',
    description: 'Calculates the final velocity given initial velocity, acceleration, and time.',
    isGeneralContent: true,
    audiences: ['IN_cbse_9', 'IN_cbse_11', 'IN_icse_9']
  });

  const pFormula2 = physicsChap1Ref.collection('formulas').doc('formula_02');
  batch.set(pFormula2, {
    title: 'Second Equation of Motion',
    equation: 's = ut + \\frac{1}{2}at^2',
    description: 'Calculates the displacement over time under constant acceleration.',
    isGeneralContent: true,
    audiences: ['IN_cbse_9', 'IN_cbse_11', 'IN_icse_9']
  });

  const pFormula3 = physicsChap1Ref.collection('formulas').doc('formula_03');
  batch.set(pFormula3, {
    title: 'Third Equation of Motion',
    equation: 'v^2 = u^2 + 2as',
    description: 'Relates velocity, acceleration, and displacement without requiring time.',
    isGeneralContent: true,
    audiences: ['IN_cbse_9', 'IN_cbse_11', 'IN_icse_9']
  });

  // ─── 3. Chemistry -> Atomic Structure (chem_001 -> chap_01) ───
  const chemChap1Ref = db.collection('subjects').doc('chem_001').collection('chapters').doc('chap_01');

  const cFormula1 = chemChap1Ref.collection('formulas').doc('formula_01');
  batch.set(cFormula1, {
    title: 'Planck–Einstein Relation',
    equation: 'E = h\\nu',
    description: 'Relates energy of a photon to its frequency.',
    isGeneralContent: true,
    audiences: ['IN_cbse_11', 'IN_icse_11']
  });

  await batch.commit();
  console.log('Successfully seeded Formulas into subcollections! ✅');
}

seedFormulas().catch(console.error);
