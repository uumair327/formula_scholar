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
        'dashboard.quickActions.flashcards',
        // Additional dashboard strings
        'dashboard.live',
        'dashboard.boardReadyQuiz',
        'dashboard.quizDescription',
        'dashboard.startNow',
        'dashboard.startQuiz',
        'dashboard.academic.viewAll',
        'dashboard.vault.description'
        ,
        // Continue studying / no recent
        'dashboard.continueStudying',
        'dashboard.noRecent.title',
        'dashboard.noRecent.description',
        'dashboard.openChapters'
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
            'dashboard.quickActions.flashcards': 'Flashcards',
            'dashboard.live': 'LIVE',
            'dashboard.boardReadyQuiz': 'Board Ready Quiz',
            'dashboard.quizDescription': 'Test your knowledge on CBSE Chapter 2.',
            'dashboard.startNow': 'Start Now',
            'dashboard.startQuiz': 'Start quiz',
            'dashboard.academic.viewAll': 'View All',
            'dashboard.vault.description': '42 saved items across 4 subjects'
            ,
            'dashboard.continueStudying': 'Continue Studying',
            'dashboard.noRecent.title': 'No recent activity yet',
            'dashboard.noRecent.description': 'Start learning from the chapters tab and your recent progress will appear here.',
            'dashboard.openChapters': 'Open Chapters'
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
            'dashboard.quickActions.flashcards': 'فلیش کارڈز',
            'dashboard.live': 'LIVE',
            'dashboard.boardReadyQuiz': 'بورڈ ریڈی کوئز',
            'dashboard.quizDescription': 'CBSE باب 2 میں اپنی معلومات کی جانچ کریں۔',
            'dashboard.startNow': 'اب شروع کریں',
            'dashboard.startQuiz': 'کوئز شروع کریں',
            'dashboard.academic.viewAll': 'سب دیکھیں',
            'dashboard.vault.description': '4 مضامین میں 42 محفوظ آئٹمز'
            ,
            'dashboard.continueStudying': 'مطالعہ جاری رکھیں',
            'dashboard.noRecent.title': 'ابھی کوئی حالیہ سرگرمی نہیں',
            'dashboard.noRecent.description': 'چپٹر ٹیب سے مطالعہ شروع کریں اور آپ کی حالیہ پیشرفت یہاں نظر آئے گی۔',
            'dashboard.openChapters': 'چیپٹر کھولیں'
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
            'dashboard.quickActions.flashcards': 'फ्लॅशकार्ड',
            'dashboard.live': 'LIVE',
            'dashboard.boardReadyQuiz': 'बोर्ड रेडी क्विझ',
            'dashboard.quizDescription': 'CBSE अध्याय 2 वरील आपले ज्ञान तपासा.',
            'dashboard.startNow': 'आता सुरू करा',
            'dashboard.startQuiz': 'क्विझ सुरू करा',
            'dashboard.academic.viewAll': 'सर्व पहा',
            'dashboard.vault.description': '4 विषयांमध्ये 42 जतन केलेल्या आयटम्स'
            ,
            'dashboard.continueStudying': 'अभ्यास सुरू ठेवा',
            'dashboard.noRecent.title': 'अद्याप कोणतीही अलीकडील क्रिये नाही',
            'dashboard.noRecent.description': 'अध्याय टॅबमधून शिका आणि तुमची अलीकडील प्रगती येथे दिसेल.',
            'dashboard.openChapters': 'अध्याय उघडा'
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
