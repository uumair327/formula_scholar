const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

// Path to the service account key
const serviceAccountPath = path.resolve(__dirname, '../formula-scholar-firebase-adminsdk-fbsvc-8b4116cc0e.json');

if (!fs.existsSync(serviceAccountPath)) {
    console.error(`Service account key not found at ${serviceAccountPath}`);
    process.exit(1);
}

const serviceAccount = require(serviceAccountPath);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function backfillVaultCount() {
  console.log('Starting vaultCount backfill process...');
  
  try {
    // 1. Get all users
    const usersSnapshot = await db.collection('users').get();
    console.log(`Found ${usersSnapshot.docs.length} users.`);

    const vaultCounts = {};

    // 2. Iterate through users and their bookmarks
    let usersProcessed = 0;
    for (const userDoc of usersSnapshot.docs) {
      const bookmarksSnapshot = await db.collection(`users/${userDoc.id}/bookmarks`).get();
      
      for (const bookmarkDoc of bookmarksSnapshot.docs) {
        // Bookmarks in `users/{uid}/bookmarks` are keyed by their formula.id
        // We need to fetch the actual formula to find its canonicalFormulaId
        // Wait, the formulas are stored in `formulas` or `subjects/{subjectId}/chapters/{chapterId}/formulas/{formulaId}`?
        // Let's check if the bookmark has `canonicalFormulaId` directly. 
        const bookmarkData = bookmarkDoc.data();
        let canonicalId = bookmarkData.canonicalFormulaId;
        
        // If the bookmark doesn't store canonicalFormulaId, we have to look it up.
        // It's safer to just lookup the formula if canonicalId is missing.
        if (!canonicalId) {
            // First check global formulas collection
            const formulaDoc = await db.collection('formulas').doc(bookmarkDoc.id).get();
            if (formulaDoc.exists) {
                canonicalId = formulaDoc.data().canonicalFormulaId;
            } else {
                // To do this thoroughly we would need to search all chapter subcollections, 
                // but let's assume canonical_formulas have IDs that match the formula IDs, 
                // or we skip if not found. Often formula.id == canonicalFormula.id in simple seeders.
                // Let's check if canonical_formulas has this ID:
                const canonDoc = await db.collection('canonical_formulas').doc(bookmarkDoc.id).get();
                if (canonDoc.exists) {
                    canonicalId = bookmarkDoc.id;
                }
            }
        }

        if (canonicalId) {
            vaultCounts[canonicalId] = (vaultCounts[canonicalId] || 0) + 1;
        } else {
            // If still no canonicalId, let's just increment by the bookmark ID assuming it might be canonical.
            const checkCanonDoc = await db.collection('canonical_formulas').doc(bookmarkDoc.id).get();
            if (checkCanonDoc.exists) {
                vaultCounts[bookmarkDoc.id] = (vaultCounts[bookmarkDoc.id] || 0) + 1;
            }
        }
      }
      usersProcessed++;
      if (usersProcessed % 10 === 0) {
        console.log(`Processed ${usersProcessed} users...`);
      }
    }

    console.log(`Computed vault counts for ${Object.keys(vaultCounts).length} canonical formulas.`);

    // 3. Update canonical_formulas
    let updatedCount = 0;
    const batchArray = [];
    let currentBatch = db.batch();
    let operationsInBatch = 0;

    for (const [canonicalId, count] of Object.entries(vaultCounts)) {
        const ref = db.collection('canonical_formulas').doc(canonicalId);
        
        // Also ensure we only update existing canonical formulas
        const docSnap = await ref.get();
        if (docSnap.exists) {
            currentBatch.update(ref, { vaultCount: count });
            operationsInBatch++;
            updatedCount++;

            if (operationsInBatch >= 400) {
                batchArray.push(currentBatch);
                currentBatch = db.batch();
                operationsInBatch = 0;
            }
        }
    }

    if (operationsInBatch > 0) {
        batchArray.push(currentBatch);
    }

    console.log(`Committing ${batchArray.length} batches to update ${updatedCount} canonical formulas...`);
    for (let i = 0; i < batchArray.length; i++) {
        await batchArray[i].commit();
        console.log(`Committed batch ${i + 1}/${batchArray.length}`);
    }

    console.log('✅ vaultCount backfill complete!');

  } catch (error) {
    console.error('Error during backfill:', error);
  }
}

backfillVaultCount();
