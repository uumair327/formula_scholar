const path = require('path');
const admin = require('firebase-admin');

const serviceAccountPath = process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

if (!serviceAccountPath) {
    throw new Error('Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.');
}

const serviceAccount = require(path.resolve(serviceAccountPath));

if (!admin.apps.length) {
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
    });
}

const db = admin.firestore();

async function seedPracticeData() {
    console.log('Seeding Production-Level Practice & Quiz Data...\n');

    const practiceData = {
        math_001: {
            chap_01: {
                chapterName: 'Polynomials & Algebra',
                quizzes: [
                    {
                        id: 'quiz_poly_001',
                        title: 'Quadratic Equations & Factoring',
                        description: 'Master quadratic equations using formula, factoring, and completing the square.',
                        difficulty: 'intermediate',
                        duration: 15,
                        totalQuestions: 10,
                        passingScore: 70,
                        questions: [
                            {
                                id: 'pq1',
                                type: 'multiple-choice',
                                question: 'Find the roots of x² - 5x + 6 = 0',
                                options: [
                                    { id: 'a', text: 'x = 2, 3', isCorrect: true },
                                    { id: 'b', text: 'x = -2, -3' },
                                    { id: 'c', text: 'x = 1, 6' },
                                    { id: 'd', text: 'x = 2, -3' }
                                ],
                                explanation: 'Using factorization: (x-2)(x-3) = 0, so x = 2 or x = 3',
                                relatedFormulas: ['formula_poly_001']
                            },
                            {
                                id: 'pq2',
                                type: 'multiple-choice',
                                question: 'Simplify: (2x + 3)²',
                                options: [
                                    { id: 'a', text: '4x² + 12x + 9', isCorrect: true },
                                    { id: 'b', text: '4x² + 9' },
                                    { id: 'c', text: '4x² + 6x + 9' },
                                    { id: 'd', text: '2x² + 12x + 9' }
                                ],
                                explanation: 'Using (a+b)² = a² + 2ab + b²: (2x)² + 2(2x)(3) + 3² = 4x² + 12x + 9',
                                relatedFormulas: ['formula_poly_003']
                            },
                            {
                                id: 'pq3',
                                type: 'short-answer',
                                question: 'Factor: a² - b²',
                                correctAnswers: ['(a-b)(a+b)', '(a + b)(a - b)'],
                                explanation: 'Difference of squares: a² - b² = (a-b)(a+b)',
                                relatedFormulas: ['formula_poly_002']
                            },
                            {
                                id: 'pq4',
                                type: 'multiple-choice',
                                question: 'What is the discriminant of 2x² + 3x - 5 = 0?',
                                options: [
                                    { id: 'a', text: '49', isCorrect: true },
                                    { id: 'b', text: '-31' },
                                    { id: 'c', text: '9' },
                                    { id: 'd', text: '41' }
                                ],
                                explanation: 'D = b² - 4ac = 9 - 4(2)(-5) = 9 + 40 = 49',
                                relatedFormulas: ['formula_poly_001']
                            },
                            {
                                id: 'pq5',
                                type: 'multiple-choice',
                                question: 'Factor: x³ + 8',
                                options: [
                                    { id: 'a', text: '(x + 2)(x² - 2x + 4)', isCorrect: true },
                                    { id: 'b', text: '(x + 2)(x² + 2x + 4)' },
                                    { id: 'c', text: '(x + 2)(x + 2)(x + 2)' },
                                    { id: 'd', text: '(x² + 4)(x + 1)' }
                                ],
                                explanation: 'x³ + 8 = x³ + 2³ = (x+2)(x²-2x+4)',
                                relatedFormulas: ['formula_poly_004']
                            }
                        ]
                    },
                    {
                        id: 'quiz_poly_002',
                        title: 'Sum and Difference of Cubes',
                        description: 'Practice factoring sum and difference of cubes.',
                        difficulty: 'intermediate',
                        duration: 10,
                        totalQuestions: 5,
                        passingScore: 60,
                        questions: [
                            {
                                id: 'pc1',
                                type: 'multiple-choice',
                                question: 'Factor: x³ + 8',
                                options: [
                                    { id: 'a', text: '(x + 2)(x² - 2x + 4)', isCorrect: true },
                                    { id: 'b', text: '(x + 2)(x² + 2x + 4)' },
                                    { id: 'c', text: '(x + 2)(x + 2)(x + 2)' },
                                    { id: 'd', text: '(x² + 4)(x + 1)' }
                                ],
                                explanation: 'x³ + 8 = x³ + 2³ = (x+2)(x²-2x+4)',
                                relatedFormulas: ['formula_poly_004']
                            },
                            {
                                id: 'pc2',
                                type: 'multiple-choice',
                                question: 'Factor: 27 - x³',
                                options: [
                                    { id: 'a', text: '(3 - x)(9 + 3x + x²)', isCorrect: true },
                                    { id: 'b', text: '(3 - x)(9 - 3x + x²)' },
                                    { id: 'c', text: '(x - 3)(x² + 3x + 9)' },
                                    { id: 'd', text: '(27 - x)(1 + x + x²)' }
                                ],
                                explanation: '27 - x³ = 3³ - x³ = (3-x)(9+3x+x²)',
                                relatedFormulas: ['formula_poly_005']
                            },
                            {
                                id: 'pc3',
                                type: 'short-answer',
                                question: 'Expand (x + 2)³',
                                correctAnswers: ['x³ + 6x² + 12x + 8'],
                                explanation: '(a+b)³ = a³ + 3a²b + 3ab² + b³',
                                relatedFormulas: ['formula_poly_006']
                            }
                        ]
                    }
                ]
            },
            chap_02: {
                chapterName: 'Trigonometry',
                quizzes: [
                    {
                        id: 'quiz_trig_001',
                        title: 'Trigonometric Identities',
                        description: 'Prove and apply fundamental trigonometric identities.',
                        difficulty: 'hard',
                        duration: 20,
                        totalQuestions: 8,
                        passingScore: 75,
                        questions: [
                            {
                                id: 'tq1',
                                type: 'multiple-choice',
                                question: 'If sin(θ) = 3/5, what is cos²(θ)?',
                                options: [
                                    { id: 'a', text: '16/25', isCorrect: true },
                                    { id: 'b', text: '9/25' },
                                    { id: 'c', text: '6/25' },
                                    { id: 'd', text: '1/5' }
                                ],
                                explanation: 'sin²θ + cos²θ = 1 → cos²θ = 1 - (3/5)² = 16/25',
                                relatedFormulas: ['formula_trig_001']
                            },
                            {
                                id: 'tq2',
                                type: 'multiple-choice',
                                question: 'What is sin(60°)cos(30°) + cos(60°)sin(30°)?',
                                options: [
                                    { id: 'a', text: '1', isCorrect: true },
                                    { id: 'b', text: '0' },
                                    { id: 'c', text: '√3/2' },
                                    { id: 'd', text: '1/2' }
                                ],
                                explanation: 'sinAcosB + cosAsinB = sin(A+B) = sin90° = 1',
                                relatedFormulas: ['formula_trig_004']
                            }
                        ]
                    }
                ]
            },
            chap_04: {
                chapterName: 'Quadratic Equations',
                quizzes: [
                    {
                        id: 'quiz_quad_001',
                        title: 'Quadratic Equations Practice',
                        description: 'Master standard form, discriminant, and roots of quadratic equations.',
                        difficulty: 'easy',
                        duration: 10,
                        totalQuestions: 5,
                        passingScore: 60,
                        questions: [
                            {
                                id: 'qq1',
                                type: 'multiple-choice',
                                question: 'What is the standard form of a quadratic equation?',
                                options: [
                                    { id: 'a', text: 'ax² + bx + c = 0', isCorrect: true },
                                    { id: 'b', text: 'ax + b = 0' },
                                    { id: 'c', text: 'ax³ + bx² + c = 0' },
                                    { id: 'd', text: 'ax² + bx = 0' }
                                ],
                                explanation: 'Standard form is ax² + bx + c = 0 where a ≠ 0',
                                relatedFormulas: ['formula_quad_001']
                            },
                            {
                                id: 'qq2',
                                type: 'multiple-choice',
                                question: 'For x² - 7x + 12 = 0, what is the sum of roots?',
                                options: [
                                    { id: 'a', text: '7', isCorrect: true },
                                    { id: 'b', text: '-7' },
                                    { id: 'c', text: '12' },
                                    { id: 'd', text: '0' }
                                ],
                                explanation: 'Sum of roots = -b/a = -(-7)/1 = 7',
                                relatedFormulas: ['formula_quad_003']
                            }
                        ]
                    }
                ]
            }
        },
        physics_001: {
            chap_01: {
                chapterName: 'Motion & Kinematics',
                quizzes: [
                    {
                        id: 'quiz_motion_001',
                        title: 'Equations of Motion',
                        description: 'Apply kinematic equations to solve motion problems.',
                        difficulty: 'easy',
                        duration: 12,
                        totalQuestions: 6,
                        passingScore: 70,
                        questions: [
                            {
                                id: 'mq1',
                                type: 'multiple-choice',
                                question: 'An object starts from rest and accelerates at 5 m/s² for 4 seconds. What is its final velocity?',
                                options: [
                                    { id: 'a', text: '20 m/s', isCorrect: true },
                                    { id: 'b', text: '10 m/s' },
                                    { id: 'c', text: '40 m/s' },
                                    { id: 'd', text: '5 m/s' }
                                ],
                                explanation: 'Using v = u + at: v = 0 + 5(4) = 20 m/s',
                                relatedFormulas: ['formula_phys_002']
                            },
                            {
                                id: 'mq2',
                                type: 'multiple-choice',
                                question: 'What is the displacement of an object with initial velocity 10 m/s, acceleration 2 m/s², over 5 seconds?',
                                options: [
                                    { id: 'a', text: '75 m', isCorrect: true },
                                    { id: 'b', text: '50 m' },
                                    { id: 'c', text: '100 m' },
                                    { id: 'd', text: '25 m' }
                                ],
                                explanation: 's = ut + ½at² = 10(5) + ½(2)(25) = 50 + 25 = 75 m',
                                relatedFormulas: ['formula_phys_001']
                            }
                        ]
                    }
                ]
            },
            chap_02: {
                chapterName: 'Forces & Newton\'s Laws',
                quizzes: [
                    {
                        id: 'quiz_force_001',
                        title: 'Newton\'s Laws of Motion',
                        description: 'Apply Newton\'s laws to solve force and motion problems.',
                        difficulty: 'intermediate',
                        duration: 15,
                        totalQuestions: 6,
                        passingScore: 70,
                        questions: [
                            {
                                id: 'fq1',
                                type: 'multiple-choice',
                                question: 'A 5 kg object accelerates at 2 m/s². What force is applied?',
                                options: [
                                    { id: 'a', text: '10 N', isCorrect: true },
                                    { id: 'b', text: '2.5 N' },
                                    { id: 'c', text: '7 N' },
                                    { id: 'd', text: '25 N' }
                                ],
                                explanation: 'F = ma = 5 × 2 = 10 N',
                                relatedFormulas: ['formula_phys_006']
                            },
                            {
                                id: 'fq2',
                                type: 'multiple-choice',
                                question: 'What is the momentum of a 10 kg object moving at 5 m/s?',
                                options: [
                                    { id: 'a', text: '50 kg·m/s', isCorrect: true },
                                    { id: 'b', text: '2 kg·m/s' },
                                    { id: 'c', text: '15 kg·m/s' },
                                    { id: 'd', text: '5 kg·m/s' }
                                ],
                                explanation: 'p = mv = 10 × 5 = 50 kg·m/s',
                                relatedFormulas: ['formula_phys_007']
                            }
                        ]
                    }
                ]
            }
        },
        chemistry_001: {
            chap_01: {
                chapterName: 'Atomic Structure & Quantum',
                quizzes: [
                    {
                        id: 'quiz_chem_001',
                        title: 'Quantum Mechanics & Photons',
                        description: 'Understand energy, frequency, wavelength, and photons.',
                        difficulty: 'hard',
                        duration: 18,
                        totalQuestions: 7,
                        passingScore: 75,
                        questions: [
                            {
                                id: 'cq1',
                                type: 'multiple-choice',
                                question: 'Which has higher energy: red light (700nm) or violet light (400nm)?',
                                options: [
                                    { id: 'a', text: 'Violet light', isCorrect: true },
                                    { id: 'b', text: 'Red light' },
                                    { id: 'c', text: 'Both have equal energy' },
                                    { id: 'd', text: 'Cannot be determined' }
                                ],
                                explanation: 'E = hc/λ. Smaller wavelength → higher energy. Violet has shorter wavelength.',
                                relatedFormulas: ['formula_chem_001']
                            },
                            {
                                id: 'cq2',
                                type: 'multiple-choice',
                                question: 'What is the energy of the n=1 orbit in hydrogen?',
                                options: [
                                    { id: 'a', text: '-13.6 eV', isCorrect: true },
                                    { id: 'b', text: '13.6 eV' },
                                    { id: 'c', text: '-3.4 eV' },
                                    { id: 'd', text: '0 eV' }
                                ],
                                explanation: 'E_n = -13.6/n² eV. For n=1, E₁ = -13.6 eV',
                                relatedFormulas: ['formula_chem_004']
                            }
                        ]
                    }
                ]
            }
        }
    };

    let totalQuizzes = 0;
    let totalQuestions = 0;

    for (const [subjectId, chapters] of Object.entries(practiceData)) {
        const subjectRef = db.collection('subjects').doc(subjectId);

        for (const [chapterId, chapterData] of Object.entries(chapters)) {
            const chapterRef = subjectRef.collection('chapters').doc(chapterId);
            console.log(`\n${chapterData.chapterName}`);

            const batchSize = 100;
            let batch = db.batch();
            let operationCount = 0;

            for (const quiz of chapterData.quizzes) {
                const quizRef = chapterRef.collection('quizzes').doc(quiz.id);

                batch.set(quizRef, {
                    id: quiz.id,
                    title: quiz.title,
                    description: quiz.description,
                    difficulty: quiz.difficulty,
                    duration: quiz.duration,
                    totalQuestions: quiz.totalQuestions,
                    passingScore: quiz.passingScore,
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

                    operationCount++;
                    if (operationCount === batchSize) {
                        await batch.commit();
                        batch = db.batch();
                        operationCount = 0;
                    }
                }

                totalQuizzes++;
                console.log(`   \u2713 ${quiz.title} (${quiz.totalQuestions} questions)`);
            }

            if (operationCount > 0) {
                await batch.commit();
            }
        }
    }

    console.log(`\nSeeded ${totalQuizzes} quizzes with ${totalQuestions} total questions!\n`);
}

seedPracticeData().catch(err => {
    console.error('Seeding failed:', err.message);
    process.exit(1);
});
