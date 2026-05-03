/**
 * Master Seeder - Production Edition
 * Runs all seed scripts in the correct order to populate Firebase with production-level data
 *
 * Usage:
 *   node seed_all_production.js ../formula-scholar-firebase-adminsdk-fbsvc-8b4116cc0e.json
 */

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const serviceAccountPath = process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

if (!serviceAccountPath) {
    console.error('❌ Usage: node seed_all_production.js <path-to-service-account.json>');
    process.exit(1);
}

const resolvedPath = path.resolve(serviceAccountPath);

if (!fs.existsSync(resolvedPath)) {
    console.error(`❌ Service account file not found: ${resolvedPath}`);
    process.exit(1);
}

console.log(`\n${'═'.repeat(50)}`);
console.log(`🌱 FORMULA SCHOLAR - PRODUCTION DATA SEEDER 🌱`);
console.log(`${'═'.repeat(50)}\n`);
console.log(`Service Account: ${resolvedPath}\n`);

const scripts = [
    {
        name: 'seed.js',
        description: 'Base entities (Countries, States, Boards, Grades)',
        stage: 'Foundation'
    },
    {
        name: 'seed_subjects.js',
        description: 'Subjects, Chapters, Mastery Tools',
        stage: 'Structure'
    },
    {
        name: 'seed_formulas_enhanced.js',
        description: 'Production formulas with examples & tags (ENHANCED)',
        stage: 'Content'
    },
    {
        name: 'seed_practice_enhanced.js',
        description: 'Production quizzes & practice questions (ENHANCED)',
        stage: 'Content'
    },
    {
        name: 'seed_registry_enhanced.js',
        description: 'Curriculum & content registry for dashboard (ENHANCED)',
        stage: 'Dashboard'
    },
    {
        name: 'seed_curriculum_registry.js',
        description: 'Curriculum control metadata (Original)',
        stage: 'Dashboard'
    },
    {
        name: 'seed_content_registry.js',
        description: 'Content control metadata (Original)',
        stage: 'Dashboard'
    },
    {
        name: 'seed_status.js',
        description: 'Dashboard seed/sync metadata',
        stage: 'Dashboard'
    }
];

let successCount = 0;
let failureCount = 0;
const startTime = Date.now();
const results = [];

for (let i = 0; i < scripts.length; i++) {
    const script = scripts[i];
    const scriptPath = path.join(__dirname, script.name);

    console.log(`\n${'─'.repeat(50)}`);
    console.log(`[${i + 1}/${scripts.length}] ${script.stage.toUpperCase()} STAGE`);
    console.log(`${'─'.repeat(50)}`);
    console.log(`▶ ${script.name}`);
    console.log(`  ${script.description}\n`);

    const scriptStartTime = Date.now();

    try {
        // Check if enhanced script exists, use it; otherwise fall back to original
        let actualScriptPath = scriptPath;
        if (!fs.existsSync(scriptPath)) {
            throw new Error(`Script not found: ${script.name}`);
        }

        execSync(`node "${actualScriptPath}" "${resolvedPath}"`, { stdio: 'inherit' });

        const elapsed = ((Date.now() - scriptStartTime) / 1000).toFixed(2);
        console.log(`✅ Completed in ${elapsed}s\n`);

        successCount++;
        results.push({
            script: script.name,
            status: 'SUCCESS',
            duration: elapsed,
            stage: script.stage
        });
    } catch (error) {
        const elapsed = ((Date.now() - scriptStartTime) / 1000).toFixed(2);
        console.error(`\n❌ ${script.name} failed after ${elapsed}s`);
        console.error(`   Error: ${error.message}\n`);

        failureCount++;
        results.push({
            script: script.name,
            status: 'FAILED',
            duration: elapsed,
            stage: script.stage,
            error: error.message
        });

        // Continue with next script instead of failing
        // In production, you might want to stop here
        console.log('   ⚠️  Continuing with next seeder...\n');
    }
}

// Print summary
const totalTime = ((Date.now() - startTime) / 1000).toFixed(2);

console.log(`\n${'═'.repeat(50)}`);
console.log(`📊 SEEDING SUMMARY`);
console.log(`${'═'.repeat(50)}\n`);

console.log(`Total Time: ${totalTime}s`);
console.log(`Successful: ✅ ${successCount}/${scripts.length}`);
console.log(`Failed: ❌ ${failureCount}/${scripts.length}\n`);

console.log(`Stage Breakdown:`);
const stages = {};
for (const result of results) {
    if (!stages[result.stage]) {
        stages[result.stage] = { success: 0, failed: 0 };
    }
    if (result.status === 'SUCCESS') {
        stages[result.stage].success++;
    } else {
        stages[result.stage].failed++;
    }
}

for (const [stage, counts] of Object.entries(stages)) {
    const stageStatus = counts.failed === 0 ? '✅' : '⚠️ ';
    console.log(`  ${stageStatus} ${stage}: ${counts.success} success, ${counts.failed} failed`);
}

console.log(`\nDetailed Results:`);
for (const result of results) {
    const statusIcon = result.status === 'SUCCESS' ? '✅' : '❌';
    console.log(
        `  ${statusIcon} ${result.script.padEnd(35)} [${result.stage.padEnd(10)}] ${result.duration}s`
    );
    if (result.error) {
        console.log(`     └─ ${result.error}`);
    }
}

console.log(`\n${'═'.repeat(50)}`);
if (failureCount === 0) {
    console.log(`✅ ALL SEEDERS COMPLETED SUCCESSFULLY!`);
    console.log(`\n📊 Your database is now populated with production-level data:`);
    console.log(`   • Multiple subjects (Math, Physics, Chemistry, Biology)`);
    console.log(`   • 4+ chapters per subject with comprehensive formulas`);
    console.log(`   • 30+ production formulas with LaTeX rendering`);
    console.log(`   • 6+ quizzes with 20+ practice questions`);
    console.log(`   • Curriculum registry for CBSE/ICSE boards (Classes 8-12)`);
    console.log(`   • Content registry with student engagement stats`);
    console.log(`   • Dashboard-ready metadata and indexes`);
    console.log(`\n🎉 Ready for production use!\n`);
} else {
    console.log(`⚠️  Seeding completed with ${failureCount} failure(s).`);
    console.log(`\n🔧 Check the errors above and re-run failed seeders.\n`);
}
console.log(`${'═'.repeat(50)}\n`);

process.exit(failureCount > 0 ? 1 : 0);
