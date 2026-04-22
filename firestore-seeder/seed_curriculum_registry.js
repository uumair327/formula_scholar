/**
 * Seed curriculum registry metadata for dashboard control panel.
 *
 * Collection:
 *   dashboard_curriculum_registry/current
 *
 * Usage:
 *   node seed_curriculum_registry.js ../formula-scholar-firebase-adminsdk-fbsvc-8b4116cc0e.json
 */

const path = require('path');
const admin = require('firebase-admin');

const serviceAccountPath = process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

if (!serviceAccountPath) {
    throw new Error(
        'Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.'
    );
}

const serviceAccount = require(path.resolve(serviceAccountPath));

if (!admin.apps.length) {
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
    });
}

const db = admin.firestore();

async function countTopLevel(collectionName) {
    const snap = await db.collection(collectionName).get();
    return snap.size;
}

async function countStates() {
    const countriesSnap = await db.collection('countries').get();
    let total = 0;
    for (const countryDoc of countriesSnap.docs) {
        const statesSnap = await countryDoc.ref.collection('states').get();
        total += statesSnap.size;
    }
    return total;
}

async function countCollectionGroup(groupName) {
    const snap = await db.collectionGroup(groupName).get();
    return snap.size;
}

async function seedCurriculumRegistry() {
    console.log('Seeding curriculum registry metadata...');

    const [
        countriesCount,
        boardsCount,
        classesCount,
        legacyGradesCount,
        subjectsCount,
        practiceCount,
        notesCount,
        chaptersCount,
        formulasCount,
        masteryToolsCount,
        statesCount
    ] = await Promise.all([
        countTopLevel('countries'),
        countTopLevel('boards'),
        countCollectionGroup('classes'),
        countCollectionGroup('grades'),
        countTopLevel('subjects'),
        countTopLevel('practice_questions'),
        countTopLevel('saved_notes'),
        countCollectionGroup('chapters'),
        countCollectionGroup('formulas'),
        countCollectionGroup('mastery_tools'),
        countStates()
    ]);
    const gradesCount = Math.max(classesCount, legacyGradesCount);

    const generatedAt = new Date().toISOString();
    const nodes = [
        { key: 'countries', label: 'Countries', collectionPath: 'countries', nodeCount: countriesCount },
        { key: 'states', label: 'States', collectionPath: 'countries/{countryId}/states', nodeCount: statesCount },
        { key: 'boards', label: 'Boards', collectionPath: 'boards', nodeCount: boardsCount },
        { key: 'grades', label: 'Grades / Classes', collectionPath: 'boards/{boardId}/classes', nodeCount: gradesCount },
        { key: 'subjects', label: 'Subjects', collectionPath: 'subjects', nodeCount: subjectsCount },
        { key: 'chapters', label: 'Chapters', collectionPath: 'subjects/{subjectId}/chapters', nodeCount: chaptersCount },
        { key: 'formulas', label: 'Formulas', collectionPath: 'subjects/{subjectId}/chapters/{chapterId}/formulas', nodeCount: formulasCount },
        { key: 'mastery-tools', label: 'Mastery Tools', collectionPath: 'subjects/{subjectId}/mastery_tools', nodeCount: masteryToolsCount },
        { key: 'practice-questions', label: 'Practice Questions', collectionPath: 'practice_questions', nodeCount: practiceCount },
        { key: 'saved-notes', label: 'Saved Notes', collectionPath: 'saved_notes', nodeCount: notesCount }
    ].map((node) => ({
        ...node,
        status: 'active',
        writeEnabled: true,
        lastSyncedAt: generatedAt
    }));

    const payload = {
        generatedAt,
        datasetVersion: '2026.04.19',
        status: 'healthy',
        nodeCount: nodes.length,
        nodes
    };

    await db.collection('dashboard_curriculum_registry').doc('current').set(payload, { merge: true });
    console.log('Curriculum registry updated ✅');
}

seedCurriculumRegistry().catch(console.error);
