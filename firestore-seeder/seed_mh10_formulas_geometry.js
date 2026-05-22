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

const AUDIENCE = ['msbshse_10', 'IN_msbshse_10', 'msbshse_class_10'];
const TAGS_BASE = ['maharashtra-board', '10th'];

const geometryFormulas = {
  chap_01: {
    name: 'Similarity',
    formulas: [
      { id: 'mh_geo_sim_001', title: 'AAA Similarity Criterion', latex: '\\triangle ABC \\sim \\triangle DEF \\text{ if } \\angle A = \\angle D,\\; \\angle B = \\angle E', description: 'If corresponding angles of two triangles are equal, the triangles are similar (AA criterion).', category: 'similarity', difficulty: 'easy' },
      { id: 'mh_geo_sim_002', title: 'BPT (Basic Proportionality Theorem)', latex: '\\frac{AD}{DB} = \\frac{AE}{EC}', description: 'If a line is drawn parallel to one side of a triangle, it divides the other two sides proportionally.', category: 'theorem', difficulty: 'intermediate' },
      { id: 'mh_geo_sim_003', title: 'Ratio of Areas of Similar Triangles', latex: '\\frac{A(\\triangle ABC)}{A(\\triangle DEF)} = \\frac{AB^2}{DE^2}', description: 'The ratio of areas of similar triangles equals the square of the ratio of corresponding sides.', category: 'area', difficulty: 'intermediate' },
      { id: 'mh_geo_sim_004', title: 'SAS Similarity', latex: '\\frac{AB}{DE} = \\frac{AC}{DF},\\; \\angle A = \\angle D \\Rightarrow \\triangle ABC \\sim \\triangle DEF', description: 'If one angle is equal and sides including that angle are proportional.', category: 'similarity', difficulty: 'intermediate' },
      { id: 'mh_geo_sim_005', title: 'SSS Similarity', latex: '\\frac{AB}{DE} = \\frac{BC}{EF} = \\frac{AC}{DF} \\Rightarrow \\triangle ABC \\sim \\triangle DEF', description: 'If all three pairs of corresponding sides are proportional.', category: 'similarity', difficulty: 'intermediate' },
    ]
  },
  chap_02: {
    name: 'Pythagoras Theorem',
    formulas: [
      { id: 'mh_geo_pyth_001', title: 'Pythagoras Theorem', latex: 'c^2 = a^2 + b^2', description: 'In a right-angled triangle, the square of the hypotenuse equals the sum of squares of the other two sides.', category: 'theorem', difficulty: 'easy' },
      { id: 'mh_geo_pyth_002', title: 'Converse of Pythagoras Theorem', latex: 'a^2 + b^2 = c^2 \\Rightarrow \\angle C = 90°', description: 'If the sum of squares of two sides equals the square of the third, the triangle is right-angled.', category: 'theorem', difficulty: 'easy' },
      { id: 'mh_geo_pyth_003', title: 'Geometric Mean in Right Triangle', latex: 'BD^2 = AD \\cdot DC', description: 'The altitude from the right angle to the hypotenuse creates a geometric mean relationship.', category: 'theorem', difficulty: 'intermediate' },
      { id: 'mh_geo_pyth_004', title: '30-60-90 Triangle Sides', latex: '1 : \\sqrt{3} : 2', description: 'Ratio of sides in a 30-60-90 triangle (opposite to respective angles).', category: 'special', difficulty: 'easy' },
      { id: 'mh_geo_pyth_005', title: '45-45-90 Triangle Sides', latex: '1 : 1 : \\sqrt{2}', description: 'Ratio of sides in an isosceles right triangle.', category: 'special', difficulty: 'easy' },
    ]
  },
  chap_03: {
    name: 'Circle',
    formulas: [
      { id: 'mh_geo_cir_001', title: 'Tangent-Radius Property', latex: 'OT \\perp AT', description: 'A tangent to a circle is perpendicular to the radius at the point of tangency.', category: 'tangent', difficulty: 'easy' },
      { id: 'mh_geo_cir_002', title: 'Tangent Lengths from External Point', latex: 'PA = PB', description: 'Tangent segments from an external point to a circle are equal in length.', category: 'tangent', difficulty: 'easy' },
      { id: 'mh_geo_cir_003', title: 'Inscribed Angle Theorem', latex: '\\angle AOB = 2 \\angle ACB', description: 'Central angle is double the inscribed angle subtended by the same arc.', category: 'angle', difficulty: 'intermediate' },
      { id: 'mh_geo_cir_004', title: 'Angle in a Semicircle', latex: '\\angle ACB = 90°', description: 'An angle inscribed in a semicircle is always a right angle.', category: 'angle', difficulty: 'easy' },
      { id: 'mh_geo_cir_005', title: 'Cyclic Quadrilateral Property', latex: '\\angle A + \\angle C = 180°', description: 'Opposite angles of a cyclic quadrilateral are supplementary.', category: 'cyclic', difficulty: 'intermediate' },
      { id: 'mh_geo_cir_006', title: 'Secant-Tangent Relation', latex: 'PA^2 = PB \\cdot PC', description: 'If PA is a tangent and PBC is a secant from external point P.', category: 'tangent', difficulty: 'hard' },
    ]
  },
  chap_04: {
    name: 'Geometric Constructions',
    formulas: [
      { id: 'mh_geo_con_001', title: 'Division of a Segment', latex: '\\frac{AP}{PB} = \\frac{m}{n}', description: 'To divide a line segment AB in the ratio m:n, construct using parallel line method.', category: 'construction', difficulty: 'easy' },
      { id: 'mh_geo_con_002', title: 'Similar Triangle Construction', latex: '\\text{Scale factor} = \\frac{m}{n}', description: 'Construct a triangle similar to a given triangle with sides in ratio m/n.', category: 'construction', difficulty: 'intermediate' },
      { id: 'mh_geo_con_003', title: 'Tangent from External Point', latex: 'OT^2 = OP^2 - r^2', description: 'Length of tangent from external point P to circle with center O and radius r.', category: 'construction', difficulty: 'intermediate' },
    ]
  },
  chap_05: {
    name: 'Co-ordinate Geometry',
    formulas: [
      { id: 'mh_geo_cg_001', title: 'Distance Formula', latex: 'd = \\sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2}', description: 'Distance between two points (x₁,y₁) and (x₂,y₂).', category: 'coordinate', difficulty: 'easy' },
      { id: 'mh_geo_cg_002', title: 'Section Formula (Internal)', latex: 'P = \\left(\\frac{mx_2 + nx_1}{m+n},\\; \\frac{my_2 + ny_1}{m+n}\\right)', description: 'Point dividing segment internally in ratio m:n.', category: 'coordinate', difficulty: 'intermediate' },
      { id: 'mh_geo_cg_003', title: 'Midpoint Formula', latex: 'M = \\left(\\frac{x_1+x_2}{2},\\; \\frac{y_1+y_2}{2}\\right)', description: 'Midpoint of a line segment joining two points.', category: 'coordinate', difficulty: 'easy' },
      {
        id: 'mh_geo_cg_004',
        title: 'Slope of a Line',
        latex: 'm = \\frac{y_2 - y_1}{x_2 - x_1}',
        description: 'Slope/gradient of a line through two given points.',
        category: 'linear',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Slope Explorer',
          config: {
            expressions: [
              { latex: 'y = m*(x - x1) + y1', color: '#9B59B6' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: -10.0, yMax: 10.0 },
            sliders: [
              { id: 'm', label: 'Slope (m)', min: -5.0, max: 5.0, default: 1.0, step: 0.1 },
              { id: 'x1', label: 'Point x₁', min: -5.0, max: 5.0, default: 0.0, step: 0.5 },
              { id: 'y1', label: 'Point y₁', min: -5.0, max: 5.0, default: 0.0, step: 0.5 }
            ]
          }
        }
      },
      { id: 'mh_geo_cg_005', title: 'Area of Triangle (Coordinates)', latex: 'A = \\frac{1}{2}|x_1(y_2-y_3) + x_2(y_3-y_1) + x_3(y_1-y_2)|', description: 'Area of triangle with vertices at three coordinate points.', category: 'area', difficulty: 'intermediate' },
      { id: 'mh_geo_cg_006', title: 'Collinearity Condition', latex: 'x_1(y_2-y_3) + x_2(y_3-y_1) + x_3(y_1-y_2) = 0', description: 'Three points are collinear if the area of the triangle they form is zero.', category: 'coordinate', difficulty: 'intermediate' },
    ]
  },
  chap_06: {
    name: 'Trigonometry',
    formulas: [
      {
        id: 'mh_geo_trig_001',
        title: 'Sine Ratio',
        latex: '\\sin\\theta = \\frac{\\text{Opposite}}{\\text{Hypotenuse}}',
        description: 'Ratio of opposite side to hypotenuse in a right triangle.',
        category: 'ratio',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Sine & Cosine Curves',
          config: {
            expressions: [
              { latex: 'y = A*sin(x)', color: '#3B82F6' },
              { latex: 'y = A*cos(x)', color: '#EF4444' }
            ],
            viewport: { xMin: -6.28, xMax: 6.28, yMin: -3.0, yMax: 3.0 },
            sliders: [
              { id: 'A', label: 'Amplitude', min: 0.5, max: 3.0, default: 1.0, step: 0.1 }
            ]
          }
        }
      },
      { id: 'mh_geo_trig_002', title: 'Cosine Ratio', latex: '\\cos\\theta = \\frac{\\text{Adjacent}}{\\text{Hypotenuse}}', description: 'Ratio of adjacent side to hypotenuse.', category: 'ratio', difficulty: 'easy' },
      { id: 'mh_geo_trig_003', title: 'Tangent Ratio', latex: '\\tan\\theta = \\frac{\\sin\\theta}{\\cos\\theta} = \\frac{\\text{Opposite}}{\\text{Adjacent}}', description: 'Ratio of opposite to adjacent side.', category: 'ratio', difficulty: 'easy' },
      { id: 'mh_geo_trig_004', title: 'Pythagorean Identity', latex: '\\sin^2\\theta + \\cos^2\\theta = 1', description: 'Fundamental trigonometric identity valid for all angles.', category: 'identity', difficulty: 'easy' },
      { id: 'mh_geo_trig_005', title: 'sec²θ Identity', latex: '1 + \\tan^2\\theta = \\sec^2\\theta', description: 'Derived from the Pythagorean identity by dividing by cos²θ.', category: 'identity', difficulty: 'intermediate' },
      { id: 'mh_geo_trig_006', title: 'cosec²θ Identity', latex: '1 + \\cot^2\\theta = \\csc^2\\theta', description: 'Derived from the Pythagorean identity by dividing by sin²θ.', category: 'identity', difficulty: 'intermediate' },
    ]
  },
  chap_07: {
    name: 'Mensuration',
    formulas: [
      { id: 'mh_geo_mens_001', title: 'Curved Surface Area of Cylinder', latex: 'CSA = 2\\pi r h', description: 'Lateral surface area of a right circular cylinder.', category: 'surface-area', difficulty: 'easy' },
      { id: 'mh_geo_mens_002', title: 'Total Surface Area of Cylinder', latex: 'TSA = 2\\pi r(r + h)', description: 'Total surface including both circular bases.', category: 'surface-area', difficulty: 'easy' },
      {
        id: 'mh_geo_mens_003',
        title: 'Volume of Cylinder',
        latex: 'V = \\pi r^2 h',
        description: 'Volume of a right circular cylinder.',
        category: 'volume',
        difficulty: 'easy',
        widgetConfig: {
          type: 'model3d',
          title: '3D Cylinder Explorer',
          config: {
            shape: 'cylinder',
            sliders: [
              { id: 'a', label: 'Radius (r)', min: 0.5, max: 2.0, default: 1.0, step: 0.1 },
              { id: 'b', label: 'Height (h)', min: 0.5, max: 3.0, default: 1.5, step: 0.1 }
            ]
          }
        }
      },
      { id: 'mh_geo_mens_004', title: 'Slant Height of Cone', latex: 'l = \\sqrt{r^2 + h^2}', description: 'Slant height from Pythagoras theorem.', category: 'cone', difficulty: 'easy' },
      {
        id: 'mh_geo_mens_005',
        title: 'Volume of Cone',
        latex: 'V = \\frac{1}{3}\\pi r^2 h',
        description: 'Volume of a right circular cone.',
        category: 'volume',
        difficulty: 'easy',
        widgetConfig: {
          type: 'model3d',
          title: '3D Cone Explorer',
          config: {
            shape: 'cone',
            sliders: [
              { id: 'a', label: 'Radius (r)', min: 0.5, max: 2.0, default: 1.0, step: 0.1 },
              { id: 'b', label: 'Height (h)', min: 0.5, max: 3.0, default: 1.5, step: 0.1 }
            ]
          }
        }
      },
      { id: 'mh_geo_mens_006', title: 'Surface Area of Sphere', latex: 'SA = 4\\pi r^2', description: 'Total surface area of a sphere.', category: 'surface-area', difficulty: 'easy' },
      {
        id: 'mh_geo_mens_007',
        title: 'Volume of Sphere',
        latex: 'V = \\frac{4}{3}\\pi r^3',
        description: 'Volume of a sphere with radius r.',
        category: 'volume',
        difficulty: 'easy',
        widgetConfig: {
          type: 'model3d',
          title: '3D Sphere Explorer',
          config: {
            shape: 'sphere',
            sliders: [
              { id: 'a', label: 'Radius (r)', min: 0.5, max: 2.5, default: 1.0, step: 0.1 }
            ]
          }
        }
      },
      {
        id: 'mh_geo_mens_008',
        title: 'Volume of Hemisphere',
        latex: 'V = \\frac{2}{3}\\pi r^3',
        description: 'Half the volume of a sphere.',
        category: 'volume',
        difficulty: 'easy',
        widgetConfig: {
          type: 'model3d',
          title: '3D Hemisphere Explorer',
          config: {
            shape: 'sphere',
            sliders: [
              { id: 'a', label: 'Radius (r)', min: 0.5, max: 2.5, default: 1.0, step: 0.1 }
            ]
          }
        }
      },
    ]
  }
};

async function seedGeometryFormulas() {
  console.log('Seeding MH Board 10th — Geometry Formulas...\n');
  const subjectId = 'mh_geometry_10';
  let batch = db.batch();
  let ops = 0;
  let total = 0;

  for (const [chapId, chapData] of Object.entries(geometryFormulas)) {
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
  console.log(`\nSeeded ${total} Geometry formulas ✅\n`);
}

seedGeometryFormulas().catch(console.error);
