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

const sci1Formulas = {
  chap_01: {
    name: 'Gravitation',
    formulas: [
      {
        id: 'mh_s1_grav_001',
        title: 'Gravitational Force',
        latex: 'F = G\\frac{m_1 m_2}{d^2}',
        description: 'Newton\'s universal law of gravitation: Every object in the Universe attracts every other object with a force directly proportional to the product of their masses and inversely proportional to the square of the distance between them.',
        category: 'gravitation',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Gravitational Force vs Distance',
          config: {
            expressions: [
              { latex: 'y = (6.67 * 10^{-11}) * m1 * m2 / x^2', color: '#3498DB' }
            ],
            viewport: { xMin: 0.1, xMax: 10.0, yMin: 0.0, yMax: 1e-8 },
            sliders: [
              { id: 'm1', label: 'Mass m₁ (kg)', min: 10.0, max: 1000.0, default: 100.0, step: 10.0 },
              { id: 'm2', label: 'Mass m₂ (kg)', min: 10.0, max: 1000.0, default: 100.0, step: 10.0 }
            ]
          }
        }
      },
      {
        id: 'mh_s1_grav_002',
        title: 'Centripetal Force',
        latex: 'F = \\frac{mv^2}{r}',
        description: 'A force acting on an object moving along a circle, directed towards the centre of the circle.',
        category: 'mechanics',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Centripetal Force vs Radius',
          config: {
            expressions: [
              { latex: 'y = m * v^2 / x', color: '#2ECC71' }
            ],
            viewport: { xMin: 0.5, xMax: 10.0, yMin: 0.0, yMax: 50.0 },
            sliders: [
              { id: 'm', label: 'Mass (m)', min: 0.5, max: 5.0, default: 1.0, step: 0.1 },
              { id: 'v', label: 'Velocity (v)', min: 1.0, max: 10.0, default: 5.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_s1_grav_003',
        title: 'Relation between Mass and Weight',
        latex: 'W = F = mg',
        description: 'Weight is the gravitational force acting on a body. m is mass, g is acceleration due to gravity.',
        category: 'gravitation',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Weight vs Gravity',
          config: {
            expressions: [
              { latex: 'y = m * x', color: '#9B59B6' }
            ],
            viewport: { xMin: 0.0, xMax: 25.0, yMin: 0.0, yMax: 250.0 },
            sliders: [
              { id: 'm', label: 'Mass m (kg)', min: 1.0, max: 20.0, default: 10.0, step: 0.5 }
            ]
          }
        }
      },
      {
        id: 'mh_s1_grav_004',
        title: 'First Equation of Motion (Newton\'s Laws)',
        latex: 'v = u + at',
        description: 'First kinematic equation of motion showing velocity-time relation.',
        category: 'kinematics',
        difficulty: 'easy'
      },
      {
        id: 'mh_s1_grav_005',
        title: 'Second Equation of Motion (Newton\'s Laws)',
        latex: 'v^2 = u^2 + 2as',
        description: 'Second kinematic equation of motion showing velocity-displacement relation.',
        category: 'kinematics',
        difficulty: 'easy'
      },
      {
        id: 'mh_s1_grav_006',
        title: 'Third Equation of Motion (Newton\'s Laws)',
        latex: 's = ut + \\frac{1}{2}at^2',
        description: 'Third kinematic equation of motion showing displacement-time relation.',
        category: 'kinematics',
        difficulty: 'easy'
      },
      {
        id: 'mh_s1_grav_007',
        title: 'Concept of Free Fall',
        latex: 'v = gt, \\quad s = \\frac{1}{2}gt^2, \\quad v^2 = 2gs',
        description: 'Equations of motion for an object falling freely under gravity where initial velocity u = 0 and acceleration a = g.',
        category: 'kinematics',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'simulation',
          title: 'Free Fall Simulation',
          config: {
            simulationId: 'projectile',
            sliders: [
              { id: 'v0', label: 'Initial Velocity (v₀)', min: 0.0, max: 50.0, default: 0.0, step: 1.0 },
              { id: 'theta', label: 'Angle (θ)', min: 0.0, max: 90.0, default: 90.0, step: 5.0 }
            ]
          }
        }
      },
      {
        id: 'mh_s1_grav_008',
        title: 'Gravitational Potential Energy',
        latex: 'U = -\\frac{GMm}{R+h}',
        description: 'Potential energy of an object of mass m at height h above the Earth\'s surface. It is zero at infinity and negative at finite distances.',
        category: 'gravitation',
        difficulty: 'hard'
      },
      {
        id: 'mh_s1_grav_009',
        title: 'Escape Velocity',
        latex: 'v_{esc} = \\sqrt{\\frac{2GM}{R}}',
        description: 'The minimum velocity required for a body to escape the gravitational pull of the Earth.',
        category: 'gravitation',
        difficulty: 'hard'
      },
      {
        id: 'mh_s1_grav_010',
        title: 'Kepler\'s Laws of Planetary Motion',
        latex: 'T^2 \\propto r^3',
        description: '1. Law of Orbits: Elliptical orbits with the sun at one focus. 2. Law of Areas: Sweeps equal areas in equal times. 3. Law of Periods: Square of period is proportional to cube of mean distance.',
        category: 'gravitation',
        difficulty: 'intermediate'
      }
    ]
  },
  chap_02: {
    name: 'Periodic Classification of Elements',
    formulas: [
      { id: 'mh_s1_pce_001', title: 'Atomic Number', latex: 'Z = \\text{Number of protons}', description: 'Atomic number determines the position of an element in the periodic table.', category: 'concept', difficulty: 'easy' },
      { id: 'mh_s1_pce_002', title: 'Mass Number', latex: 'A = Z + N', description: 'Sum of protons (Z) and neutrons (N) in the nucleus.', category: 'concept', difficulty: 'easy' },
      { id: 'mh_s1_pce_003', title: 'Number of Elements in a Period', latex: '2n^2', description: 'Maximum number of elements that can be accommodated in a shell n.', category: 'periodic-table', difficulty: 'intermediate' },
      { id: 'mh_s1_pce_004', title: 'Valency from Group Number', latex: '\\text{Valency} = \\min(G,\\; 18-G)', description: 'For main group elements G (1-18). Group 1→valency 1, Group 17→valency 1.', category: 'concept', difficulty: 'easy' }
    ]
  },
  chap_03: {
    name: 'Chemical reactions and equations',
    formulas: [
      { id: 'mh_s1_cre_001', title: 'Balancing Chemical Equations', latex: '\\text{Reactants} \\rightarrow \\text{Products}', description: 'Law of conservation of mass: atoms on both sides must be equal.', category: 'concept', difficulty: 'easy' },
      { id: 'mh_s1_cre_002', title: 'Exothermic Reaction', latex: 'A + B \\rightarrow C + D + \\text{Heat}', description: 'Reaction that releases energy in the form of heat.', category: 'reaction-type', difficulty: 'easy' },
      { id: 'mh_s1_cre_003', title: 'Endothermic Reaction', latex: 'A + B + \\text{Heat} \\rightarrow C + D', description: 'Reaction that absorbs energy from surroundings.', category: 'reaction-type', difficulty: 'easy' },
      { id: 'mh_s1_cre_004', title: 'Oxidation-Reduction', latex: '\\text{Oxidation: loss of } e^-;\\quad \\text{Reduction: gain of } e^-', description: 'OIL RIG — Oxidation Is Loss, Reduction Is Gain of electrons.', category: 'redox', difficulty: 'intermediate' }
    ]
  },
  chap_04: {
    name: 'Effects of electric current',
    formulas: [
      {
        id: 'mh_s1_elec_001',
        title: "Ohm's Law",
        latex: 'V = IR',
        description: 'Voltage equals current times resistance.',
        category: 'electricity',
        difficulty: 'easy',
        widgetConfig: {
          type: 'circuit',
          title: "Ohm's Law Circuit Explorer",
          config: {
            sliders: [
              { id: 'V', label: 'Voltage (V)', min: 1.0, max: 24.0, default: 12.0, step: 0.5 },
              { id: 'R', label: 'Resistance (R)', min: 1.0, max: 100.0, default: 10.0, step: 1.0 }
            ]
          }
        }
      },
      {
        id: 'mh_s1_elec_002',
        title: 'Electric Power',
        latex: 'P = VI = I^2R = \\frac{V^2}{R}',
        description: 'Power dissipated in an electrical circuit (in Watts). Also defined as Energy divided by Time.',
        category: 'electricity',
        difficulty: 'easy',
        widgetConfig: {
          type: 'circuit',
          title: 'Electric Power Circuit',
          config: {
            sliders: [
              { id: 'V_s', label: 'Source Voltage (Vs)', min: 1.0, max: 50.0, default: 24.0, step: 1.0 },
              { id: 'R', label: 'Load Resistance (R)', min: 5.0, max: 200.0, default: 50.0, step: 5.0 }
            ]
          }
        }
      },
      { id: 'mh_s1_elec_003', title: 'Electrical Energy', latex: 'E = Pt = VIt', description: 'Energy consumed (in Joules or kWh).', category: 'electricity', difficulty: 'easy' },
      { id: 'mh_s1_elec_004', title: 'Resistors in Series', latex: 'R_s = R_1 + R_2 + R_3', description: 'Total resistance increases in series combination.', category: 'circuit', difficulty: 'easy' },
      { id: 'mh_s1_elec_005', title: 'Resistors in Parallel', latex: '\\frac{1}{R_p} = \\frac{1}{R_1} + \\frac{1}{R_2} + \\frac{1}{R_3}', description: 'Total resistance decreases in parallel combination.', category: 'circuit', difficulty: 'intermediate' },
      {
        id: 'mh_s1_elec_006',
        title: 'Heating Effect (Joule\'s Law)',
        latex: 'H = I^2 R t',
        description: 'Heat produced in a conductor carrying current I for time t.',
        category: 'electricity',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: "Joule's Heating Curve",
          config: {
            expressions: [
              { latex: 'y = x^2 * R * t', color: '#E74C3C' }
            ],
            viewport: { xMin: 0.0, xMax: 10.0, yMin: 0.0, yMax: 1000.0 },
            sliders: [
              { id: 'R', label: 'Resistance (R)', min: 1.0, max: 50.0, default: 10.0, step: 1.0 },
              { id: 't', label: 'Time (t)', min: 1.0, max: 60.0, default: 5.0, step: 1.0 }
            ]
          }
        }
      },
      {
        id: 'mh_s1_elec_007',
        title: 'Right Hand Thumb Rule',
        latex: '\\text{Thumb} \\rightarrow \\vec{I}, \\quad \\text{Fingers} \\rightarrow \\vec{B}',
        description: 'If a current-carrying conductor is held in the right hand such that the thumb points in the direction of the current, then the curled fingers indicate the direction of the magnetic field lines.',
        category: 'electromagnetism',
        difficulty: 'easy'
      },
      {
        id: 'mh_s1_elec_008',
        title: 'Fleming\'s Left Hand Rule',
        latex: '\\text{Thumb} \\rightarrow \\vec{F}, \\quad \\text{Index} \\rightarrow \\vec{B}, \\quad \\text{Middle} \\rightarrow \\vec{I}',
        description: 'Stretched perpendicular fingers of the left hand: Index finger points to magnetic field, Middle finger points to current, Thumb points to force direction.',
        category: 'electromagnetism',
        difficulty: 'easy'
      },
      {
        id: 'mh_s1_elec_009',
        title: 'Fleming\'s Right Hand Rule',
        latex: '\\text{Thumb} \\rightarrow \\vec{v}, \\quad \\text{Index} \\rightarrow \\vec{B}, \\quad \\text{Middle} \\rightarrow \\vec{I}_{induced}',
        description: 'Stretched perpendicular fingers of the right hand: Thumb points to conductor motion direction, Index finger points to magnetic field, Middle finger points to induced current direction.',
        category: 'electromagnetism',
        difficulty: 'easy'
      },
      {
        id: 'mh_s1_elec_010',
        title: 'Faraday\'s Law of Induction',
        latex: '\\mathcal{E} \\propto \\frac{d\\Phi_B}{dt}',
        description: 'Whenever the number of magnetic lines of force passing through a coil changes, a current is induced in the coil.',
        category: 'electromagnetism',
        difficulty: 'intermediate'
      }
    ]
  },
  chap_05: {
    name: 'Heat',
    formulas: [
      {
        id: 'mh_s1_heat_001',
        title: 'Relative Humidity',
        latex: '\\%\\text{Relative Humidity} = \\frac{\\text{Actual Mass of Water Vapour}}{\\text{Saturated Mass of Vapour}} \\times 100',
        description: 'Percentage ratio of the actual mass of water vapour content in a volume of air to the mass of vapour needed to saturate it at that temperature.',
        category: 'thermal',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: 'Relative Humidity Curve',
          config: {
            expressions: [
              { latex: 'y = (x / saturation) * 100', color: '#3498DB' }
            ],
            viewport: { xMin: 0.0, xMax: 50.0, yMin: 0.0, yMax: 100.0 },
            sliders: [
              { id: 'saturation', label: 'Max Vapour Capacity (g)', min: 10.0, max: 100.0, default: 50.0, step: 2.0 }
            ]
          }
        }
      },
      {
        id: 'mh_s1_heat_002',
        title: 'Specific Heat Capacity',
        latex: 'Q = mc\\Delta T',
        description: 'Heat absorbed or released. m = mass, c = specific heat, ΔT = temperature change.',
        category: 'thermal',
        difficulty: 'easy',
        widgetConfig: {
          type: 'graph',
          title: 'Heat Energy vs Temp Change',
          config: {
            expressions: [
              { latex: 'y = m * c * x', color: '#E67E22' }
            ],
            viewport: { xMin: 0.0, xMax: 100.0, yMin: 0.0, yMax: 50000.0 },
            sliders: [
              { id: 'm', label: 'Mass (m)', min: 0.1, max: 10.0, default: 1.0, step: 0.1 },
              { id: 'c', label: 'Specific Heat (c)', min: 0.1, max: 5.0, default: 4.2, step: 0.1 }
            ]
          }
        }
      },
      { id: 'mh_s1_heat_003', title: 'Latent Heat', latex: 'Q = mL', description: 'Heat for phase change without temperature change. L = specific latent heat.', category: 'thermal', difficulty: 'easy' },
      { id: 'mh_s1_heat_004', title: 'Linear Expansion', latex: 'L = L_0(1 + \\alpha \\Delta T)', description: 'Length change due to temperature. α = coefficient of linear expansion.', category: 'expansion', difficulty: 'intermediate' },
      { id: 'mh_s1_heat_005', title: 'Anomalous Expansion of Water', latex: '\\text{Max density at } 4^\\circ\\text{C}', description: 'Water contracts from 0°C to 4°C (anomalous behavior), then expands normally.', category: 'concept', difficulty: 'easy' }
    ]
  },
  chap_06: {
    name: 'Refraction of light',
    formulas: [
      {
        id: 'mh_s1_ref_001',
        title: 'Refractive Index (Second w.r.t. First Medium)',
        latex: '{}^2n_1 = \\frac{v_1}{v_2}',
        description: 'Velocity of light in medium 1 divided by velocity of light in medium 2.',
        category: 'optics',
        difficulty: 'easy'
      },
      {
        id: 'mh_s1_ref_002',
        title: 'Refractive Index (First w.r.t. Second Medium)',
        latex: '{}^1n_2 = \\frac{v_2}{v_1}',
        description: 'Velocity of light in medium 2 divided by velocity of light in medium 1.',
        category: 'optics',
        difficulty: 'easy'
      },
      {
        id: 'mh_s1_ref_003',
        title: 'Snell\'s Law (Internal Refraction)',
        latex: 'n = \\frac{\\sin i}{\\sin r}',
        description: 'Relates angles of incidence (i) and refraction (r) when passing from medium 1 to medium 2.',
        category: 'optics',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'graph',
          title: "Snell's Law: Refraction Curve",
          config: {
            expressions: [
              { latex: 'y = (n1/n2)*sin(x)', color: '#9B59B6' }
            ],
            viewport: { xMin: 0.0, xMax: 1.57, yMin: 0.0, yMax: 1.57 },
            sliders: [
              { id: 'n1', label: 'Medium 1 Index (n1)', min: 1.0, max: 2.5, default: 1.0, step: 0.1 },
              { id: 'n2', label: 'Medium 2 Index (n2)', min: 1.0, max: 2.5, default: 1.5, step: 0.1 }
            ]
          }
        }
      },
      { id: 'mh_s1_ref_004', title: 'Critical Angle', latex: '\\sin C = \\frac{1}{n}', description: 'Angle of incidence for which angle of refraction is 90° (total internal reflection).', category: 'optics', difficulty: 'intermediate' }
    ]
  },
  chap_07: {
    name: 'Lenses',
    formulas: [
      {
        id: 'mh_s1_lens_001',
        title: 'Lens Formula',
        latex: '\\frac{1}{v} - \\frac{1}{u} = \\frac{1}{f}',
        description: 'Relates focal length f, image distance v, and object distance u.',
        category: 'optics',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'image',
          title: 'Convex Lens Ray Diagram',
          config: {
            url: 'https://images.unsplash.com/photo-1601042879364-f3947d3f9c16?w=800',
            annotations: [
              { x: 0.2, y: 0.4, title: 'Object (u)', description: 'The source of light rays located at distance u from the optical centre.' },
              { x: 0.5, y: 0.5, title: 'Optical Centre (O)', description: 'The center point of the lens through which rays pass without deviation.' },
              { x: 0.65, y: 0.5, title: 'Focus (F)', description: 'The point where parallel rays converge after passing through the convex lens.' },
              { x: 0.85, y: 0.65, title: 'Real Image (v)', description: 'The inverted image formed on the other side of the lens at distance v.' }
            ]
          }
        }
      },
      {
        id: 'mh_s1_lens_002',
        title: 'Magnification (M)',
        latex: 'M = \\frac{h_2}{h_1} = \\frac{v}{u}',
        description: 'Ratio of image height (h₂) to object height (h₁), or image distance (v) to object distance (u).',
        category: 'optics',
        difficulty: 'easy'
      },
      { id: 'mh_s1_lens_003', title: 'Power of Lens (P)', latex: 'P = \\frac{1}{f}', description: 'Calculated with focal length f in meters. Expressed in Dioptres (D).', category: 'optics', difficulty: 'easy' },
      {
        id: 'mh_s1_lens_004',
        title: 'Combination of Lenses (Focal Length)',
        latex: '\\frac{1}{f} = \\frac{1}{f_1} + \\frac{1}{f_2}',
        description: 'Effective focal length of two thin lenses in contact.',
        category: 'optics',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_s1_lens_005',
        title: 'Combination of Lenses (Power)',
        latex: 'P = P_1 + P_2',
        description: 'Effective power of two thin lenses in contact.',
        category: 'optics',
        difficulty: 'intermediate'
      }
    ]
  },
  chap_08: {
    name: 'Metallurgy',
    formulas: [
      { id: 'mh_s1_met_001', title: 'Reactivity Series', latex: 'K > Na > Ca > Mg > Al > Zn > Fe > Cu > Ag > Au', description: 'Metals arranged in decreasing order of reactivity.', category: 'concept', difficulty: 'easy' },
      { id: 'mh_s1_met_002', title: 'Thermite Reaction', latex: '2Al + Fe_2O_3 \\rightarrow Al_2O_3 + 2Fe + \\text{Heat}', description: 'Aluminium reduces iron oxide — used in welding railway tracks.', category: 'reaction', difficulty: 'intermediate' },
      { id: 'mh_s1_met_003', title: 'Electrolytic Refining', latex: '\\text{Anode: impure metal} \\rightarrow \\text{Cathode: pure metal}', description: 'Purification of metals using electrolysis.', category: 'concept', difficulty: 'intermediate' }
    ]
  },
  chap_09: {
    name: 'Carbon compounds',
    formulas: [
      {
        id: 'mh_s1_carb_001',
        title: 'General Formula of Alkanes',
        latex: 'C_nH_{2n+2}',
        description: 'Saturated hydrocarbons with single bonds only.',
        category: 'organic',
        difficulty: 'easy',
        widgetConfig: {
          type: 'chemistry',
          title: 'Methane (Alkane)',
          config: {
            smiles: 'C',
            renderMode: '3d'
          }
        }
      },
      {
        id: 'mh_s1_carb_002',
        title: 'General Formula of Alkenes',
        latex: 'C_nH_{2n}',
        description: 'Unsaturated hydrocarbons with one C=C double bond.',
        category: 'organic',
        difficulty: 'easy',
        widgetConfig: {
          type: 'chemistry',
          title: 'Ethene (Alkene)',
          config: {
            smiles: 'C=C',
            renderMode: '3d'
          }
        }
      },
      {
        id: 'mh_s1_carb_003',
        title: 'General Formula of Alkynes',
        latex: 'C_nH_{2n-2}',
        description: 'Unsaturated hydrocarbons with one C≡C triple bond.',
        category: 'organic',
        difficulty: 'easy',
        widgetConfig: {
          type: 'chemistry',
          title: 'Ethyne (Alkyne)',
          config: {
            smiles: 'C#C',
            renderMode: '3d'
          }
        }
      },
      {
        id: 'mh_s1_carb_004',
        title: 'Ethanol Formula',
        latex: 'C_2H_5OH',
        description: 'Ethanol — a two-carbon alcohol used as a fuel and solvent.',
        category: 'organic',
        difficulty: 'easy',
        widgetConfig: {
          type: 'chemistry',
          title: 'Ethanol Molecule',
          config: {
            smiles: 'CCO',
            renderMode: '3d'
          }
        }
      },
      { id: 'mh_s1_carb_005', title: 'Esterification', latex: 'R{-}COOH + R\'{-}OH \\rightleftharpoons R{-}COOR\' + H_2O', description: 'Carboxylic acid + alcohol → ester + water (acid catalyst).', category: 'reaction', difficulty: 'intermediate' }
    ]
  },
  chap_10: {
    name: 'Space Missions',
    formulas: [
      {
        id: 'mh_s1_space_001',
        title: 'Centripetal Force',
        latex: 'F = \\frac{mv^2}{r}',
        description: 'Force directing a satellite of mass m in circular orbit of radius r = R+h towards the center.',
        category: 'space',
        difficulty: 'intermediate'
      },
      {
        id: 'mh_s1_space_002',
        title: 'Escape Velocity (v_esc)',
        latex: 'v_{esc} = \\sqrt{\\frac{2GM}{R}}',
        description: 'Minimum initial velocity needed to escape the Earth\'s gravitational field from the surface.',
        category: 'space',
        difficulty: 'hard'
      },
      { id: 'mh_s1_space_003', title: 'Orbital Velocity', latex: 'v_o = \\sqrt{\\frac{GM}{R+h}}', description: 'Velocity for stable circular orbit around Earth at height h.', category: 'space', difficulty: 'hard' },
      { id: 'mh_s1_space_004', title: 'Time Period of Satellite', latex: 'T = 2\\pi\\sqrt{\\frac{(R+h)^3}{GM}}', description: 'Time to complete one orbit at height h above surface.', category: 'space', difficulty: 'hard' },
      { id: 'mh_s1_space_005', title: 'Geostationary Orbit Height', latex: 'h \\approx 35786\\;\\text{km}', description: 'Height where satellite period equals Earth rotation period (24 hrs).', category: 'concept', difficulty: 'intermediate' }
    ]
  }
};

async function seedSci1Formulas() {
  console.log('Seeding MH Board 10th — Sci Part 1 Formulas...\n');
  const subjectId = 'mh_sci1_10';
  let batch = db.batch();
  let ops = 0;
  let total = 0;

  for (const [chapId, chapData] of Object.entries(sci1Formulas)) {
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
  console.log(`\nSeeded ${total} Sci Part 1 formulas ✅\n`);
}

seedSci1Formulas().catch(console.error);
