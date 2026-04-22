/**
 * Master Seeder — runs all seed scripts in the correct order.
 *
 * Usage:
 *   node seed_all.js ../formula-scholar-firebase-adminsdk-fbsvc-8b4116cc0e.json
 */

const { execSync } = require('child_process');
const path = require('path');

const serviceAccountPath = process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

if (!serviceAccountPath) {
  console.error(
    '❌ Usage: node seed_all.js <path-to-service-account.json>'
  );
  process.exit(1);
}

const resolvedPath = path.resolve(serviceAccountPath);
console.log(`Using service account: ${resolvedPath}\n`);

const scripts = [
  'seed.js',              // Countries, States, Boards, Grades
  'seed_subjects.js',     // Subjects, Chapters, Mastery Tools
  'seed_formulas.js',     // Formulas per chapter
  'seed_practice.js',     // Practice quiz questions
  'seed_curriculum_registry.js', // Curriculum control metadata for dashboard
  'seed_content_registry.js', // Content control metadata for dashboard
  'seed_status.js',       // Dashboard seed/sync metadata
];

for (const script of scripts) {
  const scriptPath = path.join(__dirname, script);
  console.log(`\n────────────────────────────────────────`);
  console.log(`▶ Running: ${script}`);
  console.log(`────────────────────────────────────────`);
  try {
    execSync(`node "${scriptPath}" "${resolvedPath}"`, { stdio: 'inherit' });
  } catch (error) {
    console.error(`❌ ${script} failed: ${error.message}`);
    process.exit(1);
  }
}

console.log(`\n════════════════════════════════════════`);
console.log(`✅ All seeders completed successfully!`);
console.log(`════════════════════════════════════════\n`);
