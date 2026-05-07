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

  // 2. States and Union Territories for IN
  const indianStates = [
    { code: 'AP', name: 'Andhra Pradesh' },
    { code: 'AR', name: 'Arunachal Pradesh' },
    { code: 'AS', name: 'Assam' },
    { code: 'BR', name: 'Bihar' },
    { code: 'CG', name: 'Chhattisgarh' },
    { code: 'GA', name: 'Goa' },
    { code: 'GJ', name: 'Gujarat' },
    { code: 'HR', name: 'Haryana' },
    { code: 'HP', name: 'Himachal Pradesh' },
    { code: 'JH', name: 'Jharkhand' },
    { code: 'KA', name: 'Karnataka' },
    { code: 'KL', name: 'Kerala' },
    { code: 'MP', name: 'Madhya Pradesh' },
    { code: 'MH', name: 'Maharashtra' },
    { code: 'MN', name: 'Manipur' },
    { code: 'ML', name: 'Meghalaya' },
    { code: 'MZ', name: 'Mizoram' },
    { code: 'NL', name: 'Nagaland' },
    { code: 'OD', name: 'Odisha' },
    { code: 'PB', name: 'Punjab' },
    { code: 'RJ', name: 'Rajasthan' },
    { code: 'SK', name: 'Sikkim' },
    { code: 'TN', name: 'Tamil Nadu' },
    { code: 'TG', name: 'Telangana' },
    { code: 'TR', name: 'Tripura' },
    { code: 'UP', name: 'Uttar Pradesh' },
    { code: 'UK', name: 'Uttarakhand' },
    { code: 'WB', name: 'West Bengal' },
    { code: 'AN', name: 'Andaman and Nicobar Islands' },
    { code: 'CH', name: 'Chandigarh' },
    { code: 'DD', name: 'Dadra and Nagar Haveli and Daman and Diu' },
    { code: 'DL', name: 'Delhi' },
    { code: 'JK', name: 'Jammu and Kashmir' },
    { code: 'LA', name: 'Ladakh' },
    { code: 'LD', name: 'Lakshadweep' },
    { code: 'PY', name: 'Puducherry' }
  ];

  for (const st of indianStates) {
    const stateRef = inRef.collection('states').doc(st.code);
    batch.set(stateRef, { name: st.name, stateCode: st.code });
  }

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
      name: 'MSBSHSE (Maharashtra)',
      description: 'Maharashtra State Board of Secondary and Higher Secondary Education.'
    },
    {
      id: 'up_board',
      countryId: 'IN',
      stateId: 'UP',
      type: 'state',
      name: 'UPMSP (Uttar Pradesh)',
      description: 'Uttar Pradesh Madhyamik Shiksha Parishad.'
    },
    {
      id: 'tn_board',
      countryId: 'IN',
      stateId: 'TN',
      type: 'state',
      name: 'TN Board (Tamil Nadu)',
      description: 'Tamil Nadu State Board of Secondary Education.'
    },
    {
      id: 'ka_board',
      countryId: 'IN',
      stateId: 'KA',
      type: 'state',
      name: 'KSEEB (Karnataka)',
      description: 'Karnataka Secondary Education Examination Board.'
    },
    {
      id: 'gj_board',
      countryId: 'IN',
      stateId: 'GJ',
      type: 'state',
      name: 'GSEB (Gujarat)',
      description: 'Gujarat Secondary and Higher Secondary Education Board.'
    },
    {
      id: 'wb_board',
      countryId: 'IN',
      stateId: 'WB',
      type: 'state',
      name: 'WBBSE (West Bengal)',
      description: 'West Bengal Board of Secondary Education.'
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
