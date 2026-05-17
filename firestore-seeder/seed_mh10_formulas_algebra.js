const path = require('path');
const admin = require('firebase-admin');

const serviceAccountPath = process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;
if (!serviceAccountPath) {
  throw new Error('Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.');
}
const serviceAccount = require(path.resolve(serviceAccountPath));
if (!admin.apps.length) {
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
}
const db = admin.firestore();

const AUDIENCE = ['IN_msbshse_10'];
const TAGS_BASE = ['maharashtra-board', '10th'];

const algebraFormulas = {
  chap_01: {
    name: 'Linear Equations in Two Variables',
    formulas: [
      { id: 'mh_alg_le_001', title: 'General Form', latex: 'ax + by + c = 0', description: 'Standard form of a linear equation in two variables where a, b are not both zero.', category: 'definition', difficulty: 'easy' },
      { id: 'mh_alg_le_002', title: 'Slope-Intercept Form', latex: 'y = mx + c', description: 'Where m is the slope and c is the y-intercept of the line.', category: 'linear', difficulty: 'easy' },
      { id: 'mh_alg_le_003', title: 'Slope Formula', latex: 'm = \\frac{y_2 - y_1}{x_2 - x_1}', description: 'Slope of a line passing through two points (x₁, y₁) and (x₂, y₂).', category: 'linear', difficulty: 'easy' },
      { id: 'mh_alg_le_004', title: 'Consistent System (Unique Solution)', latex: '\\frac{a_1}{a_2} \\neq \\frac{b_1}{b_2}', description: 'Condition for a pair of linear equations to have exactly one solution (intersecting lines).', category: 'system', difficulty: 'intermediate' },
      { id: 'mh_alg_le_005', title: 'Dependent System (Infinite Solutions)', latex: '\\frac{a_1}{a_2} = \\frac{b_1}{b_2} = \\frac{c_1}{c_2}', description: 'Condition for coincident lines — infinitely many solutions.', category: 'system', difficulty: 'intermediate' },
      { id: 'mh_alg_le_006', title: 'Inconsistent System (No Solution)', latex: '\\frac{a_1}{a_2} = \\frac{b_1}{b_2} \\neq \\frac{c_1}{c_2}', description: 'Condition for parallel lines — no solution exists.', category: 'system', difficulty: 'intermediate' },
    ]
  },
  chap_02: {
    name: 'Quadratic Equations',
    formulas: [
      { id: 'mh_alg_qe_001', title: 'Standard Form', latex: 'ax^2 + bx + c = 0,\\quad a \\neq 0', description: 'General form of a quadratic equation with real coefficients.', category: 'definition', difficulty: 'easy' },
      { id: 'mh_alg_qe_002', title: 'Quadratic Formula (Shreedharacharya)', latex: 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}', description: 'Gives the roots of any quadratic equation. Also known as Shreedharacharya\'s formula.', category: 'algebraic', difficulty: 'intermediate' },
      { id: 'mh_alg_qe_003', title: 'Discriminant', latex: '\\Delta = b^2 - 4ac', description: 'Determines the nature of roots: Δ>0 → two distinct real roots, Δ=0 → equal roots, Δ<0 → no real roots.', category: 'algebraic', difficulty: 'intermediate' },
      { id: 'mh_alg_qe_004', title: 'Sum of Roots', latex: '\\alpha + \\beta = -\\frac{b}{a}', description: 'The sum of roots of ax² + bx + c = 0.', category: 'roots', difficulty: 'intermediate' },
      { id: 'mh_alg_qe_005', title: 'Product of Roots', latex: '\\alpha \\cdot \\beta = \\frac{c}{a}', description: 'The product of roots of ax² + bx + c = 0.', category: 'roots', difficulty: 'intermediate' },
      { id: 'mh_alg_qe_006', title: 'Completing the Square', latex: 'a\\left(x + \\frac{b}{2a}\\right)^2 + c - \\frac{b^2}{4a} = 0', description: 'Method to convert a quadratic into vertex form for solving.', category: 'method', difficulty: 'hard' },
    ]
  },
  chap_03: {
    name: 'Arithmetic Progression',
    formulas: [
      { id: 'mh_alg_ap_001', title: 'General Term (nth term)', latex: 'a_n = a + (n-1)d', description: 'The nth term of an AP where a is the first term and d is the common difference.', category: 'sequence', difficulty: 'easy' },
      { id: 'mh_alg_ap_002', title: 'Sum of First n Terms', latex: 'S_n = \\frac{n}{2}[2a + (n-1)d]', description: 'Sum of first n terms of an arithmetic progression.', category: 'series', difficulty: 'intermediate' },
      { id: 'mh_alg_ap_003', title: 'Sum Using First and Last Term', latex: 'S_n = \\frac{n}{2}(a + l)', description: 'Where a is the first term and l is the last term.', category: 'series', difficulty: 'easy' },
      { id: 'mh_alg_ap_004', title: 'Common Difference', latex: 'd = a_{n} - a_{n-1}', description: 'The constant difference between consecutive terms.', category: 'sequence', difficulty: 'easy' },
      { id: 'mh_alg_ap_005', title: 'Sum of Natural Numbers', latex: '\\sum_{k=1}^{n} k = \\frac{n(n+1)}{2}', description: 'Special case: AP with a=1, d=1.', category: 'series', difficulty: 'easy' },
    ]
  },
  chap_04: {
    name: 'Financial Planning',
    formulas: [
      { id: 'mh_alg_fp_001', title: 'Simple Interest', latex: 'SI = \\frac{P \\times R \\times T}{100}', description: 'Where P = Principal, R = Rate of interest per annum, T = Time in years.', category: 'finance', difficulty: 'easy' },
      { id: 'mh_alg_fp_002', title: 'Compound Interest', latex: 'A = P\\left(1 + \\frac{R}{100}\\right)^T', description: 'Amount after T years with compound interest. CI = A − P.', category: 'finance', difficulty: 'intermediate' },
      { id: 'mh_alg_fp_003', title: 'EMI Formula', latex: 'EMI = \\frac{P \\cdot r \\cdot (1+r)^n}{(1+r)^n - 1}', description: 'Equated Monthly Installment where r = monthly rate, n = number of months.', category: 'finance', difficulty: 'hard' },
      { id: 'mh_alg_fp_004', title: 'GST Calculation', latex: '\\text{GST Amount} = \\frac{\\text{Price} \\times \\text{Rate}}{100}', description: 'Goods and Services Tax calculation on the base price.', category: 'tax', difficulty: 'easy' },
      { id: 'mh_alg_fp_005', title: 'Depreciation', latex: 'V = P\\left(1 - \\frac{R}{100}\\right)^T', description: 'Value after depreciation where R is the rate of depreciation.', category: 'finance', difficulty: 'intermediate' },
    ]
  },
  chap_05: {
    name: 'Probability',
    formulas: [
      { id: 'mh_alg_prob_001', title: 'Probability of an Event', latex: 'P(E) = \\frac{\\text{Favourable outcomes}}{\\text{Total outcomes}}', description: 'Basic probability formula. P(E) lies between 0 and 1.', category: 'probability', difficulty: 'easy' },
      { id: 'mh_alg_prob_002', title: 'Complement Rule', latex: 'P(\\bar{E}) = 1 - P(E)', description: 'Probability of event NOT occurring.', category: 'probability', difficulty: 'easy' },
      { id: 'mh_alg_prob_003', title: 'Addition Rule (Mutually Exclusive)', latex: 'P(A \\cup B) = P(A) + P(B)', description: 'For mutually exclusive events where A and B cannot occur together.', category: 'probability', difficulty: 'intermediate' },
      { id: 'mh_alg_prob_004', title: 'Sure Event', latex: 'P(S) = 1', description: 'The sample space has probability 1 (certain event).', category: 'probability', difficulty: 'easy' },
    ]
  },
  chap_06: {
    name: 'Statistics',
    formulas: [
      { id: 'mh_alg_stat_001', title: 'Mean (Direct Method)', latex: '\\bar{x} = \\frac{\\sum f_i x_i}{\\sum f_i}', description: 'Arithmetic mean for grouped data using direct method.', category: 'statistics', difficulty: 'easy' },
      { id: 'mh_alg_stat_002', title: 'Mean (Assumed Mean Method)', latex: '\\bar{x} = A + \\frac{\\sum f_i d_i}{\\sum f_i}', description: 'Where A is the assumed mean and dᵢ = xᵢ − A.', category: 'statistics', difficulty: 'intermediate' },
      { id: 'mh_alg_stat_003', title: 'Median (Grouped Data)', latex: 'Median = L + \\frac{\\frac{N}{2} - cf}{f} \\times h', description: 'L = lower boundary of median class, cf = cumulative frequency before median class, f = frequency, h = class width.', category: 'statistics', difficulty: 'intermediate' },
      { id: 'mh_alg_stat_004', title: 'Mode (Grouped Data)', latex: 'Mode = L + \\frac{f_1 - f_0}{2f_1 - f_0 - f_2} \\times h', description: 'L = lower boundary of modal class, f₁ = modal class frequency, f₀ and f₂ are adjacent frequencies.', category: 'statistics', difficulty: 'intermediate' },
      { id: 'mh_alg_stat_005', title: 'Variance', latex: '\\sigma^2 = \\frac{\\sum f_i(x_i - \\bar{x})^2}{\\sum f_i}', description: 'Measure of spread of data from the mean.', category: 'statistics', difficulty: 'hard' },
      { id: 'mh_alg_stat_006', title: 'Standard Deviation', latex: '\\sigma = \\sqrt{\\frac{\\sum f_i(x_i - \\bar{x})^2}{\\sum f_i}}', description: 'Square root of variance — measures data dispersion.', category: 'statistics', difficulty: 'hard' },
    ]
  }
};

async function seedAlgebraFormulas() {
  console.log('Seeding MH Board 10th — Algebra Formulas...\n');
  const subjectId = 'mh_algebra_10';
  let batch = db.batch();
  let ops = 0;
  let total = 0;

  for (const [chapId, chapData] of Object.entries(algebraFormulas)) {
    console.log(`  Chapter: ${chapData.name}`);
    for (const f of chapData.formulas) {
      const ref = db.collection('subjects').doc(subjectId)
        .collection('chapters').doc(chapId)
        .collection('formulas').doc(f.id);
      batch.set(ref, {
        ...f,
        isGeneralContent: false,
        audiences: AUDIENCE,
        tags: [...TAGS_BASE, ...f.category.split(',').map(t => t.trim())],
        examples: [],
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      ops++; total++;
      if (ops >= 400) { await batch.commit(); batch = db.batch(); ops = 0; }
      console.log(`    ✓ ${f.title}`);
    }
  }
  if (ops > 0) await batch.commit();
  console.log(`\nSeeded ${total} Algebra formulas ✅\n`);
}

seedAlgebraFormulas().catch(console.error);
