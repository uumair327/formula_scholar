/**
 * Enhanced Practice & Quiz Data Seeder
 * Seeds comprehensive practice questions, quizzes, and assessments
 */

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
    console.log('📝 Seeding Production-Level Practice & Quiz Data...\n');

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
                        duration: 15, // minutes
                        totalQuestions: 10,
                        passingScore: 70,
                        questions: [
                            {
                                id: 'q1',
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
                                id: 'q2',
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
                                id: 'q3',
                                type: 'short-answer',
                                question: 'Factor: a² - b²',
                                correctAnswers: ['(a-b)(a+b)', '(a + b)(a - b)'],
                                explanation: 'Difference of squares: a² - b² = (a-b)(a+b)',
                                relatedFormulas: ['formula_poly_002']
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
                                id: 'q1',
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
                                id: 'q1',
                                type: 'multiple-choice',
                                question: 'If sin(θ) = 3/5, what is cos²(θ)?',
                                options: [
                                    { id: 'a', text: '16/25', isCorrect: true },
                                    { id: 'b', text: '9/25' },
                                    { id: 'c', text: '6/25' },
                                    { id: 'd', text: '1/5' }
                                ],
                                explanation: 'sin²θ + cos²θ = 1 → cos²θ = 1 - (3/5)² = 1 - 9/25 = 16/25',
                                relatedFormulas: ['formula_trig_001']
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
                                id: 'q1',
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
                                id: 'q2',
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
            }
        },
        chemistry_001: {
            chap_01: {
                chapterName: 'Atomic Structure & Periodic Table',
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
                                id: 'q1',
                                type: 'multiple-choice',
                                question: 'Which has higher energy: red light (700nm) or violet light (400nm)?',
                                options: [
                                    { id: 'a', text: 'Violet light', isCorrect: true },
                                    { id: 'b', text: 'Red light' },
                                    { id: 'c', text: 'Both have equal energy' },
                                    { id: 'd', text: 'Cannot be determined' }
                                ],
                                explanation: 'E = hc/λ. Smaller wavelength → higher frequency → higher energy. Violet (400nm) < Red (700nm)',
                                relatedFormulas: ['formula_chem_001']
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
            console.log(`\n📖 ${chapterData.chapterName}`);

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

                // Store questions in nested collection
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
                console.log(`   ✓ ${quiz.title} (${quiz.totalQuestions} questions)`);
            }

            if (operationCount > 0) {
                await batch.commit();
            }
        }
    }

    console.log(`\n✅ Seeded ${totalQuizzes} quizzes with ${totalQuestions} total questions!\n`);
}

// Run seeder
seedPracticeData().catch(err => {
    console.error('❌ Seeding failed:', err.message);
    process.exit(1);
});
