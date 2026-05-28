/**
 * Seed dashboard_content_values/current document with localized content values
 * Usage:
 *   node seed_dashboard_content_values.js <path-to-service-account.json>
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

async function seedContentValues() {
    console.log('Seeding dashboard_content_values/current with localized strings...');

    const generatedAt = new Date().toISOString();

    const items = [];

    const keys = [
        'dashboard.hero.badge',
        'dashboard.hero.title',
        'dashboard.hero.description',
        'dashboard.hero.resume',
        'dashboard.hero.resumeSemantic',
        'dashboard.quickActions.title',
        'dashboard.quickActions.studyPlanner',
        'dashboard.quickActions.analytics',
        'dashboard.quickActions.flashcards'
    ];

    const values = {
        'en-IN': {
            'dashboard.hero.badge': 'CBSE Syllabus • Grade 9',
            'dashboard.hero.title': 'Mastering Motion &\\nLaws of Forces',
            'dashboard.hero.description': "Continue your journey through Physics. You're {progress}% through the current chapter.",
            'dashboard.hero.resume': 'Resume Lesson',
            'dashboard.hero.resumeSemantic': 'Resume learning',
            'dashboard.quickActions.title': 'Explore Tools',
            'dashboard.quickActions.studyPlanner': 'Study Planner',
            'dashboard.quickActions.analytics': 'View Analytics',
            'dashboard.quickActions.flashcards': 'Flashcards'
        },
        'ur-IN': {
            'dashboard.hero.badge': 'CBSE نصاب • جماعت 9',
            'dashboard.hero.title': 'حرکت اور\\nقوانینِ قوت میں مہارت',
            'dashboard.hero.description': 'فزکس میں اپنا سفر جاری رکھیں۔ آپ اس باب کا {progress}% مکمل کر چکے ہیں۔',
            'dashboard.hero.resume': 'سبق دوبارہ شروع کریں',
            'dashboard.hero.resumeSemantic': 'مطالعہ دوبارہ شروع کریں',
            'dashboard.quickActions.title': 'ٹولز دریافت کریں',
            'dashboard.quickActions.studyPlanner': 'مطالعہ منصوبہ ساز',
            'dashboard.quickActions.analytics': 'تجزیات دیکھیں',
            'dashboard.quickActions.flashcards': 'فلیش کارڈز'
        },
        'mr-IN': {
            'dashboard.hero.badge': 'CBSE अभ्यासक्रम • इयत्ता 9',
            'dashboard.hero.title': 'गती आणि बलाच्या नियमांमध्ये पारंगत',
            'dashboard.hero.description': 'भौतिकशास्त्रामध्ये आपला प्रवास सुरू ठेवा. आपण सध्याच्या प्रकरणाचा {progress}% पूर्ण केला आहे.',
            'dashboard.hero.resume': 'पाठ पुन्हा सुरू करा',
            'dashboard.hero.resumeSemantic': 'अभ्यास पुन्हा सुरू करा',
            'dashboard.quickActions.title': 'उपकरणे शोधा',
            'dashboard.quickActions.studyPlanner': 'अभ्यास नियोजक',
            'dashboard.quickActions.analytics': 'विश्लेषण पहा',
            'dashboard.quickActions.flashcards': 'फ्लॅशकार्ड'
        }
    };

    for (const locale of Object.keys(values)) {
        const bucket = values[locale];
        for (const key of keys) {
            items.push({
                key,
                locale,
                value: bucket[key] || '',
                status: 'Published',
                lastSyncedAt: generatedAt
            });
        }
    }

    const payload = {
        generatedAt,
        status: 'healthy',
        itemCount: items.length,
        items
    };

    await db.collection('dashboard_content_values').doc('current').set(payload, { merge: true });

    console.log(`Wrote ${items.length} localized content items to dashboard_content_values/current`);
}

seedContentValues().catch(err => {
    console.error(err);
    process.exit(1);
});
