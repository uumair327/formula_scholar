const path = require('path');
const admin = require('firebase-admin');

const serviceAccountPath = process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

if (!serviceAccountPath) {
  throw new Error(
    'Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.'
  );
}

const serviceAccount = require(path.resolve(serviceAccountPath));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function seed() {
  console.log('Seeding Database...');

  const batch = db.batch();

  // 1. Countries
  const inRef = db.collection('countries').doc('IN');
  batch.set(inRef, { name: 'India', isoCode: 'IN', flagUrl: '🇮🇳' });

  // 2. States for IN
  const stateDoc1 = inRef.collection('states').doc('MH');
  batch.set(stateDoc1, { name: 'Maharashtra', stateCode: 'MH' });

  const stateDoc2 = inRef.collection('states').doc('DL');
  batch.set(stateDoc2, { name: 'Delhi', stateCode: 'DL' });

  const stateDoc3 = inRef.collection('states').doc('KA');
  batch.set(stateDoc3, { name: 'Karnataka', stateCode: 'KA' });

  // 3. Boards
  const boards = [
    {
      id: 'cbse',
      countryId: 'IN',
      type: 'national',
      name: 'CBSE',
      description: 'Central Board of Secondary Education — The national standard curriculum.'
    },
    {
      id: 'icse',
      countryId: 'IN',
      type: 'national',
      name: 'ICSE',
      description: 'Council for the Indian School Certificate Examinations.'
    },
    {
      id: 'msbshse',
      countryId: 'IN',
      stateId: 'MH',
      type: 'state',
      name: 'State Board (MSBSHSE)',
      description: 'Maharashtra State Board of Secondary and Higher Secondary Education.'
    },
    {
      id: 'private',
      countryId: 'IN',
      type: 'private',
      name: 'Private Boards',
      description: 'International Baccalaureate (IB), Cambridge (IGCSE) & Private.'
    }
  ];

  for (const b of boards) {
    const boardRef = db.collection('boards').doc(b.id);
    batch.set(boardRef, b);

    // 4. Grades/Classes for each board
    const grades = [
      { id: '11', label: '11th Grade', classNumber: 11, subtitle: 'Pre-University 1', isPopular: true },
      { id: '12', label: '12th Grade', classNumber: 12, subtitle: 'Pre-University 2', isPopular: true },
      { id: '10', label: '10th Grade', classNumber: 10, subtitle: 'High School', isPopular: false }
    ];

    for (const g of grades) {
      const clsRef = boardRef.collection('classes').doc(g.id);
      batch.set(clsRef, g);
    }
  }

  // Commit batch
  await batch.commit();
  console.log('Seeding Complete ✅');
}

seed().catch(console.error);
