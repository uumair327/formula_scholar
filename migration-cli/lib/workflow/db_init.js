/**
 * Database initialization script for the workflow schema
 * Creates approval_policy, approvals, approval_actions, publish_job, and audit_log tables
 */

const { Pool } = require('pg');

async function initializeDatabase(connectionConfig) {
    const client = new Pool(connectionConfig);

    try {
        console.log('Initializing workflow schema...');

        // Create approval_policy table
        await client.query(`
            CREATE TABLE IF NOT EXISTS approval_policy (
                id VARCHAR(255) PRIMARY KEY,
                entity_type VARCHAR(255) NOT NULL,
                region VARCHAR(255),
                minimum_approvals INT NOT NULL DEFAULT 1,
                sequential_signoff BOOLEAN NOT NULL DEFAULT false,
                enabled BOOLEAN NOT NULL DEFAULT true,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL
            );
            CREATE INDEX IF NOT EXISTS idx_approval_policy_entity_type 
                ON approval_policy(entity_type);
            CREATE INDEX IF NOT EXISTS idx_approval_policy_enabled 
                ON approval_policy(enabled);
        `);

        // Create approvals table
        await client.query(`
            CREATE TABLE IF NOT EXISTS approvals (
                id VARCHAR(255) PRIMARY KEY,
                target_type VARCHAR(255) NOT NULL,
                target_id VARCHAR(255) NOT NULL,
                requested_by VARCHAR(255) NOT NULL,
                policy_id VARCHAR(255) REFERENCES approval_policy(id),
                state VARCHAR(50) NOT NULL DEFAULT 'pending',
                priority INT NOT NULL DEFAULT 0,
                due_at TIMESTAMP,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL
            );
            CREATE INDEX IF NOT EXISTS idx_approvals_state 
                ON approvals(state);
            CREATE INDEX IF NOT EXISTS idx_approvals_target 
                ON approvals(target_type, target_id);
            CREATE INDEX IF NOT EXISTS idx_approvals_policy_id 
                ON approvals(policy_id);
        `);

        // Create approval_actions table
        await client.query(`
            CREATE TABLE IF NOT EXISTS approval_actions (
                id VARCHAR(255) PRIMARY KEY,
                approval_id VARCHAR(255) NOT NULL REFERENCES approvals(id),
                actor VARCHAR(255) NOT NULL,
                action VARCHAR(50) NOT NULL,
                comment TEXT,
                created_at TIMESTAMP NOT NULL
            );
            CREATE INDEX IF NOT EXISTS idx_approval_actions_approval_id 
                ON approval_actions(approval_id);
            CREATE INDEX IF NOT EXISTS idx_approval_actions_action 
                ON approval_actions(action);
        `);

        // Create publish_job table
        await client.query(`
            CREATE TABLE IF NOT EXISTS publish_job (
                id VARCHAR(255) PRIMARY KEY,
                approval_id VARCHAR(255) NOT NULL REFERENCES approvals(id),
                version_id VARCHAR(255) NOT NULL,
                status VARCHAR(50) NOT NULL DEFAULT 'queued',
                attempts INT NOT NULL DEFAULT 0,
                created_by VARCHAR(255) NOT NULL,
                scheduled_at TIMESTAMP,
                started_at TIMESTAMP,
                finished_at TIMESTAMP,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL
            );
            CREATE INDEX IF NOT EXISTS idx_publish_job_status 
                ON publish_job(status);
            CREATE INDEX IF NOT EXISTS idx_publish_job_approval_id 
                ON publish_job(approval_id);
            CREATE UNIQUE INDEX IF NOT EXISTS idx_publish_job_approval_unique 
                ON publish_job(approval_id) 
                WHERE status IN ('queued', 'running');
        `);

        // Create audit_log table (append-only)
        await client.query(`
            CREATE TABLE IF NOT EXISTS audit_log (
                id SERIAL PRIMARY KEY,
                entity_type VARCHAR(255) NOT NULL,
                entity_id VARCHAR(255) NOT NULL,
                action VARCHAR(255) NOT NULL,
                performed_by VARCHAR(255) NOT NULL,
                delta JSONB,
                created_at TIMESTAMP NOT NULL
            );
            CREATE INDEX IF NOT EXISTS idx_audit_log_entity 
                ON audit_log(entity_type, entity_id);
            CREATE INDEX IF NOT EXISTS idx_audit_log_action 
                ON audit_log(action);
            CREATE INDEX IF NOT EXISTS idx_audit_log_created_at 
                ON audit_log(created_at);
        `);

        console.log('Schema initialization complete.');
        await client.end();
        return true;
    } catch (err) {
        console.error('Database initialization failed:', err.message);
        await client.end();
        throw err;
    }
}

module.exports = { initializeDatabase };
