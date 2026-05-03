/**
 * Enhanced Curriculum & Content Registry Seeder
 * Seeds metadata for dashboard curriculum control and content management
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

async function seedRegistry() {
    console.log('📊 Seeding Curriculum & Content Registry...\n');

    // Curriculum Registry - tracks curriculum-level aggregates
    const curriculumRegistry = [
        {
            id: 'cbse_10_2024',
            board: 'CBSE',
            class: 10,
            year: 2024,
            name: 'CBSE Class 10 (2024)',
            subjects: ['math_001', 'physics_001', 'chemistry_001', 'biology_001'],
            totalChapters: 15,
            totalFormulas: 85,
            totalQuestions: 120,
            status: 'published',
            publishedAt: new Date('2024-01-15').toISOString(),
            lastUpdatedAt: new Date('2024-05-01').toISOString(),
            coverage: {
                formulas: 85,
                quizzes: 12,
                practiceQuestions: 120
            },
            stats: {
                averageDifficulty: 'intermediate',
                estimatedCompletionHours: 45,
                activeStudents: 1250
            }
        },
        {
            id: 'cbse_11_2024',
            board: 'CBSE',
            class: 11,
            year: 2024,
            name: 'CBSE Class 11 (2024)',
            subjects: ['math_001', 'physics_001', 'chemistry_001', 'biology_001'],
            totalChapters: 18,
            totalFormulas: 120,
            totalQuestions: 180,
            status: 'published',
            publishedAt: new Date('2024-02-01').toISOString(),
            lastUpdatedAt: new Date('2024-05-02').toISOString(),
            coverage: {
                formulas: 120,
                quizzes: 18,
                practiceQuestions: 180
            },
            stats: {
                averageDifficulty: 'hard',
                estimatedCompletionHours: 60,
                activeStudents: 980
            }
        },
        {
            id: 'icse_10_2024',
            board: 'ICSE',
            class: 10,
            year: 2024,
            name: 'ICSE Class 10 (2024)',
            subjects: ['math_001', 'physics_001', 'chemistry_001'],
            totalChapters: 14,
            totalFormulas: 75,
            totalQuestions: 100,
            status: 'published',
            publishedAt: new Date('2024-01-20').toISOString(),
            lastUpdatedAt: new Date('2024-04-28').toISOString(),
            coverage: {
                formulas: 75,
                quizzes: 11,
                practiceQuestions: 100
            },
            stats: {
                averageDifficulty: 'intermediate',
                estimatedCompletionHours: 40,
                activeStudents: 620
            }
        }
    ];

    // Content Registry - tracks content-level metadata
    const contentRegistry = [
        {
            id: 'content_math_polynomials',
            contentType: 'chapter',
            subject: 'math_001',
            chapter: 'chap_01',
            name: 'Polynomials & Algebra',
            description: 'Master polynomial operations, factoring, and quadratic equations',
            status: 'published',
            formulas: ['formula_poly_001', 'formula_poly_002', 'formula_poly_003', 'formula_poly_004'],
            quizzes: ['quiz_poly_001', 'quiz_poly_002'],
            metadata: {
                difficulty: 'easy-to-intermediate',
                estimatedHours: 8,
                prerequisites: [],
                targetAudiences: ['IN_cbse_8', 'IN_cbse_9', 'IN_cbse_10'],
                learningOutcomes: [
                    'Understand polynomial operations',
                    'Master factoring techniques',
                    'Solve quadratic equations using multiple methods',
                    'Apply algebra to real-world problems'
                ]
            },
            stats: {
                totalStudentsEnrolled: 5200,
                averageCompletion: 82,
                averageScore: 76,
                lastUpdated: new Date('2024-04-30').toISOString()
            }
        },
        {
            id: 'content_trig_identities',
            contentType: 'chapter',
            subject: 'math_001',
            chapter: 'chap_02',
            name: 'Trigonometry',
            description: 'Explore trigonometric functions, identities, and applications',
            status: 'published',
            formulas: ['formula_trig_001', 'formula_trig_002', 'formula_trig_003'],
            quizzes: ['quiz_trig_001'],
            metadata: {
                difficulty: 'intermediate-to-hard',
                estimatedHours: 10,
                prerequisites: ['content_math_polynomials'],
                targetAudiences: ['IN_cbse_10', 'IN_cbse_11', 'IN_icse_10'],
                learningOutcomes: [
                    'Understand trigonometric ratios',
                    'Apply trigonometric identities',
                    'Solve trigonometric equations',
                    'Use trigonometry in real-world applications'
                ]
            },
            stats: {
                totalStudentsEnrolled: 3800,
                averageCompletion: 78,
                averageScore: 72,
                lastUpdated: new Date('2024-04-25').toISOString()
            }
        },
        {
            id: 'content_physics_motion',
            contentType: 'chapter',
            subject: 'physics_001',
            chapter: 'chap_01',
            name: 'Motion & Kinematics',
            description: 'Master equations of motion, velocity, and acceleration',
            status: 'published',
            formulas: ['formula_phys_001', 'formula_phys_002', 'formula_phys_003'],
            quizzes: ['quiz_motion_001'],
            metadata: {
                difficulty: 'easy',
                estimatedHours: 6,
                prerequisites: [],
                targetAudiences: ['IN_cbse_9', 'IN_cbse_10'],
                learningOutcomes: [
                    'Understand kinematics concepts',
                    'Apply equations of motion',
                    'Solve kinematics problems',
                    'Understand motion graphs'
                ]
            },
            stats: {
                totalStudentsEnrolled: 6100,
                averageCompletion: 85,
                averageScore: 79,
                lastUpdated: new Date('2024-04-28').toISOString()
            }
        }
    ];

    // Batch write curriculum registry
    console.log('📚 Writing Curriculum Registry...');
    const curriculumBatch = db.batch();
    let operationCount = 0;

    for (const curriculum of curriculumRegistry) {
        const curriculumRef = db.collection('curriculumRegistry').doc(curriculum.id);
        curriculumBatch.set(curriculumRef, {
            ...curriculum,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
        });

        operationCount++;
        console.log(`   ✓ ${curriculum.name} (${curriculum.totalChapters} chapters, ${curriculum.totalFormulas} formulas)`);
    }

    await curriculumBatch.commit();
    console.log(`✅ Seeded ${curriculumRegistry.length} curriculum entries\n`);

    // Batch write content registry
    console.log('📋 Writing Content Registry...');
    const contentBatch = db.batch();
    operationCount = 0;

    for (const content of contentRegistry) {
        const contentRef = db.collection('contentRegistry').doc(content.id);
        contentBatch.set(contentRef, {
            ...content,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
        });

        operationCount++;
        console.log(
            `   ✓ ${content.name} (${content.formulas.length} formulas, ${content.quizzes.length} quizzes, ${content.stats.totalStudentsEnrolled} students)`
        );
    }

    await contentBatch.commit();
    console.log(`✅ Seeded ${contentRegistry.length} content entries\n`);

    // Create index documents for quick lookups
    console.log('🔍 Creating lookup indexes...');
    const indexBatch = db.batch();

    // Subject index
    const subjectIndexRef = db.collection('indexes').doc('subjects');
    const subjectIndex = {};
    for (const content of contentRegistry) {
        if (!subjectIndex[content.subject]) {
            subjectIndex[content.subject] = { chapters: [], count: 0 };
        }
        if (!subjectIndex[content.subject].chapters.includes(content.chapter)) {
            subjectIndex[content.subject].chapters.push(content.chapter);
            subjectIndex[content.subject].count++;
        }
    }
    indexBatch.set(subjectIndexRef, { subjects: subjectIndex });

    // Board index
    const boardIndexRef = db.collection('indexes').doc('boards');
    const boardIndex = {};
    for (const curriculum of curriculumRegistry) {
        if (!boardIndex[curriculum.board]) {
            boardIndex[curriculum.board] = { curricula: [], totalFormulas: 0 };
        }
        boardIndex[curriculum.board].curricula.push(curriculum.id);
        boardIndex[curriculum.board].totalFormulas += curriculum.totalFormulas;
    }
    indexBatch.set(boardIndexRef, { boards: boardIndex });

    await indexBatch.commit();
    console.log(`✅ Created lookup indexes\n`);

    console.log(`✅ Curriculum & Content Registry seeding complete!\n`);
}

// Run seeder
seedRegistry().catch(err => {
    console.error('❌ Seeding failed:', err.message);
    process.exit(1);
});
