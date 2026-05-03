/**
 * JSON to Postgres Migration Script
 * Migrates existing workflow-state.json to Postgres schema
 * 
 * Usage:
 *   node json_to_postgres_migration.js --source ./workflow-state.json --db-host localhost --db-port 5432 --db-name formula_factory --db-user postgres --db-password <password>
 */

const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');
const crypto = require('crypto');

// Parse command line arguments
function parseArgs() {
    const args = process.argv.slice(2);
    const options = {};

    for (let i = 0; i < args.length; i++) {
        if (args[i].startsWith('--')) {
            const key = args[i].substring(2);
            const value = args[i + 1];
            if (!value || value.startsWith('--')) {
                options[key] = true;
            } else {
                options[key] = value;
                i++;
            }
        }
    }

    return options;
}

async function runMigration() {
    const options = parseArgs();

    if (!options.source) {
        console.error('❌ Usage: node json_to_postgres_migration.js --source <path-to-workflow-state.json> [--db-* options]');
        process.exit(1);
    }

    const sourceFile = path.resolve(options.source);
    if (!fs.existsSync(sourceFile)) {
        console.error(`❌ Source file not found: ${sourceFile}`);
        process.exit(1);
    }

    console.log(`\n${'═'.repeat(60)}`);
    console.log(`🔄 JSON to Postgres Migration`);
    console.log(`${'═'.repeat(60)}\n`);

    console.log(`Source File: ${sourceFile}`);
    console.log(`Target Database: ${options['db-host']}:${options['db-port']}/${options['db-name']}\n`);

    // Read JSON file
    console.log('📖 Reading JSON source file...');
    let sourceData;
    try {
        const content = fs.readFileSync(sourceFile, 'utf8');
        sourceData = JSON.parse(content);
        console.log('✅ Successfully parsed JSON\n');
    } catch (error) {
        console.error(`❌ Failed to parse JSON: ${error.message}`);
        process.exit(1);
    }

    // Connect to Postgres
    console.log('🔌 Connecting to Postgres...');
    const pool = new Pool({
        host: options['db-host'] || 'localhost',
        port: options['db-port'] || 5432,
        database: options['db-name'] || 'formula_factory',
        user: options['db-user'] || 'postgres',
        password: options['db-password'] || ''
    });

    try {
        await pool.query('SELECT NOW()');
        console.log('✅ Successfully connected to Postgres\n');
    } catch (error) {
        console.error(`❌ Failed to connect to Postgres: ${error.message}`);
        process.exit(1);
    }

    let migrationStats = {
        policiesMigrated: 0,
        approvalsMigrated: 0,
        decisionsMigrated: 0,
        jobsMigrated: 0,
        auditLogsMigrated: 0,
        errors: []
    };

    const client = await pool.connect();

    try {
        // Begin transaction
        await client.query('BEGIN');
        console.log('📝 Starting migration transaction...\n');

        // Migrate approval policies
        if (sourceData.approvalPolicies && Array.isArray(sourceData.approvalPolicies)) {
            console.log(`📋 Migrating ${sourceData.approvalPolicies.length} approval policies...`);

            for (const policy of sourceData.approvalPolicies) {
                try {
                    const query = `
            INSERT INTO approval_policy (id, entity_type, minimum_approvals, enabled, created_at, updated_at)
            VALUES ($1, $2, $3, $4, $5, $6)
            ON CONFLICT (id) DO UPDATE SET
              entity_type = EXCLUDED.entity_type,
              minimum_approvals = EXCLUDED.minimum_approvals,
              enabled = EXCLUDED.enabled,
              updated_at = EXCLUDED.updated_at
          `;

                    await client.query(query, [
                        policy.id,
                        policy.entity_type,
                        policy.minimum_approvals || 1,
                        policy.enabled !== false,
                        new Date(policy.created_at || Date.now()),
                        new Date(policy.updated_at || Date.now())
                    ]);

                    migrationStats.policiesMigrated++;
                } catch (error) {
                    migrationStats.errors.push(`Policy ${policy.id}: ${error.message}`);
                    console.warn(`  ⚠️  Failed to migrate policy ${policy.id}: ${error.message}`);
                }
            }

            console.log(`✅ Migrated ${migrationStats.policiesMigrated} policies\n`);
        }

        // Migrate approvals
        if (sourceData.approvals && Array.isArray(sourceData.approvals)) {
            console.log(`📋 Migrating ${sourceData.approvals.length} approvals...`);

            for (const approval of sourceData.approvals) {
                try {
                    const query = `
            INSERT INTO approvals (id, policy_id, entity_type, entity_id, state, created_at)
            VALUES ($1, $2, $3, $4, $5, $6)
            ON CONFLICT (id) DO UPDATE SET
              state = EXCLUDED.state
          `;

                    await client.query(query, [
                        approval.id,
                        approval.policy_id,
                        approval.entity_type,
                        approval.entity_id,
                        approval.state || 'pending',
                        new Date(approval.created_at || Date.now())
                    ]);

                    migrationStats.approvalsMigrated++;

                    // Migrate decisions (stored as array in JSON)
                    if (approval.decisions && Array.isArray(approval.decisions)) {
                        for (const decision of approval.decisions) {
                            try {
                                const decisionQuery = `
                  INSERT INTO approval_actions (id, approval_id, action, actor, comment, created_at)
                  VALUES ($1, $2, $3, $4, $5, $6)
                `;

                                const decisionId = `${approval.id}_decision_${crypto.randomBytes(4).toString('hex')}`;

                                await client.query(decisionQuery, [
                                    decisionId,
                                    approval.id,
                                    decision.action || 'approve',
                                    decision.actor || 'unknown',
                                    decision.comment || '',
                                    new Date(decision.created_at || Date.now())
                                ]);

                                migrationStats.decisionsMigrated++;
                            } catch (error) {
                                migrationStats.errors.push(`Decision in approval ${approval.id}: ${error.message}`);
                            }
                        }
                    }
                } catch (error) {
                    migrationStats.errors.push(`Approval ${approval.id}: ${error.message}`);
                    console.warn(`  ⚠️  Failed to migrate approval ${approval.id}: ${error.message}`);
                }
            }

            console.log(`✅ Migrated ${migrationStats.approvalsMigrated} approvals with ${migrationStats.decisionsMigrated} decisions\n`);
        }

        // Migrate publish jobs
        if (sourceData.publishJobs && Array.isArray(sourceData.publishJobs)) {
            console.log(`📋 Migrating ${sourceData.publishJobs.length} publish jobs...`);

            for (const job of sourceData.publishJobs) {
                try {
                    const query = `
            INSERT INTO publish_job (id, approval_id, status, formula_version_id, created_at, updated_at)
            VALUES ($1, $2, $3, $4, $5, $6)
            ON CONFLICT (id) DO UPDATE SET
              status = EXCLUDED.status,
              updated_at = EXCLUDED.updated_at
          `;

                    await client.query(query, [
                        job.id,
                        job.approval_id,
                        job.status || 'queued',
                        job.formula_version_id || '',
                        new Date(job.created_at || Date.now()),
                        new Date(job.updated_at || Date.now())
                    ]);

                    migrationStats.jobsMigrated++;
                } catch (error) {
                    migrationStats.errors.push(`Job ${job.id}: ${error.message}`);
                    console.warn(`  ⚠️  Failed to migrate job ${job.id}: ${error.message}`);
                }
            }

            console.log(`✅ Migrated ${migrationStats.jobsMigrated} publish jobs\n`);
        }

        // Migrate audit log
        if (sourceData.auditLog && Array.isArray(sourceData.auditLog)) {
            console.log(`📋 Migrating ${sourceData.auditLog.length} audit log entries...`);

            for (const entry of sourceData.auditLog) {
                try {
                    const query = `
            INSERT INTO audit_log (id, entity, entity_id, action, actor, details, created_at)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
          `;

                    const auditId = `audit_${crypto.randomBytes(8).toString('hex')}`;

                    await client.query(query, [
                        auditId,
                        entry.entity || 'unknown',
                        entry.entity_id || '',
                        entry.action || 'unknown',
                        entry.actor || 'system',
                        JSON.stringify(entry.details || {}),
                        new Date(entry.created_at || Date.now())
                    ]);

                    migrationStats.auditLogsMigrated++;
                } catch (error) {
                    migrationStats.errors.push(`Audit log entry: ${error.message}`);
                }
            }

            console.log(`✅ Migrated ${migrationStats.auditLogsMigrated} audit log entries\n`);
        }

        // Commit transaction
        await client.query('COMMIT');
        console.log('✅ Transaction committed successfully\n');

    } catch (error) {
        // Rollback on error
        await client.query('ROLLBACK');
        console.error(`\n❌ Migration failed: ${error.message}`);
        console.error('Transaction rolled back\n');
        migrationStats.errors.push(`Transaction error: ${error.message}`);
    } finally {
        client.release();
    }

    // Print summary
    console.log(`\n${'═'.repeat(60)}`);
    console.log(`📊 MIGRATION SUMMARY`);
    console.log(`${'═'.repeat(60)}\n`);

    console.log(`Approval Policies: ${migrationStats.policiesMigrated}`);
    console.log(`Approvals: ${migrationStats.approvalsMigrated}`);
    console.log(`Approval Decisions: ${migrationStats.decisionsMigrated}`);
    console.log(`Publish Jobs: ${migrationStats.jobsMigrated}`);
    console.log(`Audit Log Entries: ${migrationStats.auditLogsMigrated}`);
    console.log(`\nTotal Records Migrated: ${migrationStats.policiesMigrated + migrationStats.approvalsMigrated + migrationStats.decisionsMigrated + migrationStats.jobsMigrated + migrationStats.auditLogsMigrated}`);

    if (migrationStats.errors.length > 0) {
        console.log(`\n⚠️  Errors During Migration: ${migrationStats.errors.length}`);
        for (const error of migrationStats.errors.slice(0, 5)) {
            console.log(`  • ${error}`);
        }
        if (migrationStats.errors.length > 5) {
            console.log(`  ... and ${migrationStats.errors.length - 5} more`);
        }
    } else {
        console.log(`\n✅ Migration completed without errors!`);
    }

    console.log(`\n${'═'.repeat(60)}\n`);

    // Close pool
    await pool.end();

    // Exit with appropriate code
    process.exit(migrationStats.errors.length > 0 ? 1 : 0);
}

// Run migration
runMigration().catch(error => {
    console.error(`❌ Fatal error: ${error.message}`);
    process.exit(1);
});
