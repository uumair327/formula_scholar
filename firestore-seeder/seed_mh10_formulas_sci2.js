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

const sci2Formulas = {
  chap_01: {
    name: 'Heredity and Evolution',
    formulas: [
      { id: 'mh_s2_he_001', title: 'Monohybrid Ratio', latex: '\\text{F}_2 \\text{ Phenotypic Ratio} = 3:1', description: 'Mendel\'s monohybrid cross ratio: 3 dominant : 1 recessive phenotype.', category: 'genetics', difficulty: 'easy' },
      { id: 'mh_s2_he_002', title: 'Dihybrid Ratio', latex: '\\text{F}_2 \\text{ Ratio} = 9:3:3:1', description: 'Mendel\'s dihybrid cross phenotypic ratio in F₂ generation.', category: 'genetics', difficulty: 'intermediate' },
      { id: 'mh_s2_he_003', title: 'Genotypic Ratio (Monohybrid)', latex: 'TT : Tt : tt = 1:2:1', description: 'Genotypic ratio from monohybrid cross of two heterozygous parents.', category: 'genetics', difficulty: 'intermediate' },
      { id: 'mh_s2_he_004', title: 'Sex Determination', latex: 'XX = \\text{Female},\\quad XY = \\text{Male}', description: 'Human sex determined by sex chromosomes from the father.', category: 'genetics', difficulty: 'easy' },
    ]
  },
  chap_02: {
    name: 'Life Processes in Living Organisms Part -1',
    formulas: [
      {
        id: 'mh_s2_lp1_001',
        title: 'Aerobic Respiration',
        latex: 'C_6H_{12}O_6 + 6O_2 \\rightarrow 6CO_2 + 6H_2O + \\text{ATP}',
        description: 'Complete oxidation of glucose in the presence of oxygen (38 ATP produced).',
        category: 'respiration',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'chemistry',
          title: 'Glucose Molecule (3D)',
          config: {
            smiles: 'C(C1C(C(C(C(O1)O)O)O)O)O',
            renderMode: '3d'
          }
        }
      },
      {
        id: 'mh_s2_lp1_002',
        title: 'Anaerobic Respiration (Yeast)',
        latex: 'C_6H_{12}O_6 \\rightarrow 2C_2H_5OH + 2CO_2 + \\text{ATP}',
        description: 'Fermentation by yeast: glucose → ethanol + CO₂ (2 ATP).',
        category: 'respiration',
        difficulty: 'intermediate',
        widgetConfig: {
          type: 'chemistry',
          title: 'Ethanol Molecule (3D)',
          config: {
            smiles: 'CCO',
            renderMode: '3d'
          }
        }
      },
      {
        id: 'mh_s2_lp1_003',
        title: 'Photosynthesis',
        latex: '6CO_2 + 6H_2O \\xrightarrow{\\text{sunlight}} C_6H_{12}O_6 + 6O_2',
        description: 'Plants convert CO₂ and water into glucose using sunlight and chlorophyll.',
        category: 'nutrition',
        difficulty: 'easy',
        widgetConfig: {
          type: 'chemistry',
          title: 'Carbon Dioxide Molecule (3D)',
          config: {
            smiles: 'O=C=O',
            renderMode: '3d'
          }
        }
      },
      { id: 'mh_s2_lp1_004', title: 'BMI (Body Mass Index)', latex: 'BMI = \\frac{\\text{Weight (kg)}}{\\text{Height (m)}^2}', description: 'Used to classify underweight, normal, overweight, and obese categories.', category: 'health', difficulty: 'easy' },
    ]
  },
  chap_03: {
    name: 'Life Processes in Living Organisms Part - 2',
    formulas: [
      { id: 'mh_s2_lp2_001', title: 'Excretory System Function', latex: '\\text{Blood} \\xrightarrow{\\text{Nephron}} \\text{Urine}', description: 'Kidneys filter blood through nephrons — the structural and functional unit.', category: 'concept', difficulty: 'easy' },
      { id: 'mh_s2_lp2_002', title: 'Blood Composition', latex: '\\text{Blood} = \\text{Plasma (55\\%)} + \\text{Cells (45\\%)}', description: 'Plasma contains water, proteins, salts. Cells include RBC, WBC, platelets.', category: 'concept', difficulty: 'easy' },
      { id: 'mh_s2_lp2_003', title: 'Cardiac Output', latex: 'CO = \\text{Stroke Volume} \\times \\text{Heart Rate}', description: 'Volume of blood pumped by heart per minute (≈ 5 L/min at rest).', category: 'circulation', difficulty: 'intermediate' },
    ]
  },
  chap_04: {
    name: 'Environmental Management',
    formulas: [
      { id: 'mh_s2_em_001', title: '3R Principle', latex: '\\text{Reduce} \\rightarrow \\text{Reuse} \\rightarrow \\text{Recycle}', description: 'Waste management hierarchy for environmental conservation.', category: 'concept', difficulty: 'easy' },
      { id: 'mh_s2_em_002', title: 'Carbon Footprint', latex: 'CF = \\sum \\text{CO}_2 \\text{ emissions (kg)}', description: 'Total greenhouse gas emissions caused by an individual or organization.', category: 'concept', difficulty: 'easy' },
      { id: 'mh_s2_em_003', title: 'Biodiversity Levels', latex: '\\text{Genetic} \\subset \\text{Species} \\subset \\text{Ecosystem}', description: 'Three levels of biodiversity from micro to macro scale.', category: 'ecology', difficulty: 'easy' },
    ]
  },
  chap_05: {
    name: 'Towards Green Energy',
    formulas: [
      { id: 'mh_s2_ge_001', title: 'Solar Cell Efficiency', latex: '\\eta = \\frac{P_{\\text{output}}}{P_{\\text{input}}} \\times 100\\%', description: 'Ratio of electrical output to solar radiation input.', category: 'energy', difficulty: 'intermediate' },
      { id: 'mh_s2_ge_002', title: 'Wind Energy', latex: 'P = \\frac{1}{2}\\rho A v^3', description: 'Power from wind depends on air density ρ, swept area A, and wind speed v.', category: 'energy', difficulty: 'hard' },
      { id: 'mh_s2_ge_003', title: 'Energy from Biogas', latex: 'C_6H_{12}O_6 \\xrightarrow{\\text{anaerobic}} CH_4 + CO_2', description: 'Biomass → Methane (biogas) through anaerobic digestion.', category: 'energy', difficulty: 'intermediate' },
    ]
  },
  chap_06: {
    name: 'Animal Classification',
    formulas: [
      { id: 'mh_s2_ac_001', title: 'Taxonomic Hierarchy', latex: 'K \\rightarrow P \\rightarrow C \\rightarrow O \\rightarrow F \\rightarrow G \\rightarrow S', description: 'Kingdom → Phylum → Class → Order → Family → Genus → Species.', category: 'taxonomy', difficulty: 'easy' },
      { id: 'mh_s2_ac_002', title: 'Binomial Nomenclature', latex: '\\textit{Genus species}', description: 'Two-part naming system by Linnaeus (e.g., Homo sapiens).', category: 'taxonomy', difficulty: 'easy' },
      { id: 'mh_s2_ac_003', title: 'Five Kingdom Classification', latex: '\\text{Monera, Protista, Fungi, Plantae, Animalia}', description: 'Whittaker\'s five-kingdom classification system based on cell structure and nutrition.', category: 'taxonomy', difficulty: 'easy' },
    ]
  },
  chap_07: {
    name: 'Introduction to Microbiology',
    formulas: [
      { id: 'mh_s2_micro_001', title: 'Bacterial Growth (Exponential)', latex: 'N_t = N_0 \\times 2^n', description: 'Population after n generations. N₀ = initial count, each gen doubles.', category: 'microbiology', difficulty: 'intermediate' },
      { id: 'mh_s2_micro_002', title: 'Generation Time', latex: 'g = \\frac{t}{n}', description: 'Average time for one bacterial division. E. coli ≈ 20 min.', category: 'microbiology', difficulty: 'easy' },
      { id: 'mh_s2_micro_003', title: 'Koch\'s Postulates', latex: '\\text{Isolate} \\rightarrow \\text{Culture} \\rightarrow \\text{Infect} \\rightarrow \\text{Re-isolate}', description: 'Four steps to prove a specific microorganism causes a disease.', category: 'concept', difficulty: 'intermediate' },
    ]
  },
  chap_08: {
    name: 'Cell Biology and Biotechnology',
    formulas: [
      { id: 'mh_s2_cbt_001', title: 'Cell Division: Mitosis', latex: '2n \\rightarrow 2n', description: 'Equational division: one parent cell produces two identical daughter cells.', category: 'cell-biology', difficulty: 'easy' },
      { id: 'mh_s2_cbt_002', title: 'Cell Division: Meiosis', latex: '2n \\rightarrow n', description: 'Reductional division: diploid cell produces four haploid gametes.', category: 'cell-biology', difficulty: 'easy' },
      { id: 'mh_s2_cbt_003', title: 'DNA Structure', latex: 'A=T,\\quad G\\equiv C', description: 'Chargaff\'s rule: Adenine pairs with Thymine (2 H-bonds), Guanine with Cytosine (3 H-bonds).', category: 'molecular', difficulty: 'intermediate' },
    ]
  },
  chap_09: {
    name: 'Social Health',
    formulas: [
      { id: 'mh_s2_sh_001', title: 'Drug Abuse Categories', latex: '\\text{Stimulants, Depressants, Hallucinogens, Narcotics}', description: 'Four major categories of commonly abused substances.', category: 'concept', difficulty: 'easy' },
      { id: 'mh_s2_sh_002', title: 'Blood Alcohol Concentration', latex: 'BAC = \\frac{\\text{Alcohol (g)}}{\\text{Body weight (g)}} \\times 100', description: 'Legal limit varies by country. Affects motor skills and judgment.', category: 'health', difficulty: 'intermediate' },
    ]
  },
  chap_10: {
    name: 'Disaster Management',
    formulas: [
      { id: 'mh_s2_dm_001', title: 'Richter Scale (Earthquake)', latex: 'M_L = \\log_{10} A', description: 'Earthquake magnitude. Each whole number increase = 10x amplitude.', category: 'measurement', difficulty: 'intermediate' },
      { id: 'mh_s2_dm_002', title: 'Disaster Management Cycle', latex: '\\text{Mitigation} \\rightarrow \\text{Preparedness} \\rightarrow \\text{Response} \\rightarrow \\text{Recovery}', description: 'Four phases of disaster management framework.', category: 'concept', difficulty: 'easy' },
    ]
  }
};

async function seedSci2Formulas() {
  console.log('Seeding MH Board 10th — Sci Part 2 Formulas...\n');
  const subjectId = 'mh_sci2_10';
  let batch = db.batch();
  let ops = 0;
  let total = 0;

  for (const [chapId, chapData] of Object.entries(sci2Formulas)) {
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
  console.log(`\nSeeded ${total} Sci Part 2 formulas ✅\n`);
}

seedSci2Formulas().catch(console.error);
