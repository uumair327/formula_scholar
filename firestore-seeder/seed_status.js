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
        datasetVersion: '2026.04.19',
        pipeline: 'seed_all -> populate_firestore -> populate_msbshse',
        collections: [
            'countries',
            'boards',
            'subjects',
            'practice_questions',
            'users',
            'dashboard_governance_audit',
            'dashboard_seed_status'
        ]
    };

    await db.collection('dashboard_seed_status').doc('current').set(payload, { merge: true });
    console.log('Seed status updated ✅');
}

seedStatus().catch(console.error);
