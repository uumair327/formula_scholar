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
    console.log('Seeding dashboard_content_values/current with Maharashtra Board 10th localized strings...');

    const generatedAt = new Date().toISOString();

    const items = [];

    const localizedBundles = {
        'ar-IN': {
            'dashboard.curriculum.pending': 'للمتابعة اختر الصف العاشر من مجلس ماهاراشترا',
            'dashboard.hero.badge': 'مجلس ولاية ماهاراشترا • الصف 10',
            'dashboard.hero.badge.fallback': 'مجلس ولاية ماهاراشترا • الصف 10',
            'dashboard.hero.title': 'إتقان الصف العاشر\nلمجلس ماهاراشترا',
            'dashboard.hero.title.forTopic': 'إتقان {topic} لمجلس ماهاراشترا',
            'dashboard.hero.description': 'واصل رحلتك مع مجلس ماهاراشترا. لقد أنجزت {progress}% من الفصل الحالي.',
            'dashboard.hero.resume': 'استئناف الدرس',
            'dashboard.hero.resumeSemantic': 'استئناف التعلم',
            'dashboard.quickActions.title': 'استكشف الأدوات',
            'dashboard.quickActions.studyPlanner': 'مخطط الدراسة',
            'dashboard.quickActions.analytics': 'عرض التحليلات',
            'dashboard.quickActions.flashcards': 'بطاقات المراجعة',
            'dashboard.live': 'مباشر',
            'dashboard.boardReadyQuiz': 'اختبار جاهز لمجلس MH',
            'dashboard.quizDescription': 'تدرّب على مفاهيم الصف العاشر لمجلس ماهاراشترا.',
            'dashboard.startNow': 'ابدأ الآن',
            'dashboard.startQuiz': 'ابدأ الاختبار',
            'dashboard.academic.viewAll': 'عرض الكل',
            'dashboard.vault.description': 'جميع القوانين والملاحظات للصف العاشر من مجلس ماهاراشترا',
            'dashboard.continueStudying': 'تابع الدراسة',
            'dashboard.noRecent.title': 'لا توجد نشاطات حديثة بعد',
            'dashboard.noRecent.description': 'ابدأ من تبويب الدروس وستظهر هنا تقدمك.',
            'dashboard.openChapters': 'فتح الفصول',
        },
        'en-IN': {
            'dashboard.curriculum.pending': 'Select Maharashtra Board Class 10 to continue',
            'dashboard.hero.badge': 'Maharashtra State Board • Grade 10',
            'dashboard.hero.badge.fallback': 'Maharashtra State Board • Grade 10',
            'dashboard.hero.title': 'Mastering Maharashtra Board\nClass 10',
            'dashboard.hero.title.forTopic': 'Mastering {topic} for Maharashtra Board',
            'dashboard.hero.description': "Continue your Maharashtra Board journey. You're {progress}% through the current chapter.",
            'dashboard.hero.resume': 'Resume Lesson',
            'dashboard.hero.resumeSemantic': 'Resume learning',
            'dashboard.quickActions.title': 'Explore Tools',
            'dashboard.quickActions.studyPlanner': 'Study Planner',
            'dashboard.quickActions.analytics': 'View Analytics',
            'dashboard.quickActions.flashcards': 'Flashcards',
            'dashboard.live': 'LIVE',
            'dashboard.boardReadyQuiz': 'MH Board Ready Quiz',
            'dashboard.quizDescription': 'Practice Maharashtra Board Class 10 concepts.',
            'dashboard.startNow': 'Start Now',
            'dashboard.startQuiz': 'Start Quiz',
            'dashboard.academic.viewAll': 'View All',
            'dashboard.vault.description': 'All formulas and notes for Maharashtra Board Class 10',
            'dashboard.continueStudying': 'Continue Studying',
            'dashboard.noRecent.title': 'No recent activity yet',
            'dashboard.noRecent.description': 'Start from the chapters tab and your progress will appear here.',
            'dashboard.openChapters': 'Open Chapters',
        },
        'mr-IN': {
            'dashboard.curriculum.pending': 'सुरू ठेवण्यासाठी महाराष्ट्र बोर्ड इयत्ता 10 निवडा',
            'dashboard.hero.badge': 'महाराष्ट्र राज्य मंडळ • इयत्ता 10',
            'dashboard.hero.badge.fallback': 'महाराष्ट्र राज्य मंडळ • इयत्ता 10',
            'dashboard.hero.title': 'महाराष्ट्र बोर्डासाठी\nइयत्ता 10 मध्ये प्रभुत्व',
            'dashboard.hero.title.forTopic': 'महाराष्ट्र बोर्डासाठी {topic} मध्ये पारंगत',
            'dashboard.hero.description': 'महाराष्ट्र बोर्डमधील तुमचा प्रवास सुरू ठेवा. आपण सध्याच्या प्रकरणाचा {progress}% पूर्ण केला आहे.',
            'dashboard.hero.resume': 'पाठ पुन्हा सुरू करा',
            'dashboard.hero.resumeSemantic': 'अभ्यास पुन्हा सुरू करा',
            'dashboard.quickActions.title': 'उपकरणे शोधा',
            'dashboard.quickActions.studyPlanner': 'अभ्यास नियोजक',
            'dashboard.quickActions.analytics': 'विश्लेषण पहा',
            'dashboard.quickActions.flashcards': 'फ्लॅशकार्ड',
            'dashboard.live': 'थेट',
            'dashboard.boardReadyQuiz': 'एमएच बोर्ड रेडी क्विझ',
            'dashboard.quizDescription': 'महाराष्ट्र बोर्ड इयत्ता 10 संकल्पना सराव करा.',
            'dashboard.startNow': 'आता सुरू करा',
            'dashboard.startQuiz': 'क्विझ सुरू करा',
            'dashboard.academic.viewAll': 'सर्व पहा',
            'dashboard.vault.description': 'महाराष्ट्र बोर्ड इयत्ता 10 साठी सर्व सूत्रे आणि नोंदी',
            'dashboard.continueStudying': 'अभ्यास सुरू ठेवा',
            'dashboard.noRecent.title': 'अद्याप अलीकडील क्रिया नाही',
            'dashboard.noRecent.description': 'अध्याय टॅबमधून सुरू करा आणि तुमची प्रगती येथे दिसेल.',
            'dashboard.openChapters': 'अध्याय उघडा',
        },
        'ur-IN': {
            'dashboard.curriculum.pending': 'جاری رکھنے کے لیے مہاراشٹر بورڈ جماعت 10 منتخب کریں',
            'dashboard.hero.badge': 'مہاراشٹر اسٹیٹ بورڈ • جماعت 10',
            'dashboard.hero.badge.fallback': 'مہاراشٹر اسٹیٹ بورڈ • جماعت 10',
            'dashboard.hero.title': 'مہاراشٹر بورڈ کے لیے\nجماعت 10 میں مہارت',
            'dashboard.hero.title.forTopic': 'مہاراشٹر بورڈ کے لیے {topic} میں مہارت',
            'dashboard.hero.description': 'مہاراشٹر بورڈ کے ساتھ اپنا سفر جاری رکھیں۔ آپ موجودہ باب کا {progress}% مکمل کر چکے ہیں۔',
            'dashboard.hero.resume': 'سبق دوبارہ شروع کریں',
            'dashboard.hero.resumeSemantic': 'مطالعہ دوبارہ شروع کریں',
            'dashboard.quickActions.title': 'ٹولز دریافت کریں',
            'dashboard.quickActions.studyPlanner': 'مطالعہ منصوبہ ساز',
            'dashboard.quickActions.analytics': 'تجزیات دیکھیں',
            'dashboard.quickActions.flashcards': 'فلیش کارڈز',
            'dashboard.live': 'براہِ راست',
            'dashboard.boardReadyQuiz': 'ایم ایچ بورڈ ریڈی کوئز',
            'dashboard.quizDescription': 'مہاراشٹر بورڈ جماعت 10 کے تصورات کی مشق کریں۔',
            'dashboard.startNow': 'اب شروع کریں',
            'dashboard.startQuiz': 'کوئز شروع کریں',
            'dashboard.academic.viewAll': 'سب دیکھیں',
            'dashboard.vault.description': 'مہاراشٹر بورڈ جماعت 10 کے تمام فارمولے اور نوٹس',
            'dashboard.continueStudying': 'مطالعہ جاری رکھیں',
            'dashboard.noRecent.title': 'ابھی کوئی حالیہ سرگرمی نہیں',
            'dashboard.noRecent.description': 'ابواب کے ٹیب سے شروع کریں اور آپ کی پیش رفت یہاں نظر آئے گی۔',
            'dashboard.openChapters': 'ابواب کھولیں',
        },
    };

    const keys = [...new Set(Object.values(localizedBundles).flatMap((bundle) => Object.keys(bundle)))];

    for (const locale of Object.keys(localizedBundles)) {
        const bucket = localizedBundles[locale];
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
