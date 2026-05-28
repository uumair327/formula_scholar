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
const { buildLocalizedFields } = require('./seed_locale_helpers');

const AUDIENCE = ['msbshse_10', 'IN_msbshse_10', 'msbshse_class_10'];
const TAGS_BASE = ['maharashtra-board', '10th'];

const geometryFormulas = {
  chap_01: {
    name: 'Similarity',
    formulas: [
      {
        id: 'mh_geo_sim_001',
        title: 'Ratio of Areas of Two Triangles (General)',
        latex: '\\frac{A_1}{A_2} = \\frac{b_1 \\times h_1}{b_2 \\times h_2}',
        description: 'The ratio of the areas of two triangles is equal to the ratio of the product of their bases and corresponding heights.',
        category: 'similarity',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_sim_002',
        title: 'Ratio of Areas (Equal Heights)',
        latex: '\\frac{A_1}{A_2} = \\frac{b_1}{b_2} \\quad \\text{if } h_1 = h_2',
        description: 'Areas of two triangles with equal heights are proportional to their corresponding bases.',
        category: 'similarity',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_sim_003',
        title: 'Ratio of Areas (Equal Bases)',
        latex: '\\frac{A_1}{A_2} = \\frac{h_1}{h_2} \\quad \\text{if } b_1 = b_2',
        description: 'Areas of two triangles with equal bases are proportional to their corresponding heights.',
        category: 'similarity',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_sim_004',
        title: 'Areas Equal (Bases & Heights Equal)',
        latex: 'A_1 = A_2 \\quad \\text{if } b_1 = b_2 \\text{ and } h_1 = h_2',
        description: 'If two triangles have equal bases and equal heights, then their areas are equal.',
        category: 'similarity',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_sim_005',
        title: 'Basic Proportionality Theorem (BPT)',
        latex: '\\frac{AD}{DB} = \\frac{AE}{EC}',
        description: 'If a line is drawn parallel to one side of a triangle intersecting other sides in two distinct points, then the line divides those sides in the same ratio.',
        category: 'theorem',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_sim_006',
        title: 'Converse of BPT',
        latex: '\\frac{PA}{AQ} = \\frac{PB}{BR} \\Rightarrow \\text{line } AB \\parallel \\text{ line } QR',
        description: 'If a line divides any two sides of a triangle in the same ratio, then the line must be parallel to the third side.',
        category: 'theorem',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_sim_007',
        title: 'Property of Angle Bisector',
        latex: '\\frac{BD}{DC} = \\frac{AB}{AC}',
        description: 'The bisector of an angle of a triangle divides the side opposite to the angle in the ratio of the remaining sides.',
        category: 'property',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_sim_008',
        title: 'Property of Three Parallel Lines & Transversals',
        latex: '\\frac{AB}{BC} = \\frac{DE}{EF}',
        description: 'The ratio of intercepts made on a transversal by three parallel lines is equal to the ratio of the corresponding intercepts made on any other transversal.',
        category: 'property',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_sim_009',
        title: 'Tests of Similarity of Triangles',
        latex: '\\text{AA, SAS, SSS Tests}',
        description: 'Criteria to determine similarity: (i) AA Test (corresponding angles equal), (ii) SAS Test (two sides proportional & included angle equal), (iii) SSS Test (three corresponding sides proportional).',
        category: 'similarity',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_sim_010',
        title: 'Theorem of Areas of Similar Triangles',
        latex: '\\frac{A(\\triangle ABC)}{A(\\triangle PQR)} = \\frac{AB^2}{PQ^2} = \\frac{BC^2}{QR^2} = \\frac{AC^2}{PR^2}',
        description: 'When two triangles are similar, the ratio of areas of those triangles is equal to the ratio of the squares of their corresponding sides.',
        category: 'theorem',
        difficulty: 'intermediate'
      }
    ]
  },
  chap_02: {
    name: 'Pythagoras Theorem',
    formulas: [
      {
        id: 'mh_geo_pyth_001',
        title: 'Pythagoras Theorem',
        latex: 'AC^2 = AB^2 + BC^2',
        description: 'In a right-angled triangle, the square of the hypotenuse is equal to the sum of the squares of the remaining two sides.',
        category: 'theorem',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Pythagorean Theorem Circle',
          config: {
            expressions: [
              { latex: 'x^2 + y^2 = r^2', color: '#10B981' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: -10.0, yMax: 10.0 },
            sliders: [
              { id: 'r', label: 'Hypotenuse (r)', min: 1.0, max: 10.0, default: 5.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_geo_pyth_002',
        title: 'Pythagorean Triplet Formula',
        latex: '[(a^2 + b^2), \\; (a^2 - b^2), \\; (2ab)]',
        description: 'If a, b are natural numbers and a > b, then (a² + b², a² - b², 2ab) form a Pythagorean triplet.',
        category: 'property',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_pyth_003',
        title: '30°-60°-90° Triangle Property',
        latex: 'Side(30^\\circ) = \\frac{1}{2} \\text{Hyp}, \\quad Side(60^\\circ) = \\frac{\\sqrt{3}}{2} \\text{Hyp}',
        description: 'In a right triangle, if the acute angles are 30° and 60°, then side opposite to 30° is half the hypotenuse, and side opposite to 60° is √3/2 times the hypotenuse.',
        category: 'special-triangle',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_pyth_004',
        title: '45°-45°-90° Triangle Property',
        latex: 'Side(45^\\circ) = \\frac{1}{\\sqrt{2}} \\text{Hyp}',
        description: 'In a right triangle, if the acute angles are 45° and 45°, then each of the perpendicular sides is 1/√2 times the hypotenuse.',
        category: 'special-triangle',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_pyth_005',
        title: 'Similarity and Right Angled Triangle',
        latex: '\\triangle ADB \\sim \\triangle BDC \\sim \\triangle ABC',
        description: 'In a right-angled triangle, if altitude is drawn to the hypotenuse, then triangles on either side of the altitude are similar to the original triangle and to each other.',
        category: 'similarity',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_pyth_006',
        title: 'Theorem of Geometric Mean',
        latex: 'QS^2 = PS \\times SR',
        description: 'In a right-angled triangle, the perpendicular segment to the hypotenuse from opposite vertex is geometric mean of segments into which hypotenuse is divided.',
        category: 'theorem',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_pyth_007',
        title: 'Converse of Pythagoras Theorem',
        latex: 'AC^2 = AB^2 + BC^2 \\Rightarrow \\angle ABC = 90^\\circ',
        description: 'In a triangle, if square of one side is equal to sum of squares of remaining two sides, then the angle opposite to first side is a right angle.',
        category: 'theorem',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_pyth_008',
        title: 'Apollonius Theorem',
        latex: 'AB^2 + AC^2 = 2AD^2 + 2BD^2',
        description: 'In triangle ABC, if D is midpoint of side BC, then AB² + AC² = 2AD² + 2BD².',
        category: 'theorem',
        difficulty: 'hard'
      }
    ]
  },
  chap_03: {
    name: 'Circle',
    formulas: [
      {
        id: 'mh_geo_cir_001',
        title: 'Tangent Theorem',
        latex: 'l \\perp OA',
        description: 'A tangent at any point of a circle is perpendicular to the radius at the point of contact.',
        category: 'theorem',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Tangent to a Circle',
          config: {
            expressions: [
              { latex: 'x^2 + y^2 = r^2', color: '#3B82F6' },
              { latex: 'x = r', color: '#EF4444' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: -10.0, yMax: 10.0 },
            sliders: [
              { id: 'r', label: 'Radius (r)', min: 1.0, max: 8.0, default: 5.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_geo_cir_002',
        title: 'Converse of Tangent Theorem',
        latex: 'line \\; l \\perp seg \\; MN \\text{ at } N \\Rightarrow line \\; l \\text{ is tangent}',
        description: 'A line perpendicular to a radius at its point on the circle is a tangent to the circle.',
        category: 'theorem',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_cir_003',
        title: 'Tangent Segment Theorem',
        latex: 'DP = DQ',
        description: 'Tangent segments drawn from an external point to a circle are congruent.',
        category: 'theorem',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_cir_004',
        title: 'Theorem of Touching Circles',
        latex: 'C_1, C_2, P \\text{ are collinear}',
        description: 'If two circles touch each other, their point of contact lies on the line joining their centres.',
        category: 'theorem',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_cir_005',
        title: 'Inscribed Angle Theorem',
        latex: '\\angle BAC = \\frac{1}{2}m(\\text{arc } BDC)',
        description: 'The measure of an inscribed angle is half of the measure of the arc intercepted by it.',
        category: 'theorem',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_cir_006',
        title: 'Theorem of Cyclic Quadrilateral',
        latex: '\\angle B + \\angle D = 180^\\circ, \\quad \\angle A + \\angle C = 180^\\circ',
        description: 'Opposite angles of a cyclic quadrilateral are supplementary.',
        category: 'theorem',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_cir_007',
        title: 'Converse of Cyclic Quadrilateral',
        latex: '\\text{Opposite angles sum } = 180^\\circ \\Rightarrow \\text{Cyclic}',
        description: 'If a pair of opposite angles of a quadrilateral is supplementary, then the quadrilateral is cyclic.',
        category: 'theorem',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_cir_008',
        title: 'Theorem of Angle Between Tangent & Secant',
        latex: '\\angle BAC = \\frac{1}{2}m(\\text{arc } BDA)',
        description: 'If angle has its vertex on circle, one side is tangent and other side is secant, then its measure is half of the intercepted arc.',
        category: 'theorem',
        difficulty: 'hard'
      },
      {
        id: 'mh_geo_cir_009',
        title: 'Theorem of Internal Division of Chords',
        latex: 'AE \\times EB = CE \\times ED',
        description: 'If two chords of a circle intersect each other in the interior of the circle, the product of segments of one chord is equal to the product of segments of the other chord.',
        category: 'theorem',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_cir_010',
        title: 'Theorem of External Division of Chords',
        latex: 'PT \\times QT = RT \\times ST',
        description: 'If secants containing chords PQ and RS intersect outside the circle at point T, then PT × QT = RT × ST.',
        category: 'theorem',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_cir_011',
        title: 'Tangent Secant Segments Theorem',
        latex: 'AB \\times AC = AD^2',
        description: 'If secant through point A intersects circle at B and C, and tangent through A touches circle at D, then AB × AC = AD².',
        category: 'theorem',
        difficulty: 'hard'
      }
    ]
  },
  chap_04: {
    name: 'Geometric Constructions',
    formulas: [
      {
        id: 'mh_geo_con_001',
        title: 'Similar Triangles Construction',
        latex: '\\text{Scale factor} = \\frac{m}{n}',
        description: 'To construct a triangle similar to a given triangle bearing a given ratio: (i) when vertices are distinct, (ii) when one vertex is common.',
        category: 'construction',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_con_002',
        title: 'Construct Tangent at a Point on Circle',
        latex: 'l \\perp \\text{radius}',
        description: 'To construct a tangent at a point on the circle: (i) using the centre of the circle, (ii) without using the centre of the circle.',
        category: 'construction',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_con_003',
        title: 'Construct Tangents from External Point',
        latex: 'OT^2 = OP^2 - r^2',
        description: 'To construct tangents to a circle from a point outside the circle using the perpendicular bisector of the segment joining center to external point.',
        category: 'construction',
        difficulty: 'intermediate'
      }
    ]
  },
  chap_05: {
    name: 'Co-ordinate Geometry',
    formulas: [
      {
        id: 'mh_geo_cg_001',
        title: 'Distance of Point from Origin',
        latex: 'd(O, P) = \\sqrt{x^2 + y^2}',
        description: 'If coordinates of point P are (x,y), then its distance from the origin O(0,0) is √(x² + y²).',
        category: 'coordinate',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Distance from Origin',
          config: {
            expressions: [
              { latex: 'x^2 + y^2 = d^2', color: '#10B981' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: -10.0, yMax: 10.0 },
            sliders: [
              { id: 'd', label: 'Distance (d)', min: 1.0, max: 10.0, default: 5.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_geo_cg_002',
        title: 'Distance Formula (Two Points)',
        latex: 'd(A, B) = \\sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2}',
        description: 'Distance between two points A(x₁, y₁) and B(x₂, y₂).',
        category: 'coordinate',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_cg_003',
        title: 'Section Formula',
        latex: '\\left(\\frac{mx_2 + nx_1}{m+n}, \\; \\frac{my_2 + ny_1}{m+n}\\right)',
        description: 'Coordinates of point which divides segment joining (x₁, y₁) and (x₂, y₂) in ratio m:n internally.',
        category: 'coordinate',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_cg_004',
        title: 'Midpoint Formula',
        latex: '\\left(\\frac{x_1 + x_2}{2}, \\; \\frac{y_1 + y_2}{2}\\right)',
        description: 'Coordinates of midpoint of segment joining points (x₁, y₁) and (x₂, y₂).',
        category: 'coordinate',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_cg_005',
        title: 'Centroid Formula',
        latex: '\\left(\\frac{x_1 + x_2 + x_3}{3}, \\; \\frac{y_1 + y_2 + y_3}{3}\\right)',
        description: 'Coordinates of centroid of a triangle with vertices (x₁, y₁), (x₂, y₂), and (x₃, y₃).',
        category: 'coordinate',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_cg_006',
        title: 'Slope of a Line',
        latex: 'm = \\frac{y_2 - y_1}{x_2 - x_1}',
        description: 'Slope/gradient of line through points (x₁, y₁) and (x₂, y₂). Slope is generally denoted by letter m.',
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
      {
        id: 'mh_geo_cg_007',
        title: 'Slope of X-axis & Parallel Lines',
        latex: 'm = 0',
        description: 'The slope of the X-axis and of any line parallel to the X-axis is zero.',
        category: 'coordinate',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_cg_008',
        title: 'Slope of Y-axis & Parallel Lines',
        latex: 'm \\text{ is undefined}',
        description: 'The slope of the Y-axis and of any line parallel to the Y-axis cannot be determined (undefined).',
        category: 'coordinate',
        difficulty: 'easy'
      }
    ]
  },
  chap_06: {
    name: 'Trigonometry',
    formulas: [
      {
        id: 'mh_geo_trig_001',
        title: 'Primary Trigonometric Ratios',
        latex: '\\sin\\theta = \\frac{\\text{Opp}}{\\text{Hyp}}, \\quad \\cos\\theta = \\frac{\\text{Adj}}{\\text{Hyp}}, \\quad \\tan\\theta = \\frac{\\text{Opp}}{\\text{Adj}}',
        description: 'Fundamental trigonometric ratios representing side relations in a right-angled triangle.',
        category: 'ratio',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Trig Curve Explorer',
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
      {
        id: 'mh_geo_trig_002',
        title: 'Reciprocal Trigonometric Ratios',
        latex: '\\csc\\theta = \\frac{\\text{Hyp}}{\\text{Opp}}, \\quad \\sec\\theta = \\frac{\\text{Hyp}}{\\text{Adj}}, \\quad \\cot\\theta = \\frac{\\text{Adj}}{\\text{Opp}}',
        description: 'Reciprocal definitions of basic trigonometric ratios.',
        category: 'ratio',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_trig_003',
        title: 'Trigonometric Product Identities',
        latex: '\\sin\\theta \\cdot \\csc\\theta = 1, \\quad \\cos\\theta \\cdot \\sec\\theta = 1, \\quad \\tan\\theta \\cdot \\cot\\theta = 1',
        description: 'Relations expressing reciprocal properties through multiplication.',
        category: 'identity',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_trig_004',
        title: 'Pythagorean Trigonometric Identities',
        latex: '\\sin^2\\theta + \\cos^2\\theta = 1, \\quad 1 + \\tan^2\\theta = \\sec^2\\theta, \\quad 1 + \\cot^2\\theta = \\csc^2\\theta',
        description: 'Fundamental trigonometric identities relating squares of ratios.',
        category: 'identity',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_trig_005',
        title: 'Angle of Elevation & Depression',
        latex: '\\theta_{elevation} \\; \\text{or} \\; \\theta_{depression}',
        description: 'Angle of elevation is looking up from the horizontal. Angle of depression is looking down from the horizontal.',
        category: 'application',
        difficulty: 'easy'
      }
    ]
  },
  chap_07: {
    name: 'Mensuration',
    formulas: [
      {
        id: 'mh_geo_mens_001',
        title: 'Slant Height of Frustum',
        latex: 'l = \\sqrt{h^2 + (r_1 - r_2)^2}',
        description: 'Slant height of a frustum of a cone, where h is height, r₁ and r₂ are radii of circular faces (r₁ > r₂).',
        category: 'frustum',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_mens_002',
        title: 'Curved Surface Area of Frustum',
        latex: 'CSA = \\pi l (r_1 + r_2)',
        description: 'Curved surface area of a frustum of a cone with slant height l.',
        category: 'frustum',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_mens_003',
        title: 'Total Surface Area of Frustum',
        latex: 'TSA = \\pi l (r_1 + r_2) + \\pi r_1^2 + \\pi r_2^2',
        description: 'Total surface area of a frustum of a cone, including curved surface and both base areas.',
        category: 'frustum',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_geo_mens_004',
        title: 'Volume of Frustum of a Cone',
        latex: 'V = \\frac{1}{3}\\pi h (r_1^2 + r_2^2 + r_1 r_2)',
        description: 'Volume of a frustum of a cone with height h and face radii r₁ and r₂.',
        category: 'volume',
        difficulty: 'hard',
        widgetConfig: {
          type: 'model3d',
          title: '3D Frustum Explorer',
          config: {
            shape: 'frustum',
            sliders: [
              { id: 'a', label: 'Bottom Radius (r₁)', min: 0.5, max: 2.0, default: 1.2, step: 0.1 },
              { id: 'b', label: 'Top Radius (r₂)', min: 0.2, max: 1.5, default: 0.6, step: 0.1 },
              { id: 'c', label: 'Height (h)', min: 0.5, max: 3.0, default: 1.5, step: 0.1 }
            ]
          }
        }
      },
      {
        id: 'mh_geo_mens_005',
        title: 'Area of Sector',
        latex: 'A = \\frac{\\theta}{360} \\times \\pi r^2',
        description: 'Area of a sector of a circle with radius r and central angle θ.',
        category: 'sector',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Area of Sector (Circle)',
          config: {
            expressions: [
              { latex: 'x^2 + y^2 = r^2', color: '#3B82F6' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: -10.0, yMax: 10.0 },
            sliders: [
              { id: 'r', label: 'Radius (r)', min: 1.0, max: 10.0, default: 5.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_geo_mens_006',
        title: 'Length of an Arc',
        latex: 'l = \\frac{\\theta}{360} \\times 2\\pi r',
        description: 'Length of an arc of a circle subtending angle θ at the center.',
        category: 'sector',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_mens_007',
        title: 'Area of Sector (from Arc Length)',
        latex: 'A = \\frac{l}{2} \\times r',
        description: 'Area of a sector calculated when arc length (l) and radius (r) are known.',
        category: 'sector',
        difficulty: 'easy'
      },
      {
        id: 'mh_geo_mens_008',
        title: 'Area of Segment of Circle',
        latex: 'A = r^2 \\left[ \\frac{\\pi\\theta}{360} - \\frac{\\sin\\theta}{2} \\right]',
        description: 'Area of a segment PAQ of a circle with radius r and central angle θ.',
        category: 'segment',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Segment Area Curve',
          config: {
            expressions: [
              { latex: 'y = r^2 * (3.1415*x/360 - sin(x*3.1415/180)/2)', color: '#FF7F50' }
            ],
            viewport: { xMin: 0.0, xMax: 360.0, yMin: -20.0, yMax: 100.0 },
            sliders: [
              { id: 'r', label: 'Radius (r)', min: 1.0, max: 10.0, default: 5.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_geo_mens_009',
        title: 'Cuboid Surface Area and Volume',
        latex: 'TSA = 2(lb + bh + lh), \\quad V = l \\cdot b \\cdot h',
        description: 'Total surface area and volume of a cuboid with dimensions length (l), breadth (b) and height (h).',
        category: 'cuboid',
        difficulty: 'easy',
        widgetConfig: {
          type: 'model3d',
          title: '3D Cuboid Explorer',
          config: {
            shape: 'box',
            sliders: [
              { id: 'a', label: 'Width (l)', min: 0.5, max: 3.0, default: 1.5, step: 0.1 },
              { id: 'b', label: 'Height (h)', min: 0.5, max: 3.0, default: 1.0, step: 0.1 },
              { id: 'c', label: 'Depth (b)', min: 0.5, max: 3.0, default: 2.0, step: 0.1 }
            ]
          }
        }
      },
      {
        id: 'mh_geo_mens_010',
        title: 'Cube Surface Area and Volume',
        latex: 'TSA = 6l^2, \\quad V = l^3',
        description: 'Total surface area and volume of a cube with side length l.',
        category: 'cube',
        difficulty: 'easy',
        widgetConfig: {
          type: 'model3d',
          title: '3D Cube Explorer',
          config: {
            shape: 'box',
            sliders: [
              { id: 'a', label: 'Side (l)', min: 0.5, max: 3.0, default: 1.5, step: 0.1 }
            ]
          }
        }
      },
      {
        id: 'mh_geo_mens_011',
        title: 'Cylinder Surface Area and Volume',
        latex: 'TSA = 2\\pi r(r + h), \\quad V = \\pi r^2 h',
        description: 'Total surface area and volume of a right circular cylinder with radius r and height h.',
        category: 'cylinder',
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
      {
        id: 'mh_geo_mens_012',
        title: 'Cone Surface Area and Volume',
        latex: 'TSA = \\pi r(r + l), \\quad V = \\frac{1}{3}\\pi r^2 h',
        description: 'Total surface area and volume of a right circular cone with radius r, height h and slant height l.',
        category: 'cone',
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
      {
        id: 'mh_geo_mens_013',
        title: 'Sphere Surface Area and Volume',
        latex: 'SA = 4\\pi r^2, \\quad V = \\frac{4}{3}\\pi r^3',
        description: 'Surface area and volume of a sphere with radius r.',
        category: 'sphere',
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
        id: 'mh_geo_mens_014',
        title: 'Hemisphere Surface Area and Volume',
        latex: 'TSA = 3\\pi r^2, \\quad V = \\frac{2}{3}\\pi r^3',
        description: 'Total surface area and volume of a solid closed hemisphere with radius r.',
        category: 'hemisphere',
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
      }
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
        localized: buildLocalizedFields(f),
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
