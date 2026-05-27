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

    const curriculumRegistry = [
        {
            id: 'cbse_10_2024',
            board: 'CBSE',
            class: 10,
            year: 2024,
            name: 'CBSE Class 10 (2024)',
            subjects: ['math_001', 'physics_001', 'chemistry_001', 'biology_001'],
            totalChapters: 17,
            totalFormulas: 107,
            totalQuestions: 18,
            status: 'published',
            publishedAt: new Date('2026-01-15').toISOString(),
            lastUpdatedAt: new Date().toISOString(),
            coverage: {
                formulas: 107,
                quizzes: 7,
                practiceQuestions: 18
            },
            stats: {
                averageDifficulty: 'intermediate',
                estimatedCompletionHours: 60,
                activeStudents: 0
            }
        },
        {
            id: 'cbse_11_2024',
            board: 'CBSE',
            class: 11,
            year: 2024,
            name: 'CBSE Class 11 (2024)',
            subjects: ['math_001', 'physics_001', 'chemistry_001', 'biology_001'],
            totalChapters: 17,
            totalFormulas: 107,
            totalQuestions: 18,
            status: 'published',
            publishedAt: new Date('2026-02-01').toISOString(),
            lastUpdatedAt: new Date().toISOString(),
            coverage: {
                formulas: 107,
                quizzes: 7,
                practiceQuestions: 18
            },
            stats: {
                averageDifficulty: 'hard',
                estimatedCompletionHours: 75,
                activeStudents: 0
            }
        },
        {
            id: 'icse_10_2024',
            board: 'ICSE',
            class: 10,
            year: 2024,
            name: 'ICSE Class 10 (2024)',
            subjects: ['math_001', 'physics_001', 'chemistry_001'],
            totalChapters: 13,
            totalFormulas: 92,
            totalQuestions: 16,
            status: 'published',
            publishedAt: new Date('2026-01-20').toISOString(),
            lastUpdatedAt: new Date().toISOString(),
            coverage: {
                formulas: 92,
                quizzes: 5,
                practiceQuestions: 16
            },
            stats: {
                averageDifficulty: 'intermediate',
                estimatedCompletionHours: 55,
                activeStudents: 0
            }
        },
        {
            id: 'msbshse_10_2024',
            board: 'MSBSHSE',
            class: 10,
            year: 2024,
            name: 'MSBSHSE Class 10 (2024)',
            subjects: ['math_001', 'physics_001', 'chemistry_001'],
            totalChapters: 13,
            totalFormulas: 92,
            totalQuestions: 16,
            status: 'published',
            publishedAt: new Date('2026-01-15').toISOString(),
            lastUpdatedAt: new Date().toISOString(),
            coverage: {
                formulas: 92,
                quizzes: 5,
                practiceQuestions: 16
            },
            stats: {
                averageDifficulty: 'intermediate',
                estimatedCompletionHours: 55,
                activeStudents: 0
            }
        }
    ];

    const contentRegistry = [
        {
            id: 'content_math_polynomials',
            contentType: 'chapter',
            subject: 'math_001',
            chapter: 'chap_01',
            name: 'Polynomials & Algebra',
            description: 'Master polynomial operations, factoring, and quadratic equations',
            status: 'published',
            formulas: ['formula_poly_001', 'formula_poly_002', 'formula_poly_003', 'formula_poly_004', 'formula_poly_005', 'formula_poly_006', 'formula_poly_007'],
            quizzes: ['quiz_poly_001', 'quiz_poly_002'],
            metadata: {
                difficulty: 'easy-to-intermediate',
                estimatedHours: 8,
                prerequisites: [],
                targetAudiences: ['IN_cbse_8', 'IN_cbse_9', 'IN_cbse_10'],
                learningOutcomes: [
                    'Master algebraic identities and factoring techniques',
                    'Understand quadratic equations and discriminants',
                    'Apply binomial expansion formulas',
                    'Solve polynomial equations'
                ]
            },
            stats: {
                totalStudentsEnrolled: 0,
                averageCompletion: 0,
                averageScore: 0,
                lastUpdated: new Date().toISOString()
            }
        },
        {
            id: 'content_math_trigonometry',
            contentType: 'chapter',
            subject: 'math_001',
            chapter: 'chap_02',
            name: 'Trigonometry',
            description: 'Explore trigonometric functions, identities, and applications',
            status: 'published',
            formulas: ['formula_trig_001', 'formula_trig_002', 'formula_trig_003', 'formula_trig_004', 'formula_trig_005', 'formula_trig_006', 'formula_trig_007'],
            quizzes: ['quiz_trig_001'],
            metadata: {
                difficulty: 'intermediate-to-hard',
                estimatedHours: 10,
                prerequisites: ['content_math_polynomials'],
                targetAudiences: ['IN_cbse_10', 'IN_cbse_11'],
                learningOutcomes: [
                    'Apply trigonometric identities',
                    'Use Law of Sines and Law of Cosines',
                    'Solve compound and double angle problems',
                    'Understand trigonometric equations'
                ]
            },
            stats: {
                totalStudentsEnrolled: 0,
                averageCompletion: 0,
                averageScore: 0,
                lastUpdated: new Date().toISOString()
            }
        },
        {
            id: 'content_math_quadratics',
            contentType: 'chapter',
            subject: 'math_001',
            chapter: 'chap_04',
            name: 'Quadratic Equations',
            description: 'Solve and analyze quadratic equations using standard methods',
            status: 'published',
            formulas: ['formula_quad_001', 'formula_quad_002', 'formula_quad_003', 'formula_quad_004', 'formula_quad_005'],
            quizzes: ['quiz_quad_001'],
            metadata: {
                difficulty: 'easy-to-intermediate',
                estimatedHours: 6,
                prerequisites: ['content_math_polynomials'],
                targetAudiences: ['IN_cbse_10'],
                learningOutcomes: [
                    'Understand standard form of quadratic equations',
                    'Calculate and interpret discriminants',
                    'Find sum and product of roots',
                    'Form quadratic equations from given roots'
                ]
            },
            stats: {
                totalStudentsEnrolled: 0,
                averageCompletion: 0,
                averageScore: 0,
                lastUpdated: new Date().toISOString()
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
            formulas: ['formula_phys_001', 'formula_phys_002', 'formula_phys_003', 'formula_phys_004', 'formula_phys_005'],
            quizzes: ['quiz_motion_001'],
            metadata: {
                difficulty: 'easy',
                estimatedHours: 6,
                prerequisites: [],
                targetAudiences: ['IN_cbse_9', 'IN_cbse_10'],
                learningOutcomes: [
                    'Apply equations of motion under constant acceleration',
                    'Calculate displacement, velocity, and acceleration',
                    'Understand relative velocity concepts',
                    'Solve kinematics problems'
                ]
            },
            stats: {
                totalStudentsEnrolled: 0,
                averageCompletion: 0,
                averageScore: 0,
                lastUpdated: new Date().toISOString()
            }
        },
        {
            id: 'content_physics_forces',
            contentType: 'chapter',
            subject: 'physics_001',
            chapter: 'chap_02',
            name: 'Forces & Newton\'s Laws',
            description: 'Understand forces, momentum, and Newton\'s laws of motion',
            status: 'published',
            formulas: ['formula_phys_006', 'formula_phys_007', 'formula_phys_008', 'formula_phys_009', 'formula_phys_010', 'formula_phys_011'],
            quizzes: ['quiz_force_001'],
            metadata: {
                difficulty: 'intermediate',
                estimatedHours: 8,
                prerequisites: ['content_physics_motion'],
                targetAudiences: ['IN_cbse_9', 'IN_cbse_11'],
                learningOutcomes: [
                    'Apply Newton\'s second law',
                    'Calculate momentum and impulse',
                    'Understand conservation of momentum',
                    'Solve friction and gravitation problems'
                ]
            },
            stats: {
                totalStudentsEnrolled: 0,
                averageCompletion: 0,
                averageScore: 0,
                lastUpdated: new Date().toISOString()
            }
        },
        {
            id: 'content_chemistry_atomic',
            contentType: 'chapter',
            subject: 'chemistry_001',
            chapter: 'chap_01',
            name: 'Atomic Structure & Quantum',
            description: 'Explore atomic models, quantum mechanics, and photon energy',
            status: 'published',
            formulas: ['formula_chem_001', 'formula_chem_002', 'formula_chem_003', 'formula_chem_004', 'formula_chem_005'],
            quizzes: ['quiz_chem_001'],
            metadata: {
                difficulty: 'hard',
                estimatedHours: 10,
                prerequisites: [],
                targetAudiences: ['IN_cbse_11', 'IN_cbse_12'],
                learningOutcomes: [
                    'Calculate photon energy using Planck\'s relation',
                    'Apply de Broglie wavelength concept',
                    'Understand Bohr\'s atomic model and energy levels',
                    'Use Rydberg formula for spectral lines'
                ]
            },
            stats: {
                totalStudentsEnrolled: 0,
                averageCompletion: 0,
                averageScore: 0,
                lastUpdated: new Date().toISOString()
            }
        },
        {
            id: 'content_chemistry_stoichiometry',
            contentType: 'chapter',
            subject: 'chemistry_001',
            chapter: 'chap_04',
            name: 'Chemical Reactions & Stoichiometry',
            description: 'Master moles, molar mass, gas laws, and solution concentration',
            status: 'published',
            formulas: ['formula_chem_006', 'formula_chem_007', 'formula_chem_008', 'formula_chem_009', 'formula_chem_010'],
            quizzes: [],
            metadata: {
                difficulty: 'intermediate',
                estimatedHours: 8,
                prerequisites: ['content_chemistry_atomic'],
                targetAudiences: ['IN_cbse_9', 'IN_cbse_10', 'IN_cbse_11'],
                learningOutcomes: [
                    'Calculate molar mass and number of moles',
                    'Apply Avogadro\'s law',
                    'Use ideal gas law for gas problems',
                    'Determine solution concentration'
                ]
            },
            stats: {
                totalStudentsEnrolled: 0,
                averageCompletion: 0,
                averageScore: 0,
                lastUpdated: new Date().toISOString()
            }
        }
    ];

    const generatedAt = new Date().toISOString();
    const datasetVersion = '2026.05.07';

    console.log('Writing Curriculum Registry...');

    const curriculumNodes = [
        { key: 'countries', label: 'Countries', collectionPath: 'countries', nodeCount: 1, status: 'active', writeEnabled: true, lastSyncedAt: generatedAt },
        { key: 'states', label: 'States/UTs', collectionPath: 'countries/{countryId}/states', nodeCount: 36, status: 'active', writeEnabled: true, lastSyncedAt: generatedAt },
        { key: 'boards', label: 'Boards', collectionPath: 'boards', nodeCount: 9, status: 'active', writeEnabled: true, lastSyncedAt: generatedAt },
        { key: 'grades', label: 'Grades / Classes', collectionPath: 'boards/{boardId}/classes', nodeCount: 27, status: 'active', writeEnabled: true, lastSyncedAt: generatedAt },
        { key: 'subjects', label: 'Subjects', collectionPath: 'subjects', nodeCount: 4, status: 'active', writeEnabled: true, lastSyncedAt: generatedAt },
        { key: 'chapters', label: 'Chapters', collectionPath: 'subjects/{subjectId}/chapters', nodeCount: 17, status: 'active', writeEnabled: true, lastSyncedAt: generatedAt },
        { key: 'formulas', label: 'Formulas', collectionPath: 'subjects/{subjectId}/chapters/{chapterId}/formulas', nodeCount: 107, status: 'active', writeEnabled: true, lastSyncedAt: generatedAt },
        { key: 'mastery-tools', label: 'Mastery Tools', collectionPath: 'subjects/{subjectId}/mastery_tools', nodeCount: 4, status: 'active', writeEnabled: true, lastSyncedAt: generatedAt },
        { key: 'practice-questions', label: 'Practice Questions', collectionPath: 'practice_questions', nodeCount: 20, status: 'active', writeEnabled: true, lastSyncedAt: generatedAt },
        { key: 'saved-notes', label: 'Saved Notes', collectionPath: 'saved_notes', nodeCount: 0, status: 'active', writeEnabled: true, lastSyncedAt: generatedAt }
    ];

    const curriculumPayload = {
        generatedAt,
        datasetVersion,
        status: 'healthy',
        nodeCount: curriculumNodes.length,
        nodes: curriculumNodes
    };

    await db.collection('dashboard_curriculum_registry').doc('current').set(curriculumPayload, { merge: true });
    console.log(`   Curriculum registry updated (${curriculumNodes.length} nodes)\n`);

    console.log('Writing Content Registry...');

    const baseContentItems = [
        { key: 'home.hero.title', status: 'Published' },
        { key: 'practice.results.summary', status: 'Draft' },
        { key: 'formula.editor.hint', status: 'Published' },
        { key: 'subscription.cta.banner', status: 'Review' },
        { key: 'curriculum.cbse.10', status: 'Published' },
        { key: 'curriculum.cbse.11', status: 'Published' },
        { key: 'curriculum.msbshse.10', status: 'Published' },
        { key: 'governance.audit.enabled', status: 'Published' }
    ];

    const supportedLocales = ['en-IN', 'ur-IN', 'mr-IN'];
    const contentItems = [];

    for (const item of baseContentItems) {
        for (const locale of supportedLocales) {
            contentItems.push({
                key: item.key,
                locale,
                status: item.status,
                lastSyncedAt: generatedAt
            });
        }
    }

    const contentPayload = {
        generatedAt,
        datasetVersion,
        status: 'healthy',
        itemCount: contentItems.length,
        items: contentItems
    };

    await db.collection('dashboard_content_registry').doc('current').set(contentPayload, { merge: true });
    console.log(`   Content registry updated (${contentItems.length} items)\n`);

    console.log('Curriculum & Content Registry seeding complete!\n');
}

// Run seeder
seedRegistry().catch(err => {
    console.error('❌ Seeding failed:', err.message);
    process.exit(1);
});
