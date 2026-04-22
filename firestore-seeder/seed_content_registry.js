/**
 * Seed content registry metadata for dashboard control panel.
 *
 * Collection:
 *   dashboard_content_registry/current
 *
 * Usage:
 *   node seed_content_registry.js ../formula-scholar-firebase-adminsdk-fbsvc-8b4116cc0e.json
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

async function seedContentRegistry() {
    console.log('Seeding content registry metadata...');

    const generatedAt = new Date().toISOString();
    const items = [
        { key: 'home.hero.title', locale: 'en-IN', status: 'Published' },
        { key: 'practice.results.summary', locale: 'en-IN', status: 'Draft' },
        { key: 'formula.editor.hint', locale: 'en-IN', status: 'Published' },
        { key: 'subscription.cta.banner', locale: 'en-IN', status: 'Review' }
    ].map((item) => ({
        ...item,
        lastSyncedAt: generatedAt
    }));

    const payload = {
        generatedAt,
        datasetVersion: '2026.04.19',
        status: 'healthy',
        itemCount: items.length,
        items
    };

    await db.collection('dashboard_content_registry').doc('current').set(payload, { merge: true });
    console.log('Content registry updated ✅');
}

seedContentRegistry().catch(console.error);