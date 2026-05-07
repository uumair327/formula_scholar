/**
 * Seed dashboard sync status metadata.
 *
 * Collection:
 *   dashboard_seed_status/current
 *
 * Usage:
 *   node seed_status.js ../formula-scholar-firebase-adminsdk-fbsvc-8b4116cc0e.json
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

async function seedStatus() {
    console.log('Seeding dashboard seed status...');

    const payload = {
        status: 'healthy',
        lastSeededAt: new Date().toISOString(),
        datasetVersion: '2026.05.07',
        pipeline: 'seed.js → seed_subjects.js → seed_formulas_enhanced.js → seed_practice_enhanced.js → seed_registry_enhanced.js → seed_status.js',
        collections: [
            'countries',
            'boards',
            'subjects',
            'practice_questions',
            'dashboard_curriculum_registry',
            'dashboard_content_registry',
            'dashboard_seed_status'
        ]
    };

    await db.collection('dashboard_seed_status').doc('current').set(payload, { merge: true });
    console.log('Seed status updated ✅');
}

seedStatus().catch(console.error);
