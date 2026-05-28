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

const algebraFormulas = {
  chap_01: {
    name: 'Linear Equations in Two Variables',
    formulas: [
      {
        id: 'mh_alg_le_001',
        title: 'General Form',
        latex: 'ax + by + c = 0',
        description: 'Standard form of a linear equation in two variables where a, b, c are real numbers and a, b are not equal to zero at the same time. If c = 0, the equation reduces to ax + by = 0.',
        category: 'definition',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Linear Equation Grapher',
          config: {
            expressions: [
              { latex: 'y = (-a*x - c)/b', color: '#3B82F6' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: -10.0, yMax: 10.0 },
            sliders: [
              { id: 'a', label: 'Coefficient a', min: -5.0, max: 5.0, default: 2.0, step: 0.5 },
              { id: 'b', label: 'Coefficient b', min: -5.0, max: 5.0, default: 1.0, step: 0.5 },
              { id: 'c', label: 'Constant c', min: -10.0, max: 10.0, default: -2.0, step: 1.0 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_le_002',
        title: 'Cramer\'s Rule (Determinant Method)',
        latex: 'x = \\frac{D_x}{D}, \\quad y = \\frac{D_y}{D}',
        description: 'Method to solve simultaneous equations a₁x + b₁y = c₁ and a₂x + b₂y = c₂. D = a₁b₂ - b₁a₂, D_x = c₁b₂ - b₁c₂, D_y = a₁c₂ - c₁a₂.',
        category: 'system',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Cramer\'s Rule Line Intersection',
          config: {
            expressions: [
              { latex: 'y = (c1 - a1*x)/b1', color: '#3B82F6' },
              { latex: 'y = (c2 - a2*x)/b2', color: '#EF4444' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: -10.0, yMax: 10.0 },
            sliders: [
              { id: 'a1', label: 'Line 1: a1', min: -5.0, max: 5.0, default: 2.0, step: 0.5 },
              { id: 'b1', label: 'Line 1: b1', min: -5.0, max: 5.0, default: 3.0, step: 0.5 },
              { id: 'c1', label: 'Line 1: c1', min: -15.0, max: 15.0, default: 6.0, step: 0.5 },
              { id: 'a2', label: 'Line 2: a2', min: -5.0, max: 5.0, default: 1.0, step: 0.5 },
              { id: 'b2', label: 'Line 2: b2', min: -5.0, max: 5.0, default: -1.0, step: 0.5 },
              { id: 'c2', label: 'Line 2: c2', min: -15.0, max: 15.0, default: 3.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_le_003',
        title: 'Consistency of Systems',
        latex: '\\frac{a_1}{a_2} \\neq \\frac{b_1}{b_2}',
        description: 'Nature of solutions: (1) a₁/a₂ ≠ b₁/b₂: Consistent with a unique solution (intersecting lines). (2) a₁/a₂ = b₁/b₂ ≠ c₁/c₂: Inconsistent with no solution (parallel lines). (3) a₁/a₂ = b₁/b₂ = c₁/c₂: Consistent with infinitely many solutions (coincident lines).',
        category: 'system',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'System Consistency',
          config: {
            expressions: [
              { latex: 'y = (c1 - a1*x)/b1', color: '#3B82F6' },
              { latex: 'y = (c2 - a2*x)/b2', color: '#EF4444' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: -10.0, yMax: 10.0 },
            sliders: [
              { id: 'a1', label: 'a1', min: -5.0, max: 5.0, default: 2.0, step: 0.5 },
              { id: 'b1', label: 'b1', min: -5.0, max: 5.0, default: -1.0, step: 0.5 },
              { id: 'c1', label: 'c1', min: -10.0, max: 10.0, default: 4.0, step: 0.5 },
              { id: 'a2', label: 'a2', min: -5.0, max: 5.0, default: 4.0, step: 0.5 },
              { id: 'b2', label: 'b2', min: -5.0, max: 5.0, default: -2.0, step: 0.5 },
              { id: 'c2', label: 'c2', min: -10.0, max: 10.0, default: 8.0, step: 0.5 }
            ]
          }
        }
      }
    ]
  },
  chap_02: {
    name: 'Quadratic Equations',
    formulas: [
      {
        id: 'mh_alg_qe_001',
        title: 'General Form',
        latex: 'ax^2 + bx + c = 0, \\quad a \\neq 0',
        description: 'Standard quadratic equation form where a, b, c are real numbers and a cannot be zero.',
        category: 'definition',
        difficulty: 'easy',
        widgetConfig: {
          type: 'model3d',
          title: '3D Paraboloid Explorer',
          config: {
            shape: 'quadratic',
            sliders: [
              { id: 'a', label: 'Curvature a', min: -2.0, max: 2.0, default: 1.0, step: 0.1 },
              { id: 'b', label: 'Cross term b', min: -2.0, max: 2.0, default: 0.0, step: 0.1 },
              { id: 'c', label: 'Vertical shift c', min: -5.0, max: 5.0, default: 2.0, step: 0.2 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_qe_002',
        title: 'Roots of Quadratic Equation',
        latex: '\\alpha,\\beta = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}',
        description: 'Formula to compute the roots α and β of any quadratic equation ax² + bx + c = 0. Real roots are visualised as contact points on the x-axis.',
        category: 'algebraic',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Quadratic Roots Explorer',
          config: {
            expressions: [
              { latex: 'y = a*x^2 + b*x + c', color: '#E67E22' }
            ],
            viewport: { xMin: -6.0, xMax: 6.0, yMin: -8.0, yMax: 8.0 },
            sliders: [
              { id: 'a', label: 'Coefficient a', min: -3.0, max: 3.0, default: 1.0, step: 0.1 },
              { id: 'b', label: 'Coefficient b', min: -5.0, max: 5.0, default: 0.0, step: 0.1 },
              { id: 'c', label: 'Coefficient c', min: -8.0, max: 8.0, default: -4.0, step: 0.1 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_qe_003',
        title: 'Discriminant and Nature of Roots',
        latex: '\\Delta = b^2 - 4ac',
        description: 'Determines the nature of roots: (1) Δ > 0: roots are real and unequal (curve crosses x-axis twice). (2) Δ = 0: roots are real and equal (curve touches x-axis once). (3) Δ < 0: roots are not real (curve does not touch x-axis).',
        category: 'roots',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Discriminant & Nature of Roots',
          config: {
            expressions: [
              { latex: 'y = a*x^2 + b*x + c', color: '#2ECC71' }
            ],
            viewport: { xMin: -6.0, xMax: 6.0, yMin: -8.0, yMax: 8.0 },
            sliders: [
              { id: 'a', label: 'Coefficient a', min: -3.0, max: 3.0, default: 1.0, step: 0.1 },
              { id: 'b', label: 'Coefficient b', min: -5.0, max: 5.0, default: 0.0, step: 0.1 },
              { id: 'c', label: 'Coefficient c', min: -8.0, max: 8.0, default: -4.0, step: 0.1 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_qe_004',
        title: 'Sum and Product of Roots',
        latex: '\\alpha + \\beta = -\\frac{b}{a}, \\quad \\alpha\\beta = \\frac{c}{a}',
        description: 'Core relationships between roots (α, β) and coefficients (a, b, c) of a quadratic equation.',
        category: 'roots',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Sum and Product of Roots',
          config: {
            expressions: [
              { latex: 'y = -b/a', color: '#3B82F6' },
              { latex: 'y = c/a', color: '#EF4444' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: -10.0, yMax: 10.0 },
            sliders: [
              { id: 'a', label: 'a', min: 1.0, max: 5.0, default: 1.0, step: 0.5 },
              { id: 'b', label: 'b', min: -5.0, max: 5.0, default: -3.0, step: 0.5 },
              { id: 'c', label: 'c', min: -5.0, max: 5.0, default: 2.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_qe_005',
        title: 'Forming Quadratic Equation from Roots',
        latex: 'x^2 - (\\alpha + \\beta)x + \\alpha\\beta = 0',
        description: 'Constructs the quadratic equation in variable x given its roots α and β.',
        category: 'algebraic',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Equation from Roots',
          config: {
            expressions: [
              { latex: 'y = x^2 - (a + b)*x + a*b', color: '#10B981' }
            ],
            viewport: { xMin: -5.0, xMax: 5.0, yMin: -10.0, yMax: 10.0 },
            sliders: [
              { id: 'a', label: 'Root α', min: -5.0, max: 5.0, default: 1.0, step: 0.5 },
              { id: 'b', label: 'Root β', min: -5.0, max: 5.0, default: 3.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_qe_006',
        title: 'Useful Quadratic Identities',
        latex: '\\alpha^2 + \\beta^2 = (\\alpha + \\beta)^2 - 2\\alpha\\beta',
        description: 'Useful identities for roots: (1) α² + β² = (α+β)² - 2αβ, (2) α³ + β³ = (α+β)³ - 3αβ(α+β), and (3) (α-β)² = (α+β)² - 4αβ.',
        category: 'roots',
        difficulty: 'hard'
      }
    ]
  },
  chap_03: {
    name: 'Arithmetic Progression',
    formulas: [
      {
        id: 'mh_alg_ap_001',
        title: 'Sum of n Terms (Definition)',
        latex: 'S_n = t_1 + t_2 + t_3 + \\cdots + t_n',
        description: 'We denote the sum of the first n terms of a sequence by Sn.',
        category: 'sequence',
        difficulty: 'easy'
      },
      {
        id: 'mh_alg_ap_002',
        title: 'Finding Term from Sum',
        latex: 't_n = S_n - S_{n-1}',
        description: 'Relationship to find any specific term (tn) of a sequence if the sum formula (Sn) is provided.',
        category: 'sequence',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Term from Sum',
          config: {
            expressions: [
              { latex: 'y = s - p', color: '#E67E22' }
            ],
            viewport: { xMin: -5.0, xMax: 5.0, yMin: -10.0, yMax: 50.0 },
            sliders: [
              { id: 's', label: 'Sum Sn', min: 0.0, max: 100.0, default: 45.0, step: 1.0 },
              { id: 'p', label: 'Sum S(n-1)', min: 0.0, max: 100.0, default: 36.0, step: 1.0 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_ap_003',
        title: 'General Term (nth term of an AP)',
        latex: 't_n = a + (n - 1)d',
        description: 'The nth term of an Arithmetic Progression with first term a and common difference d.',
        category: 'sequence',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'AP General Term Grapher',
          config: {
            expressions: [
              { latex: 'y = a + (x - 1)*d', color: '#2ECC71' }
            ],
            viewport: { xMin: 0.0, xMax: 15.0, yMin: -10.0, yMax: 40.0 },
            sliders: [
              { id: 'a', label: 'First term (a)', min: -5.0, max: 15.0, default: 2.0, step: 1.0 },
              { id: 'd', label: 'Difference (d)', min: -3.0, max: 5.0, default: 3.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_ap_004',
        title: 'Sum of First n Terms of an AP',
        latex: 'S_n = \\frac{n}{2}[2a + (n - 1)d]',
        description: 'Calculates the sum of first n terms of an AP. Also written as Sn = na + n(n-1)d/2.',
        category: 'series',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'AP Sum of n Terms Grapher',
          config: {
            expressions: [
              { latex: 'y = (x/2)*(2*a + (x - 1)*d)', color: '#3B82F6' }
            ],
            viewport: { xMin: 0.0, xMax: 15.0, yMin: -20.0, yMax: 200.0 },
            sliders: [
              { id: 'a', label: 'First term (a)', min: -5.0, max: 15.0, default: 2.0, step: 1.0 },
              { id: 'd', label: 'Difference (d)', min: -3.0, max: 10.0, default: 4.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_ap_005',
        title: 'Sum Using First and Last Term',
        latex: 'S_n = \\frac{n}{2}[t_1 + t_n] = \\frac{n}{2}[a + l]',
        description: 'Computes sum of n terms if the first term (a) and last term (l = tn) are known.',
        category: 'series',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Sum (First and Last)',
          config: {
            expressions: [
              { latex: 'y = (n/2)*(a + l)', color: '#3B82F6' }
            ],
            viewport: { xMin: -5.0, xMax: 5.0, yMin: 0.0, yMax: 200.0 },
            sliders: [
              { id: 'n', label: 'n terms', min: 1.0, max: 20.0, default: 10.0, step: 1.0 },
              { id: 'a', label: 'first (a)', min: -10.0, max: 20.0, default: 2.0, step: 1.0 },
              { id: 'l', label: 'last (l)', min: -10.0, max: 50.0, default: 20.0, step: 1.0 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_ap_006',
        title: 'Consecutive AP Terms Selection',
        latex: 'a-d, \\ a, \\ a+d',
        description: 'To consider consecutive terms in AP: (1) Three terms: a-d, a, a+d. (2) Four terms: a-3d, a-d, a+d, a+3d (diff 2d). (3) Five terms: a-2d, a-d, a, a+d, a+2d.',
        category: 'series',
        difficulty: 'intermediate'
      }
    ]
  },
  chap_04: {
    name: 'Financial Planning',
    formulas: [
      {
        id: 'mh_alg_fp_001',
        title: 'GST Payable & Components',
        latex: '\\text{GST Payable} = \\text{Output Tax} - \\text{ITC}',
        description: 'Output tax is collected on sales; input tax is paid on purchases. GST payable is Output Tax minus Input Tax Credit (ITC). CGST and SGST are two components: CGST = SGST = GST / 2.',
        category: 'tax',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'GST Output, Input & Payable',
          config: {
            expressions: [
              { latex: 'y = r*x', color: '#10B981' },
              { latex: 'y = r*p', color: '#EF4444' },
              { latex: 'y = r*(x - p)', color: '#3B82F6' }
            ],
            viewport: { xMin: 0.0, xMax: 200.0, yMin: -20.0, yMax: 50.0 },
            sliders: [
              { id: 'p', label: 'Purchase Price (p)', min: 10.0, max: 150.0, default: 100.0, step: 5.0 },
              { id: 'r', label: 'GST Rate (r)', min: 0.05, max: 0.28, default: 0.18, step: 0.01 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_fp_002',
        title: 'Market Value (MV) vs Face Value (FV)',
        latex: '\\text{MV} = \\text{FV} + \\text{Premium}',
        description: 'Share states: (1) MV > FV: Premium (MV = FV + Premium). (2) MV = FV: Par. (3) MV < FV: Discount (MV = FV - Discount). Dividend is always calculated on the Face Value (FV).',
        category: 'finance',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Market Value vs Face Value',
          config: {
            expressions: [
              { latex: 'y = f', color: '#10B981' },
              { latex: 'y = f + p', color: '#3B82F6' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: 0.0, yMax: 150.0 },
            sliders: [
              { id: 'f', label: 'Face Value (f)', min: 10.0, max: 100.0, default: 50.0, step: 5.0 },
              { id: 'p', label: 'Premium/Discount (p)', min: -30.0, max: 50.0, default: 15.0, step: 1.0 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_fp_003',
        title: 'Brokerage and Net Transactions',
        latex: '\\text{Buying Price} = \\text{MV} + \\text{Brokerage}',
        description: 'Transactions: Buying Price (CP) = MV + Brokerage. Selling Price = MV - Brokerage.',
        category: 'finance',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Brokerage Effect',
          config: {
            expressions: [
              { latex: 'y = m + b', color: '#EF4444' },
              { latex: 'y = m - b', color: '#10B981' }
            ],
            viewport: { xMin: -5.0, xMax: 5.0, yMin: 0.0, yMax: 200.0 },
            sliders: [
              { id: 'm', label: 'Market Value (MV)', min: 10.0, max: 200.0, default: 100.0, step: 5.0 },
              { id: 'b', label: 'Brokerage', min: 0.0, max: 20.0, default: 5.0, step: 1.0 }
            ]
          }
        }
      }
    ]
  },
  chap_05: {
    name: 'Probability',
    formulas: [
      {
        id: 'mh_alg_prob_001',
        title: 'Probability of an Event',
        latex: 'P(A) = \\frac{n(A)}{n(S)}',
        description: 'Calculates the probability of event A. Probability always satisfies 0 ≤ P(A) ≤ 1 and is usually written as a fraction or decimal.',
        category: 'probability',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Event Probability',
          config: {
            expressions: [
              { latex: 'y = a/s', color: '#3B82F6' }
            ],
            viewport: { xMin: -5.0, xMax: 5.0, yMin: -0.2, yMax: 1.2 },
            sliders: [
              { id: 'a', label: 'Event Outcomes n(A)', min: 0.0, max: 50.0, default: 6.0, step: 1.0 },
              { id: 's', label: 'Sample Space size n(S)', min: 1.0, max: 50.0, default: 24.0, step: 1.0 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_prob_002',
        title: 'Standard Sample Spaces',
        latex: 'n(S) \\in \\{2, 4, 8, 6, 36, 52\\}',
        description: 'Standard experiments: (1) One coin: S={H,T} (n=2). (2) Two coins: S={HH,HT,TH,TT} (n=4). (3) Three coins: n(S)=8. (4) One die: S={1,2,3,4,5,6} (n=6). (5) Two dice: n(S)=36. (6) Card deck: n(S)=52 (Spade, Club, Heart, Diamond).',
        category: 'probability',
        difficulty: 'easy'
      }
    ]
  },
  chap_06: {
    name: 'Statistics',
    formulas: [
      {
        id: 'mh_alg_stat_001',
        title: 'Mean (Direct Method)',
        latex: '\\bar{x} = \\frac{\\sum f_i x_i}{\\sum f_i}',
        description: 'Arithmetic mean for grouped frequency distribution. xi represents class marks and fi represents frequencies.',
        category: 'statistics',
        difficulty: 'easy'
      },
      {
        id: 'mh_alg_stat_002',
        title: 'Mean (Assumed Mean Method)',
        latex: '\\bar{x} = A + \\bar{d}',
        description: 'Where A is the assumed mean, di = xi - A is the deviation, and d̄ = Σ(fi di) / Σfi.',
        category: 'statistics',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_alg_stat_003',
        title: 'Mean (Step Deviation Method)',
        latex: '\\bar{x} = A + \\bar{u} \\cdot g',
        description: 'Where A is assumed mean, ui = (xi - A)/g, g is the class interval width (GCD of deviations), and ū = Σ(fi ui) / Σfi.',
        category: 'statistics',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_alg_stat_004',
        title: 'Median of Grouped Frequency Distribution',
        latex: '\\text{Median} = L + \\left(\\frac{\\frac{N}{2} - cf}{f}\\right)h',
        description: 'L is lower limit of median class, N is total frequency, cf is cumulative frequency of class preceding median class, f is frequency of median class, h is class width.',
        category: 'statistics',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Median Value Calculator',
          config: {
            expressions: [
              { latex: 'y = l + (((n/2) - c)/f)*h', color: '#10B981' }
            ],
            viewport: { xMin: -5.0, xMax: 5.0, yMin: 0.0, yMax: 100.0 },
            sliders: [
              { id: 'l', label: 'Lower Limit (L)', min: 0.0, max: 100.0, default: 40.0, step: 5.0 },
              { id: 'n', label: 'Total Freq (N)', min: 10.0, max: 200.0, default: 100.0, step: 10.0 },
              { id: 'c', label: 'Cum Freq (cf)', min: 0.0, max: 100.0, default: 30.0, step: 5.0 },
              { id: 'f', label: 'Freq (f)', min: 5.0, max: 50.0, default: 40.0, step: 5.0 },
              { id: 'h', label: 'Class Width (h)', min: 5.0, max: 20.0, default: 10.0, step: 1.0 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_stat_005',
        title: 'Mode of Grouped Frequency Distribution',
        latex: '\\text{Mode} = L + \\left(\\frac{f_m - f_1}{2f_m - f_1 - f_2}\\right)h',
        description: 'L is lower limit of modal class, fm is maximum class frequency, f1 is frequency of pre-modal class, f2 is frequency of post-modal class, h is class width.',
        category: 'statistics',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Mode Value Calculator',
          config: {
            expressions: [
              { latex: 'y = l + ((m - f1)/(2*m - f1 - f2))*h', color: '#3B82F6' }
            ],
            viewport: { xMin: -5.0, xMax: 5.0, yMin: 0.0, yMax: 100.0 },
            sliders: [
              { id: 'l', label: 'Lower Limit (L)', min: 0.0, max: 100.0, default: 40.0, step: 5.0 },
              { id: 'm', label: 'Max Freq (fm)', min: 10.0, max: 100.0, default: 50.0, step: 5.0 },
              { id: 'f1', label: 'Pre-Freq (f1)', min: 0.0, max: 100.0, default: 30.0, step: 5.0 },
              { id: 'f2', label: 'Post-Freq (f2)', min: 0.0, max: 100.0, default: 20.0, step: 5.0 },
              { id: 'h', label: 'Class Width (h)', min: 5.0, max: 20.0, default: 10.0, step: 1.0 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_stat_006',
        title: 'Empirical Relation (Mean, Median, Mode)',
        latex: '\\text{Mean} - \\text{Mode} = 3(\\text{Mean} - \\text{Median})',
        description: 'Relates three central measures. Mode can also be calculated as Mode = 3 Median - 2 Mean.',
        category: 'statistics',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Mean, Median, & Mode Relationship',
          config: {
            expressions: [
              { latex: 'y = m', color: '#EF4444' },
              { latex: 'y = d', color: '#10B981' },
              { latex: 'y = 3*d - 2*m', color: '#3B82F6' }
            ],
            viewport: { xMin: -10.0, xMax: 10.0, yMin: 0.0, yMax: 120.0 },
            sliders: [
              { id: 'm', label: 'Mean (m)', min: 10.0, max: 80.0, default: 50.0, step: 1.0 },
              { id: 'd', label: 'Median (d)', min: 10.0, max: 80.0, default: 45.0, step: 1.0 }
            ]
          }
        }
      },
      {
        id: 'mh_alg_stat_007',
        title: 'Central Angle of Pie Chart',
        latex: '\\theta = \\frac{\\text{Value of specific item}}{\\text{Total value of items}} \\times 360^\\circ',
        description: 'Calculates the central angle θ in degrees for plotting components in a pie diagram.',
        category: 'statistics',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Pie Chart Central Angle',
          config: {
            expressions: [
              { latex: 'y = (v/t)*360', color: '#E67E22' }
            ],
            viewport: { xMin: -5.0, xMax: 5.0, yMin: -20.0, yMax: 380.0 },
            sliders: [
              { id: 'v', label: 'Item Value (v)', min: 0.0, max: 100.0, default: 25.0, step: 1.0 },
              { id: 't', label: 'Total Value (t)', min: 50.0, max: 500.0, default: 100.0, step: 5.0 }
            ]
          }
        }
      }
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
  console.log(`\nSeeded ${total} Algebra formulas ✅\n`);
}

seedAlgebraFormulas().catch(console.error);
