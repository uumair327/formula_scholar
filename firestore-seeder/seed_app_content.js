/**
 * Seed app content collections for dashboard management.
 *
 * Collections:
 *   app_banners
 *   forum_posts
 *   video_tutorials
 *   canonical_chapters
 *   canonical_formulas
 *
 * Usage:
 *   node seed_app_content.js <path-to-service-account.json>
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

async function seedAppContent() {
    console.log('Seeding app content collections...\n');

    // 1. app_banners
    console.log('  → app_banners');
    const banners = [
        { title: 'Welcome to Formula Scholar', imageUrl: '/assets/banners/welcome.png', link: '/chapters', isActive: true, displayOrder: 1, bgColor: '#4F46E5' },
        { title: 'Master New Topics', imageUrl: '/assets/banners/practice.png', link: '/practice', isActive: true, displayOrder: 2, bgColor: '#059669' },
        { title: 'Track Your Progress', imageUrl: '/assets/banners/progress.png', link: '/profile', isActive: true, displayOrder: 3, bgColor: '#DC2626' }
    ];
    for (const banner of banners) {
        await db.collection('app_banners').add(banner);
    }

    // 2. forum_posts (seed a sample welcome post)
    console.log('  → forum_posts');
    await db.collection('forum_posts').add({
        author: 'Formula Scholar Team',
        email: 'support@formulascholar.app',
        topic: 'Welcome to the Community Forum!',
        body: 'This is the official Formula Scholar discussion board. Share tips, ask questions, and help fellow learners.',
        status: 'Approved',
        createdAt: new Date().toISOString(),
        reports: 0
    });

    // 3. video_tutorials (sample entries)
    console.log('  → video_tutorials');
    const videos = [
        { title: 'Introduction to Calculus', url: 'https://www.youtube.com/watch?v=example1', subject: 'Mathematics', chapter: 'Calculus', duration: '15:30', isPublished: true },
        { title: 'Newton\'s Laws Explained', url: 'https://www.youtube.com/watch?v=example2', subject: 'Physics', chapter: 'Forces and Motion', duration: '12:45', isPublished: true },
        { title: 'Chemical Bonding Basics', url: 'https://www.youtube.com/watch?v=example3', subject: 'Chemistry', chapter: 'Chemical Bonding', duration: '18:20', isPublished: true },
        { title: 'Cell Division Overview', url: 'https://www.youtube.com/watch?v=example4', subject: 'Biology', chapter: 'Cell Biology', duration: '14:10', isPublished: true }
    ];
    for (const video of videos) {
        await db.collection('video_tutorials').add(video);
    }

    // 4. canonical_chapters
    console.log('  → canonical_chapters');
    const canonicalChapters = [
        { id: 'canon-real-numbers', title: 'Real Numbers', subject: 'Mathematics', audience: ['CBSE', 'ICSE', 'MSBSHSE'], displayOrder: 1 },
        { id: 'canon-polynomials', title: 'Polynomials', subject: 'Mathematics', audience: ['CBSE', 'ICSE', 'MSBSHSE'], displayOrder: 2 },
        { id: 'canon-forces', title: 'Forces and Motion', subject: 'Physics', audience: ['CBSE', 'ICSE', 'MSBSHSE'], displayOrder: 1 },
        { id: 'canon-chemical-bonding', title: 'Chemical Bonding', subject: 'Chemistry', audience: ['CBSE', 'ICSE', 'MSBSHSE'], displayOrder: 1 },
        { id: 'canon-cell-biology', title: 'Cell Biology', subject: 'Biology', audience: ['CBSE', 'ICSE', 'MSBSHSE'], displayOrder: 1 }
    ];
    for (const ch of canonicalChapters) {
        await db.collection('canonical_chapters').doc(ch.id).set(ch);
    }

    // 5. canonical_formulas
    console.log('  → canonical_formulas');
    const canonicalFormulas = [
        { id: 'canon-quadratic', title: 'Quadratic Formula', latex: 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}', subject: 'Mathematics', chapter: 'canon-polynomials', displayOrder: 1 },
        { id: 'canon-f-ma', title: 'Newton\'s Second Law', latex: 'F = ma', subject: 'Physics', chapter: 'canon-forces', displayOrder: 1 },
        { id: 'canon-e-mc2', title: 'Mass-Energy Equivalence', latex: 'E = mc^2', subject: 'Physics', chapter: 'canon-forces', displayOrder: 2 }
    ];
    for (const f of canonicalFormulas) {
        await db.collection('canonical_formulas').doc(f.id).set(f);
    }

    console.log('\nApp content seeding complete ✅');
}

seedAppContent().catch(console.error);
