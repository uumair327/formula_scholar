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

  // Using multiple batches since we have many operations.
  const batch1 = db.batch();
  const batch2 = db.batch();

  // ═══════════════════════════════════════════════════════════════
  // ──── Mathematics → Polynomials (math_001 → chap_01) ─────────
  // ═══════════════════════════════════════════════════════════════
  const mathChap1 = db.collection('subjects').doc('math_001').collection('chapters').doc('chap_01');

  const mathPolynomials = [
    { id: 'formula_01', title: 'Quadratic Formula', latex: 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}', description: 'Finds the roots of a quadratic equation ax² + bx + c = 0.', isGeneralContent: true, audiences: ['IN_cbse_10', 'IN_icse_10'] },
    { id: 'formula_02', title: 'Difference of Squares', latex: 'a^2 - b^2 = (a - b)(a + b)', description: 'A fundamental algebraic identity for factoring.', isGeneralContent: true, audiences: ['IN_cbse_8', 'IN_cbse_9', 'IN_icse_8'] },
    { id: 'formula_03', title: 'Perfect Square Trinomial', latex: '(a \\pm b)^2 = a^2 \\pm 2ab + b^2', description: 'Expansion of a binomial squared.', isGeneralContent: true, audiences: ['IN_cbse_8', 'IN_cbse_9'] },
    { id: 'formula_04', title: 'Sum of Cubes', latex: 'a^3 + b^3 = (a + b)(a^2 - ab + b^2)', description: 'Factoring the sum of two perfect cubes.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_10'] },
    { id: 'formula_05', title: 'Difference of Cubes', latex: 'a^3 - b^3 = (a - b)(a^2 + ab + b^2)', description: 'Factoring the difference of two perfect cubes.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_10'] },
    { id: 'formula_06', title: 'Cube of Binomial Sum', latex: '(a+b)^3 = a^3 + 3a^2b + 3ab^2 + b^3', description: 'Full expansion of the cube of a binomial sum.', isGeneralContent: true, audiences: ['IN_cbse_9'] },
  ];

  for (const f of mathPolynomials) {
    batch1.set(mathChap1.collection('formulas').doc(f.id), f);
  }

  // ──── Mathematics → Triangles (math_001 → chap_02) ────────────
  const mathChap2 = db.collection('subjects').doc('math_001').collection('chapters').doc('chap_02');
  const mathTriangles = [
    { id: 'formula_01', title: 'Pythagorean Theorem', latex: 'c^2 = a^2 + b^2', description: 'In a right triangle, the square of hypotenuse equals the sum of squares of other two sides.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_10'] },
    { id: 'formula_02', title: 'Area of Triangle', latex: 'A = \\frac{1}{2} \\times b \\times h', description: 'Area equals half of base times height.', isGeneralContent: true, audiences: ['IN_cbse_9'] },
    { id: 'formula_03', title: "Heron's Formula", latex: 'A = \\sqrt{s(s-a)(s-b)(s-c)}', description: 'Area of a triangle using semi-perimeter s = (a+b+c)/2.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_10'] },
    { id: 'formula_04', title: 'Sum of Angles', latex: '\\angle A + \\angle B + \\angle C = 180°', description: 'The sum of interior angles of any triangle is 180°.', isGeneralContent: true, audiences: ['IN_cbse_9'] },
  ];

  for (const f of mathTriangles) {
    batch1.set(mathChap2.collection('formulas').doc(f.id), f);
  }

  // ──── Mathematics → Quadratic Equations (math_001 → chap_04) ──
  const mathChap4 = db.collection('subjects').doc('math_001').collection('chapters').doc('chap_04');
  const mathQuad = [
    { id: 'formula_01', title: 'Standard Form', latex: 'ax^2 + bx + c = 0', description: 'The standard form of a quadratic equation.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
    { id: 'formula_02', title: 'Discriminant', latex: 'D = b^2 - 4ac', description: 'Determines the nature of roots: D > 0 (real distinct), D = 0 (equal), D < 0 (imaginary).', isGeneralContent: true, audiences: ['IN_cbse_10'] },
    { id: 'formula_03', title: 'Sum of Roots', latex: '\\alpha + \\beta = -\\frac{b}{a}', description: 'Sum of roots equals negative b over a.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
    { id: 'formula_04', title: 'Product of Roots', latex: '\\alpha \\cdot \\beta = \\frac{c}{a}', description: 'Product of roots equals c over a.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
  ];

  for (const f of mathQuad) {
    batch1.set(mathChap4.collection('formulas').doc(f.id), f);
  }

  // ──── Mathematics → Coordinate Geometry (math_001 → chap_05) ──
  const mathChap5 = db.collection('subjects').doc('math_001').collection('chapters').doc('chap_05');
  const mathCoord = [
    { id: 'formula_01', title: 'Distance Formula', latex: 'd = \\sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}', description: 'Calculates the distance between two points.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
    { id: 'formula_02', title: 'Section Formula', latex: 'P = \\left(\\frac{mx_2+nx_1}{m+n}, \\frac{my_2+ny_1}{m+n}\\right)', description: 'Point dividing a line segment in ratio m:n.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
    { id: 'formula_03', title: 'Midpoint Formula', latex: 'M = \\left(\\frac{x_1+x_2}{2}, \\frac{y_1+y_2}{2}\\right)', description: 'Midpoint of a line segment.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
  ];

  for (const f of mathCoord) {
    batch1.set(mathChap5.collection('formulas').doc(f.id), f);
  }

  // ═══════════════════════════════════════════════════════════════
  // ──── Physics → Kinematics 1D (physics_001 → chap_01) ────────
  // ═══════════════════════════════════════════════════════════════
  const physChap1 = db.collection('subjects').doc('physics_001').collection('chapters').doc('chap_01');
  const physKinematics = [
    { id: 'formula_01', title: 'First Equation of Motion', latex: 'v = u + at', description: 'Final velocity given initial velocity, acceleration, and time.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
    { id: 'formula_02', title: 'Second Equation of Motion', latex: 's = ut + \\frac{1}{2}at^2', description: 'Displacement over time under constant acceleration.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
    { id: 'formula_03', title: 'Third Equation of Motion', latex: 'v^2 = u^2 + 2as', description: 'Relates velocity to displacement without time.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
    { id: 'formula_04', title: 'Average Velocity', latex: 'v_{avg} = \\frac{u + v}{2}', description: 'Average of initial and final velocity under uniform acceleration.', isGeneralContent: true, audiences: ['IN_cbse_9'] },
  ];

  for (const f of physKinematics) {
    batch1.set(physChap1.collection('formulas').doc(f.id), f);
  }

  // ──── Physics → Laws of Motion (physics_001 → chap_02) ────────
  const physChap2 = db.collection('subjects').doc('physics_001').collection('chapters').doc('chap_02');
  const physLaws = [
    { id: 'formula_01', title: "Newton's Second Law", latex: 'F = ma', description: 'Force equals mass times acceleration.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
    { id: 'formula_02', title: 'Momentum', latex: 'p = mv', description: 'Momentum is the product of mass and velocity.', isGeneralContent: true, audiences: ['IN_cbse_9'] },
    { id: 'formula_03', title: 'Impulse', latex: 'J = F \\cdot \\Delta t = \\Delta p', description: 'Impulse equals force times time, equals change in momentum.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
    { id: 'formula_04', title: 'Conservation of Momentum', latex: 'm_1u_1 + m_2u_2 = m_1v_1 + m_2v_2', description: 'Total momentum before = total momentum after in isolated systems.', isGeneralContent: true, audiences: ['IN_cbse_9'] },
  ];

  for (const f of physLaws) {
    batch1.set(physChap2.collection('formulas').doc(f.id), f);
  }

  // ──── Physics → Gravitation (physics_001 → chap_03) ───────────
  const physChap3 = db.collection('subjects').doc('physics_001').collection('chapters').doc('chap_03');
  const physGrav = [
    { id: 'formula_01', title: 'Universal Law of Gravitation', latex: 'F = G\\frac{m_1 m_2}{r^2}', description: 'Gravitational force between two masses.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
    { id: 'formula_02', title: 'Acceleration Due to Gravity', latex: 'g = \\frac{GM}{R^2}', description: 'Gravity at surface of a planet.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
    { id: 'formula_03', title: 'Weight', latex: 'W = mg', description: 'Weight is mass times acceleration due to gravity.', isGeneralContent: true, audiences: ['IN_cbse_9'] },
  ];

  for (const f of physGrav) {
    batch2.set(physChap3.collection('formulas').doc(f.id), f);
  }

  // ──── Physics → Work, Energy & Power (physics_001 → chap_04) ──
  const physChap4 = db.collection('subjects').doc('physics_001').collection('chapters').doc('chap_04');
  const physWork = [
    { id: 'formula_01', title: 'Work Done', latex: 'W = F \\cdot d \\cos\\theta', description: 'Work equals force times displacement times cosine of angle.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
    { id: 'formula_02', title: 'Kinetic Energy', latex: 'KE = \\frac{1}{2}mv^2', description: 'Energy of a body in motion.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
    { id: 'formula_03', title: 'Potential Energy', latex: 'PE = mgh', description: 'Energy due to position in a gravitational field.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
    { id: 'formula_04', title: 'Power', latex: 'P = \\frac{W}{t}', description: 'Rate of doing work.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_11'] },
  ];

  for (const f of physWork) {
    batch2.set(physChap4.collection('formulas').doc(f.id), f);
  }


  // ═══════════════════════════════════════════════════════════════
  // ──── Chemistry → Atomic Structure (chemistry_001 → chap_01) ──────
  // ═══════════════════════════════════════════════════════════════
  const chemChap1 = db.collection('subjects').doc('chemistry_001').collection('chapters').doc('chap_01');
  const chemAtomic = [
    { id: 'formula_01', title: 'Planck–Einstein Relation', latex: 'E = h\\nu', description: 'Energy of a photon equals Planck constant times frequency.', isGeneralContent: true, audiences: ['IN_cbse_11'] },
    { id: 'formula_02', title: 'de Broglie Wavelength', latex: '\\lambda = \\frac{h}{mv}', description: 'Wavelength of a particle with mass m moving at velocity v.', isGeneralContent: true, audiences: ['IN_cbse_11'] },
    { id: 'formula_03', title: "Bohr's Radius", latex: 'r_n = 0.529 \\times n^2 \\text{ Å}', description: 'Radius of nth orbit in hydrogen atom.', isGeneralContent: true, audiences: ['IN_cbse_11'] },
  ];

  for (const f of chemAtomic) {
    batch2.set(chemChap1.collection('formulas').doc(f.id), f);
  }

  // ──── Chemistry → Chemical Reactions (chemistry_001 → chap_04) ─────
  const chemChap4 = db.collection('subjects').doc('chemistry_001').collection('chapters').doc('chap_04');
  const chemReactions = [
    { id: 'formula_01', title: 'Molar Mass', latex: 'M = \\frac{m}{n}', description: 'Molar mass equals mass divided by number of moles.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_10'] },
    { id: 'formula_02', title: "Avogadro's Number", latex: 'N_A = 6.022 \\times 10^{23}', description: 'Number of atoms/molecules in one mole of substance.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_10'] },
    { id: 'formula_03', title: 'Ideal Gas Law', latex: 'PV = nRT', description: 'Relates pressure, volume, moles, gas constant, and temperature.', isGeneralContent: true, audiences: ['IN_cbse_11'] },
  ];

  for (const f of chemReactions) {
    batch2.set(chemChap4.collection('formulas').doc(f.id), f);
  }

  // ──── Chemistry → Acids, Bases & Salts (chemistry_001 → chap_05) ──
  const chemChap5 = db.collection('subjects').doc('chemistry_001').collection('chapters').doc('chap_05');
  const chemAcids = [
    { id: 'formula_01', title: 'pH Scale', latex: 'pH = -\\log[H^+]', description: 'Negative logarithm of hydrogen ion concentration.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
    { id: 'formula_02', title: 'pOH', latex: 'pOH = -\\log[OH^-]', description: 'Negative logarithm of hydroxide ion concentration.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
    { id: 'formula_03', title: 'pH + pOH', latex: 'pH + pOH = 14', description: 'Sum of pH and pOH at 25°C always equals 14.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
  ];

  for (const f of chemAcids) {
    batch2.set(chemChap5.collection('formulas').doc(f.id), f);
  }


  // ═══════════════════════════════════════════════════════════════
  // ──── Biology → Cell Division (biology_001 → chap_01) ─────────
  // ═══════════════════════════════════════════════════════════════
  const bioChap1 = db.collection('subjects').doc('biology_001').collection('chapters').doc('chap_01');
  const bioCellDiv = [
    { id: 'formula_01', title: 'Cell Cycle Phases', latex: 'G_1 \\rightarrow S \\rightarrow G_2 \\rightarrow M', description: 'Order of cell cycle: Gap 1 → Synthesis → Gap 2 → Mitosis.', isGeneralContent: true, audiences: ['IN_cbse_9'] },
    { id: 'formula_02', title: 'Mitosis Result', latex: '2n \\rightarrow 2n', description: 'Mitosis produces two diploid daughter cells from one diploid parent.', isGeneralContent: true, audiences: ['IN_cbse_9'] },
    { id: 'formula_03', title: 'Meiosis Result', latex: '2n \\rightarrow n', description: 'Meiosis reduces chromosome number by half, producing four haploid cells.', isGeneralContent: true, audiences: ['IN_cbse_9', 'IN_cbse_10'] },
  ];

  for (const f of bioCellDiv) {
    batch2.set(bioChap1.collection('formulas').doc(f.id), f);
  }

  // ──── Biology → Tissues (biology_001 → chap_02) ───────────────────
  const bioChap2 = db.collection('subjects').doc('biology_001').collection('chapters').doc('chap_02');
  const bioTissues = [
    { id: 'formula_01', title: 'Meristematic Tissue', latex: '\\text{Apical} + \\text{Lateral} + \\text{Intercalary}', description: 'Three types of meristematic tissue responsible for plant growth.', isGeneralContent: true, audiences: ['IN_cbse_9'] },
    { id: 'formula_02', title: 'Permanent Tissue Types', latex: '\\text{Simple} + \\text{Complex}', description: 'Permanent tissues: Simple (parenchyma, collenchyma, sclerenchyma) and Complex (xylem, phloem).', isGeneralContent: true, audiences: ['IN_cbse_9'] },
  ];

  for (const f of bioTissues) {
    batch2.set(bioChap2.collection('formulas').doc(f.id), f);
  }

  // ──── Biology → Life Processes (biology_001 → chap_03) ────────────
  const bioChap3 = db.collection('subjects').doc('biology_001').collection('chapters').doc('chap_03');
  const bioLife = [
    { id: 'formula_01', title: 'Photosynthesis', latex: '6CO_2 + 6H_2O \\xrightarrow{\\text{sunlight}} C_6H_{12}O_6 + 6O_2', description: 'Plants convert carbon dioxide and water into glucose and oxygen using sunlight.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
    { id: 'formula_02', title: 'Aerobic Respiration', latex: 'C_6H_{12}O_6 + 6O_2 \\rightarrow 6CO_2 + 6H_2O + \\text{Energy}', description: 'Glucose is broken down in the presence of oxygen to release energy.', isGeneralContent: true, audiences: ['IN_cbse_10'] },
    { id: 'formula_03', title: 'ATP Energy', latex: 'ATP \\rightarrow ADP + P_i + \\text{Energy}', description: 'Adenosine triphosphate releases energy by losing a phosphate group.', isGeneralContent: true, audiences: ['IN_cbse_10', 'IN_cbse_11'] },
  ];

  for (const f of bioLife) {
    batch2.set(bioChap3.collection('formulas').doc(f.id), f);
  }


  // Commit both batches.
  await batch1.commit();
  console.log('Batch 1 committed...');
  await batch2.commit();
  console.log('Batch 2 committed...');

  console.log('Successfully seeded all formulas into subcollections! ✅');
}

seedFormulas().catch(console.error);
