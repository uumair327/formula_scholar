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

async function deleteCollection(collectionPath) {
    const snap = await db.collection(collectionPath).get();
    if (snap.size === 0) return 0;
    const batch = db.batch();
    snap.docs.forEach(doc => batch.delete(doc.ref));
    await batch.commit();
    return snap.size;
}

async function seedExtraQuizzes() {
    console.log('Cleaning stale collections...');
    const staleCols = ['contentRegistry', 'curriculumRegistry', 'canonical_formulas'];
    for (const col of staleCols) {
        const deleted = await deleteCollection(col);
        console.log(`  Deleted ${deleted} docs from stale collection "${col}"`);
    }

    const moreQuizzes = {
        math_001: {
            chap_03: {
                chapterName: 'Triangles',
                quizzes: [{
                    id: 'quiz_tri_001',
                    title: 'Triangles & Geometry',
                    description: 'Apply Pythagorean theorem, area formulas, and triangle properties.',
                    difficulty: 'intermediate',
                    duration: 12,
                    totalQuestions: 5,
                    passingScore: 60,
                    questions: [
                        {
                            id: 'tq1', type: 'multiple-choice',
                            question: 'In a right triangle with legs 6 and 8, what is the hypotenuse?',
                            options: [
                                { id: 'a', text: '10', isCorrect: true },
                                { id: 'b', text: '14' },
                                { id: 'c', text: '12' },
                                { id: 'd', text: '100' }
                            ],
                            explanation: 'c² = a² + b² = 36 + 64 = 100 → c = 10',
                            relatedFormulas: ['formula_tri_001']
                        },
                        {
                            id: 'tq2', type: 'multiple-choice',
                            question: 'What is the area of a triangle with base 10 cm and height 6 cm?',
                            options: [
                                { id: 'a', text: '30 cm²', isCorrect: true },
                                { id: 'b', text: '60 cm²' },
                                { id: 'c', text: '15 cm²' },
                                { id: 'd', text: '16 cm²' }
                            ],
                            explanation: 'A = ½ × b × h = ½ × 10 × 6 = 30 cm²',
                            relatedFormulas: ['formula_tri_002']
                        },
                        {
                            id: 'tq3', type: 'multiple-choice',
                            question: 'What is the semi-perimeter of a triangle with sides 5, 12, 13?',
                            options: [
                                { id: 'a', text: '15', isCorrect: true },
                                { id: 'b', text: '30' },
                                { id: 'c', text: '7.5' },
                                { id: 'd', text: '20' }
                            ],
                            explanation: 's = (5+12+13)/2 = 30/2 = 15',
                            relatedFormulas: ['formula_tri_003']
                        }
                    ]
                }]
            },
            chap_05: {
                chapterName: 'Coordinate Geometry',
                quizzes: [{
                    id: 'quiz_coord_001',
                    title: 'Coordinate Geometry Practice',
                    description: 'Practice distance formula, section formula, and midpoint.',
                    difficulty: 'easy',
                    duration: 10,
                    totalQuestions: 4,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'cq1', type: 'multiple-choice',
                            question: 'Distance between (0,0) and (3,4):',
                            options: [
                                { id: 'a', text: '5', isCorrect: true },
                                { id: 'b', text: '7' },
                                { id: 'c', text: '25' },
                                { id: 'd', text: '1' }
                            ],
                            explanation: 'd = √(9+16) = √25 = 5',
                            relatedFormulas: ['formula_coord_001']
                        },
                        {
                            id: 'cq2', type: 'multiple-choice',
                            question: 'Midpoint of (0,0) and (6,8):',
                            options: [
                                { id: 'a', text: '(3,4)', isCorrect: true },
                                { id: 'b', text: '(6,8)' },
                                { id: 'c', text: '(0,0)' },
                                { id: 'd', text: '(2,4)' }
                            ],
                            explanation: 'M = ((0+6)/2, (0+8)/2) = (3,4)',
                            relatedFormulas: ['formula_coord_003']
                        }
                    ]
                }]
            },
            chap_06: {
                chapterName: 'Statistics',
                quizzes: [{
                    id: 'quiz_stat_001',
                    title: 'Statistics Fundamentals',
                    description: 'Calculate mean, median, mode, and range.',
                    difficulty: 'easy',
                    duration: 10,
                    totalQuestions: 4,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'sq1', type: 'multiple-choice',
                            question: 'Mean of 2, 4, 6, 8, 10:',
                            options: [
                                { id: 'a', text: '6', isCorrect: true },
                                { id: 'b', text: '5' },
                                { id: 'c', text: '10' },
                                { id: 'd', text: '8' }
                            ],
                            explanation: 'Mean = (2+4+6+8+10)/5 = 30/5 = 6',
                            relatedFormulas: ['formula_stat_001']
                        },
                        {
                            id: 'sq2', type: 'multiple-choice',
                            question: 'Median of 3, 7, 9, 12, 15:',
                            options: [
                                { id: 'a', text: '9', isCorrect: true },
                                { id: 'b', text: '7' },
                                { id: 'c', text: '12' },
                                { id: 'd', text: '3' }
                            ],
                            explanation: 'Sorted: 3,7,9,12,15 → n=5 → median = 3rd = 9',
                            relatedFormulas: ['formula_stat_002']
                        }
                    ]
                }]
            },
            chap_07: {
                chapterName: 'Probability',
                quizzes: [{
                    id: 'quiz_prob_001',
                    title: 'Probability Basics',
                    description: 'Master probability rules and event calculations.',
                    difficulty: 'easy',
                    duration: 8,
                    totalQuestions: 3,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'pq1', type: 'multiple-choice',
                            question: 'Probability of rolling a 4 on a fair die:',
                            options: [
                                { id: 'a', text: '1/6', isCorrect: true },
                                { id: 'b', text: '1/2' },
                                { id: 'c', text: '1/3' },
                                { id: 'd', text: '1' }
                            ],
                            explanation: 'P(4) = 1 favorable / 6 total = 1/6',
                            relatedFormulas: ['formula_prob_001']
                        },
                        {
                            id: 'pq2', type: 'multiple-choice',
                            question: 'If P(rain) = 0.3, P(no rain) = ?',
                            options: [
                                { id: 'a', text: '0.7', isCorrect: true },
                                { id: 'b', text: '0.3' },
                                { id: 'c', text: '1.0' },
                                { id: 'd', text: '0' }
                            ],
                            explanation: 'P(not E) = 1 - P(E) = 1 - 0.3 = 0.7',
                            relatedFormulas: ['formula_prob_003']
                        }
                    ]
                }]
            }
        },
        physics_001: {
            chap_03: {
                chapterName: 'Gravitation',
                quizzes: [{
                    id: 'quiz_grav_001',
                    title: 'Gravitation',
                    description: 'Universal gravitation, acceleration due to gravity, and orbital motion.',
                    difficulty: 'intermediate',
                    duration: 10,
                    totalQuestions: 3,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'gq1', type: 'multiple-choice',
                            question: 'Acceleration due to gravity on Earth surface (approx):',
                            options: [
                                { id: 'a', text: '9.8 m/s²', isCorrect: true },
                                { id: 'b', text: '8.9 m/s²' },
                                { id: 'c', text: '10.8 m/s²' },
                                { id: 'd', text: '6.7 m/s²' }
                            ],
                            explanation: 'g = GM/R² ≈ 9.8 m/s² on Earth surface',
                            relatedFormulas: ['formula_grav_001']
                        },
                        {
                            id: 'gq2', type: 'multiple-choice',
                            question: 'Weight of 70 kg person on Earth (g=9.8):',
                            options: [
                                { id: 'a', text: '686 N', isCorrect: true },
                                { id: 'b', text: '70 N' },
                                { id: 'c', text: '9.8 N' },
                                { id: 'd', text: '700 N' }
                            ],
                            explanation: 'W = mg = 70 × 9.8 = 686 N',
                            relatedFormulas: ['formula_grav_002']
                        }
                    ]
                }]
            },
            chap_04: {
                chapterName: 'Work, Energy & Power',
                quizzes: [{
                    id: 'quiz_work_001',
                    title: 'Work, Energy & Power',
                    description: 'Calculate work, kinetic energy, potential energy, and power.',
                    difficulty: 'easy',
                    duration: 10,
                    totalQuestions: 3,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'wq1', type: 'multiple-choice',
                            question: 'Work done when 10N force moves 5m in same direction:',
                            options: [
                                { id: 'a', text: '50 J', isCorrect: true },
                                { id: 'b', text: '2 J' },
                                { id: 'c', text: '15 J' },
                                { id: 'd', text: '0.5 J' }
                            ],
                            explanation: 'W = Fd cosθ = 10 × 5 × 1 = 50 J',
                            relatedFormulas: ['formula_work_001']
                        },
                        {
                            id: 'wq2', type: 'multiple-choice',
                            question: 'Kinetic energy of 2 kg mass at 3 m/s:',
                            options: [
                                { id: 'a', text: '9 J', isCorrect: true },
                                { id: 'b', text: '6 J' },
                                { id: 'c', text: '18 J' },
                                { id: 'd', text: '3 J' }
                            ],
                            explanation: 'KE = ½mv² = ½ × 2 × 9 = 9 J',
                            relatedFormulas: ['formula_work_002']
                        }
                    ]
                }]
            },
            chap_05: {
                chapterName: 'Sound',
                quizzes: [{
                    id: 'quiz_sound_001',
                    title: 'Sound Waves',
                    description: 'Speed, frequency, wavelength, and Doppler effect.',
                    difficulty: 'intermediate',
                    duration: 10,
                    totalQuestions: 3,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'sq1', type: 'multiple-choice',
                            question: 'Speed of sound = 343 m/s, frequency = 440 Hz. Wavelength = ?',
                            options: [
                                { id: 'a', text: '0.78 m', isCorrect: true },
                                { id: 'b', text: '1.28 m' },
                                { id: 'c', text: '343 m' },
                                { id: 'd', text: '440 m' }
                            ],
                            explanation: 'λ = v/f = 343/440 ≈ 0.78 m',
                            relatedFormulas: ['formula_sound_001']
                        },
                        {
                            id: 'sq2', type: 'multiple-choice',
                            question: 'Period of a wave with frequency 50 Hz:',
                            options: [
                                { id: 'a', text: '0.02 s', isCorrect: true },
                                { id: 'b', text: '50 s' },
                                { id: 'c', text: '0.2 s' },
                                { id: 'd', text: '2 s' }
                            ],
                            explanation: 'T = 1/f = 1/50 = 0.02 s',
                            relatedFormulas: ['formula_sound_002']
                        }
                    ]
                }]
            }
        },
        chemistry_001: {
            chap_02: {
                chapterName: 'Chemical Bonding',
                quizzes: [{
                    id: 'quiz_cb_001',
                    title: 'Chemical Bonding',
                    description: 'Octet rule, ionic bonds, covalent bonds, and electronegativity.',
                    difficulty: 'intermediate',
                    duration: 10,
                    totalQuestions: 3,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'cbq1', type: 'multiple-choice',
                            question: 'NaCl bond type:',
                            options: [
                                { id: 'a', text: 'Ionic', isCorrect: true },
                                { id: 'b', text: 'Covalent' },
                                { id: 'c', text: 'Metallic' },
                                { id: 'd', text: 'Hydrogen' }
                            ],
                            explanation: 'Na (metal) + Cl (non-metal) → ionic bond. ΔEN=2.1 > 1.7',
                            relatedFormulas: ['formula_cb_004']
                        },
                        {
                            id: 'cbq2', type: 'multiple-choice',
                            question: 'How many valence electrons does Oxygen need to complete octet?',
                            options: [
                                { id: 'a', text: '2', isCorrect: true },
                                { id: 'b', text: '6' },
                                { id: 'c', text: '8' },
                                { id: 'd', text: '1' }
                            ],
                            explanation: 'O has 6 valence electrons, needs 2 more to reach 8 (octet)',
                            relatedFormulas: ['formula_cb_001']
                        }
                    ]
                }]
            },
            chap_03: {
                chapterName: 'Periodic Table',
                quizzes: [{
                    id: 'quiz_pt_001',
                    title: 'Periodic Table Trends',
                    description: 'Atomic radius, ionization energy, and electronegativity trends.',
                    difficulty: 'easy',
                    duration: 8,
                    totalQuestions: 3,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'ptq1', type: 'multiple-choice',
                            question: 'Which element has the highest electronegativity?',
                            options: [
                                { id: 'a', text: 'Fluorine', isCorrect: true },
                                { id: 'b', text: 'Chlorine' },
                                { id: 'c', text: 'Oxygen' },
                                { id: 'd', text: 'Nitrogen' }
                            ],
                            explanation: 'Fluorine (4.0) is the most electronegative element.',
                            relatedFormulas: ['formula_pt_003']
                        },
                        {
                            id: 'ptq2', type: 'multiple-choice',
                            question: 'Atomic radius trend across a period:',
                            options: [
                                { id: 'a', text: 'Decreases', isCorrect: true },
                                { id: 'b', text: 'Increases' },
                                { id: 'c', text: 'Stays same' },
                                { id: 'd', text: 'Varies randomly' }
                            ],
                            explanation: 'Atomic radius decreases across a period due to increasing nuclear charge pulling electrons closer.',
                            relatedFormulas: ['formula_pt_001']
                        }
                    ]
                }]
            },
            chap_04: {
                chapterName: 'Chemical Reactions & Stoichiometry',
                quizzes: [{
                    id: 'quiz_chem_rx_001',
                    title: 'Stoichiometry Basics',
                    description: 'Moles, molar mass, and Avogadro\'s number.',
                    difficulty: 'easy',
                    duration: 8,
                    totalQuestions: 3,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'rxq1', type: 'multiple-choice',
                            question: 'How many atoms in 1 mole of Carbon?',
                            options: [
                                { id: 'a', text: '6.022 × 10²³', isCorrect: true },
                                { id: 'b', text: '12' },
                                { id: 'c', text: '6.022 × 10²²' },
                                { id: 'd', text: '12 × 10²³' }
                            ],
                            explanation: '1 mole = 6.022 × 10²³ particles (Avogadro\'s number)',
                            relatedFormulas: ['formula_chem_007']
                        },
                        {
                            id: 'rxq2', type: 'multiple-choice',
                            question: 'Molar mass of H₂O (H=1, O=16):',
                            options: [
                                { id: 'a', text: '18 g/mol', isCorrect: true },
                                { id: 'b', text: '17 g/mol' },
                                { id: 'c', text: '20 g/mol' },
                                { id: 'd', text: '16 g/mol' }
                            ],
                            explanation: 'M = 2(1) + 16 = 18 g/mol',
                            relatedFormulas: ['formula_chem_006']
                        }
                    ]
                }]
            },
            chap_05: {
                chapterName: 'Acids, Bases & Salts',
                quizzes: [{
                    id: 'quiz_acid_001',
                    title: 'Acids, Bases & pH',
                    description: 'pH scale, neutralization, and acid-base reactions.',
                    difficulty: 'easy',
                    duration: 8,
                    totalQuestions: 3,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'aq1', type: 'multiple-choice',
                            question: 'pH of [H⁺] = 10⁻³ M:',
                            options: [
                                { id: 'a', text: '3', isCorrect: true },
                                { id: 'b', text: '11' },
                                { id: 'c', text: '7' },
                                { id: 'd', text: '10⁻³' }
                            ],
                            explanation: 'pH = -log[H⁺] = -log(10⁻³) = 3',
                            relatedFormulas: ['formula_chem_011']
                        },
                        {
                            id: 'aq2', type: 'multiple-choice',
                            question: 'HCl + NaOH → NaCl + H₂O is an example of:',
                            options: [
                                { id: 'a', text: 'Neutralization', isCorrect: true },
                                { id: 'b', text: 'Oxidation' },
                                { id: 'c', text: 'Decomposition' },
                                { id: 'd', text: 'Precipitation' }
                            ],
                            explanation: 'Acid (HCl) + Base (NaOH) → Salt (NaCl) + Water (neutralization)',
                            relatedFormulas: ['formula_chem_014']
                        }
                    ]
                }]
            }
        },
        biology_001: {
            chap_01: {
                chapterName: 'Cell Biology & Genetics',
                quizzes: [{
                    id: 'quiz_bio_cell_001',
                    title: 'Cell Division & Genetics',
                    description: 'Mitosis, meiosis, cell cycle, and Mendelian genetics.',
                    difficulty: 'intermediate',
                    duration: 12,
                    totalQuestions: 4,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'bq1', type: 'multiple-choice',
                            question: 'Mitosis produces:',
                            options: [
                                { id: 'a', text: '2 identical diploid cells', isCorrect: true },
                                { id: 'b', text: '4 haploid cells' },
                                { id: 'c', text: '2 identical haploid cells' },
                                { id: 'd', text: '1 diploid cell' }
                            ],
                            explanation: 'Mitosis: 2n → 2n (two identical diploid daughter cells)',
                            relatedFormulas: ['formula_bio_004']
                        },
                        {
                            id: 'bq2', type: 'multiple-choice',
                            question: 'In Mendel\'s monohybrid cross Aa × Aa, ratio of AA:Aa:aa:',
                            options: [
                                { id: 'a', text: '1:2:1', isCorrect: true },
                                { id: 'b', text: '3:1' },
                                { id: 'c', text: '9:3:3:1' },
                                { id: 'd', text: '1:1' }
                            ],
                            explanation: 'Punnett square: AA=1, Aa=2, aa=1 → ratio 1:2:1',
                            relatedFormulas: ['formula_bio_006']
                        }
                    ]
                }]
            },
            chap_03: {
                chapterName: 'Life Processes',
                quizzes: [{
                    id: 'quiz_bio_life_001',
                    title: 'Life Processes',
                    description: 'Photosynthesis, respiration, and energy in living organisms.',
                    difficulty: 'easy',
                    duration: 8,
                    totalQuestions: 3,
                    passingScore: 50,
                    questions: [
                        {
                            id: 'lq1', type: 'multiple-choice',
                            question: 'Photosynthesis produces:',
                            options: [
                                { id: 'a', text: 'Glucose and oxygen', isCorrect: true },
                                { id: 'b', text: 'Carbon dioxide and water' },
                                { id: 'c', text: 'Glucose and water' },
                                { id: 'd', text: 'Oxygen and ATP' }
                            ],
                            explanation: '6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂ (photosynthesis)',
                            relatedFormulas: ['formula_bio_009']
                        },
                        {
                            id: 'lq2', type: 'multiple-choice',
                            question: 'Aerobic respiration produces approximately how many ATP per glucose?',
                            options: [
                                { id: 'a', text: '36-38', isCorrect: true },
                                { id: 'b', text: '2' },
                                { id: 'c', text: '4' },
                                { id: 'd', text: '100' }
                            ],
                            explanation: 'Aerobic respiration: 1 glucose → 36-38 ATP',
                            relatedFormulas: ['formula_bio_010']
                        }
                    ]
                }]
            }
        }
    };

    let totalQuizzes = 0;
    let totalQuestions = 0;

    for (const [subjectId, chapters] of Object.entries(moreQuizzes)) {
        const subjectRef = db.collection('subjects').doc(subjectId);
        for (const [chapterId, chapterData] of Object.entries(chapters)) {
            const chapterRef = subjectRef.collection('chapters').doc(chapterId);
            console.log(`\n${chapterData.chapterName}`);

            const batch = db.batch();
            for (const quiz of chapterData.quizzes) {
                const quizRef = chapterRef.collection('quizzes').doc(quiz.id);
                batch.set(quizRef, {
                    id: quiz.id, title: quiz.title, description: quiz.description,
                    difficulty: quiz.difficulty, duration: quiz.duration,
                    totalQuestions: quiz.totalQuestions, passingScore: quiz.passingScore,
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                    updatedAt: admin.firestore.FieldValue.serverTimestamp()
                });
                const questionsRef = quizRef.collection('questions');
                for (const question of quiz.questions) {
                    const qRef = questionsRef.doc(question.id);
                    batch.set(qRef, {
                        ...question,
                        createdAt: admin.firestore.FieldValue.serverTimestamp()
                    });
                    totalQuestions++;
                }
                totalQuizzes++;
                console.log(`   \u2713 ${quiz.title} (${quiz.questions.length} questions)`);
            }
            await batch.commit();
        }
    }

    console.log(`\nCleaned stale collections + seeded ${totalQuizzes} extra quizzes (${totalQuestions} questions)`);
}

seedExtraQuizzes().catch(err => {
    console.error('Failed:', err.message);
    process.exit(1);
});
