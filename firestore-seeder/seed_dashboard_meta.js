/**
 * Seed dashboard metadata collections.
 *
 * Collections:
 *   dashboard_governance_audit
 *   moderator_applications
 *   practice_settings/global
 *   runtime_settings/global
 *   module_registry/current
 *   dashboard_commands
 *
 * Usage:
 *   node seed_dashboard_meta.js <path-to-service-account.json>
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

async function seedDashboardMeta() {
    console.log('Seeding dashboard metadata collections...\n');

    // 1. practice_settings/global
    console.log('  → practice_settings/global');
    await db.collection('practice_settings').doc('global').set({
        adaptiveMode: true,
        timedMode: false,
        maxDailyAttempts: 30,
        questionsPerSession: 10,
        difficultyProgression: 'adaptive',
        showExplanations: true,
        requireLogin: false
    }, { merge: true });

    // 2. runtime_settings/global
    console.log('  → runtime_settings/global');
    await db.collection('runtime_settings').doc('global').set({
        maintenanceMode: false,
        registrationOpen: true,
        backgroundSyncEnabled: true,
        minSupportedBuild: '2.4.0',
        releaseChannel: 'stable'
    }, { merge: true });

    // 3. module_registry/current
    console.log('  → module_registry/current');
    await db.collection('module_registry').doc('current').set({
        modules: [
            { key: 'auth', label: 'Auth', enabled: true, mode: 'read-write', lastSync: new Date().toLocaleTimeString() },
            { key: 'onboarding', label: 'Onboarding', enabled: true, mode: 'read-write', lastSync: new Date().toLocaleTimeString() },
            { key: 'dashboard', label: 'Dashboard', enabled: true, mode: 'read-write', lastSync: new Date().toLocaleTimeString() },
            { key: 'chapters', label: 'Chapters', enabled: true, mode: 'read-write', lastSync: new Date().toLocaleTimeString() },
            { key: 'practice', label: 'Practice', enabled: true, mode: 'read-write', lastSync: new Date().toLocaleTimeString() },
            { key: 'profile', label: 'Profile', enabled: true, mode: 'read-write', lastSync: new Date().toLocaleTimeString() },
            { key: 'saved', label: 'Saved', enabled: true, mode: 'read-write', lastSync: new Date().toLocaleTimeString() }
        ]
    }, { merge: true });

    // 4. dashboard_governance_audit (seed a startup event)
    console.log('  → dashboard_governance_audit');
    await db.collection('dashboard_governance_audit').add({
        action: 'System initialized',
        role: 'SUPER_ADMIN',
        outcome: 'executed',
        reason: 'Dashboard metadata seeded via seed_dashboard_meta.js',
        ticket: 'SEED-001',
        approver: 'system',
        timestamp: new Date().toISOString()
    });

    // 5. moderator_applications (empty — created by users)
    console.log('  → moderator_applications (no seed data — created via user flow)');

    // 6. dashboard_commands (empty — created by admin actions)
    console.log('  → dashboard_commands (no seed data — created via command execution)\n');

    console.log('Dashboard metadata seeding complete ✅');
}

seedDashboardMeta().catch(console.error);
