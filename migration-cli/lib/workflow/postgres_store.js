const { Pool, Client } = require('pg');

/**
 * Postgres-backed workflow store replacing JSON file storage.
 * Provides the same interface as workflow_store.js but queries the real approval schema.
 */

class PostgresWorkflowStore {
    constructor(connectionConfig) {
        this.connectionConfig = connectionConfig;
        this.pool = new Pool(connectionConfig);
    }

    async connect() {
        // Test connection
        const client = await this.pool.connect();
        client.release();
        return true;
    }

    async close() {
        await this.pool.end();
    }

    async query(sql, params = []) {
        const client = await this.pool.connect();
        try {
            return await client.query(sql, params);
        } finally {
            client.release();
        }
    }

    /**
     * Upsert an approval policy
     */
    async upsertApprovalPolicy(policy, actor = 'system') {
        const client = await this.pool.connect();
        try {
            await client.query('BEGIN');

            const policyId = policy.id || `policy_${Date.now()}_${Math.random().toString(16).slice(2)}`;
            const now = new Date().toISOString();

            // Check if policy exists
            const checkResult = await client.query(
                'SELECT id FROM approval_policy WHERE id = $1',
                [policyId]
            );

            let policyRecord;
            if (checkResult.rows.length > 0) {
                // Update
                const updateResult = await client.query(
                    `UPDATE approval_policy 
                     SET entity_type = $1, region = $2, minimum_approvals = $3, 
                         sequential_signoff = $4, enabled = $5, updated_at = $6
                     WHERE id = $7
                     RETURNING *`,
                    [
                        policy.entityType,
                        policy.regionId || null,
                        Number(policy.minimumApprovals || 1),
                        Boolean(policy.requiresSequentialSignoff),
                        policy.enabled !== false,
                        now,
                        policyId
                    ]
                );
                policyRecord = this._mapPolicyRow(updateResult.rows[0]);
            } else {
                // Insert
                const insertResult = await client.query(
                    `INSERT INTO approval_policy 
                     (id, entity_type, region, minimum_approvals, sequential_signoff, enabled, created_at, updated_at)
                     VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
                     RETURNING *`,
                    [
                        policyId,
                        policy.entityType,
                        policy.regionId || null,
                        Number(policy.minimumApprovals || 1),
                        Boolean(policy.requiresSequentialSignoff),
                        policy.enabled !== false,
                        now,
                        now
                    ]
                );
                policyRecord = this._mapPolicyRow(insertResult.rows[0]);
            }

            // Log audit entry
            await client.query(
                `INSERT INTO audit_log (entity_type, entity_id, action, performed_by, delta, created_at)
                 VALUES ($1, $2, $3, $4, $5, $6)`,
                ['approval_policy', policyRecord.id, 'approval_policy_upserted', actor, JSON.stringify(policyRecord), now]
            );

            await client.query('COMMIT');
            return { policy: policyRecord };
        } catch (err) {
            await client.query('ROLLBACK');
            throw err;
        } finally {
            client.release();
        }
    }

    /**
     * Create a new approval request
     */
    async createApproval(approval, actor = 'system') {
        const client = await this.pool.connect();
        try {
            await client.query('BEGIN');

            const approvalId = approval.id || `approval_${Date.now()}_${Math.random().toString(16).slice(2)}`;
            const now = new Date().toISOString();

            const insertResult = await client.query(
                `INSERT INTO approvals 
                 (id, target_type, target_id, requested_by, policy_id, state, priority, due_at, created_at)
                 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
                 RETURNING *`,
                [
                    approvalId,
                    approval.targetType,
                    approval.targetId,
                    approval.requestedBy || actor,
                    approval.policyId || null,
                    approval.state || 'pending',
                    Number(approval.priority || 0),
                    approval.dueAt || null,
                    now
                ]
            );

            const approvalRecord = this._mapApprovalRow(insertResult.rows[0]);

            // Log audit entry
            await client.query(
                `INSERT INTO audit_log (entity_type, entity_id, action, performed_by, delta, created_at)
                 VALUES ($1, $2, $3, $4, $5, $6)`,
                ['approval', approvalRecord.id, 'approval_requested', actor, JSON.stringify(approvalRecord), now]
            );

            await client.query('COMMIT');
            return { approval: approvalRecord };
        } catch (err) {
            await client.query('ROLLBACK');
            throw err;
        } finally {
            client.release();
        }
    }

    /**
     * Record an approval decision (approve/reject/cancel)
     */
    async recordApprovalDecision(approvalId, decision, actor = 'system', comment = '') {
        const client = await this.pool.connect();
        try {
            await client.query('BEGIN');

            // Fetch approval
            const approvalResult = await client.query(
                'SELECT * FROM approvals WHERE id = $1',
                [approvalId]
            );
            if (approvalResult.rows.length === 0) {
                throw new Error(`Approval not found: ${approvalId}`);
            }

            const approval = this._mapApprovalRow(approvalResult.rows[0]);
            const now = new Date().toISOString();

            // Record decision
            const decisionId = `decision_${Date.now()}_${Math.random().toString(16).slice(2)}`;
            const insertDecisionResult = await client.query(
                `INSERT INTO approval_actions 
                 (id, approval_id, actor, action, comment, created_at)
                 VALUES ($1, $2, $3, $4, $5, $6)
                 RETURNING *`,
                [decisionId, approvalId, actor, decision, comment, now]
            );

            const decisionRecord = this._mapDecisionRow(insertDecisionResult.rows[0]);

            // Update approval state based on decision
            let newState = approval.state;
            if (decision === 'approve') {
                newState = 'approved';
            } else if (decision === 'reject') {
                newState = 'rejected';
            } else if (decision === 'cancel') {
                newState = 'cancelled';
            }

            const updateResult = await client.query(
                `UPDATE approvals SET state = $1, updated_at = $2 WHERE id = $3 RETURNING *`,
                [newState, now, approvalId]
            );

            const updatedApproval = this._mapApprovalRow(updateResult.rows[0]);

            // Log audit entry
            await client.query(
                `INSERT INTO audit_log (entity_type, entity_id, action, performed_by, delta, created_at)
                 VALUES ($1, $2, $3, $4, $5, $6)`,
                [
                    'approval',
                    approvalId,
                    'approval_decision_recorded',
                    actor,
                    JSON.stringify(decisionRecord),
                    now
                ]
            );

            await client.query('COMMIT');
            return { approval: updatedApproval, decision: decisionRecord };
        } catch (err) {
            await client.query('ROLLBACK');
            throw err;
        } finally {
            client.release();
        }
    }

    /**
     * Count approval decisions with a given action (default: 'approve')
     */
    async countApprovalDecisions(approvalId, action = 'approve') {
        const result = await this.query(
            `SELECT COUNT(*) as count FROM approval_actions 
             WHERE approval_id = $1 AND action = $2`,
            [approvalId, action]
        );
        return Number(result.rows[0].count);
    }

    /**
     * Resolve the policy for an approval (direct policy or entity-type match)
     */
    async resolvePolicyForApproval(approval) {
        // Try direct policy
        if (approval.policy_id) {
            const directResult = await this.query(
                'SELECT * FROM approval_policy WHERE id = $1',
                [approval.policy_id]
            );
            if (directResult.rows.length > 0) {
                return this._mapPolicyRow(directResult.rows[0]);
            }
        }

        // Try entity-type match
        const entityResult = await this.query(
            'SELECT * FROM approval_policy WHERE enabled = true AND entity_type = $1 LIMIT 1',
            [approval.target_type]
        );
        if (entityResult.rows.length > 0) {
            return this._mapPolicyRow(entityResult.rows[0]);
        }

        // Return default
        return {
            id: 'default',
            entityType: approval.target_type,
            regionId: null,
            minimumApprovals: 1,
            requiresSequentialSignoff: false,
            enabled: true
        };
    }

    /**
     * Check if an approval is ready to publish (state approved or meets policy requirements)
     */
    async isApprovalReady(approvalId) {
        const approvalResult = await this.query(
            'SELECT * FROM approvals WHERE id = $1',
            [approvalId]
        );

        if (approvalResult.rows.length === 0) {
            return false;
        }

        const approval = this._mapApprovalRow(approvalResult.rows[0]);

        // If already approved, it's ready
        if (approval.state === 'approved') {
            return true;
        }

        // Check policy requirements
        const policy = await this.resolvePolicyForApproval(approval);
        if (!policy || !policy.enabled) {
            return false;
        }

        const approveCount = await this.countApprovalDecisions(approvalId, 'approve');
        return approveCount >= policy.minimumApprovals;
    }

    /**
     * Get all ready-to-publish approvals and queue jobs for them
     */
    async runPublishWorker(actor = 'system') {
        const client = await this.pool.connect();
        try {
            await client.query('BEGIN');

            // Get all approved approvals that don't have a queued job yet
            const approvalsResult = await client.query(
                `SELECT a.* FROM approvals a
                 LEFT JOIN publish_job pj ON a.id = pj.approval_id
                 WHERE a.state = 'approved' AND pj.id IS NULL`
            );

            const readyApprovals = approvalsResult.rows.map((row) => this._mapApprovalRow(row));

            const now = new Date().toISOString();
            const processedJobs = [];

            for (const approval of readyApprovals) {
                // Check if truly ready per policy
                const isReady = await this.isApprovalReady(approval.id);
                if (!isReady) {
                    continue;
                }

                const jobId = `job_${Date.now()}_${Math.random().toString(16).slice(2)}`;

                // Create publish job
                const jobResult = await client.query(
                    `INSERT INTO publish_job 
                     (id, approval_id, version_id, status, attempts, created_by, created_at, updated_at)
                     VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
                     RETURNING *`,
                    [jobId, approval.id, approval.target_id, 'queued', 0, actor, now, now]
                );

                const jobRecord = this._mapJobRow(jobResult.rows[0]);
                processedJobs.push(jobRecord);

                // Log audit entry
                await client.query(
                    `INSERT INTO audit_log (entity_type, entity_id, action, performed_by, delta, created_at)
                     VALUES ($1, $2, $3, $4, $5, $6)`,
                    [
                        'publish_job',
                        jobId,
                        'publish_job_queued',
                        actor,
                        JSON.stringify({ approval_id: approval.id, version_id: approval.target_id }),
                        now
                    ]
                );
            }

            await client.query('COMMIT');

            return {
                approvalsScanned: readyApprovals.length,
                jobsQueued: processedJobs.length,
                jobs: processedJobs
            };
        } catch (err) {
            await client.query('ROLLBACK');
            throw err;
        } finally {
            client.release();
        }
    }

    /**
     * Map Postgres policy row to camelCase object
     */
    _mapPolicyRow(row) {
        return {
            id: row.id,
            entityType: row.entity_type,
            regionId: row.region,
            minimumApprovals: Number(row.minimum_approvals),
            requiresSequentialSignoff: Boolean(row.sequential_signoff),
            enabled: Boolean(row.enabled),
            createdAt: row.created_at,
            updatedAt: row.updated_at
        };
    }

    /**
     * Map Postgres approval row to camelCase object
     */
    _mapApprovalRow(row) {
        return {
            id: row.id,
            targetType: row.target_type,
            targetId: row.target_id,
            requestedBy: row.requested_by,
            policyId: row.policy_id,
            state: row.state,
            priority: Number(row.priority),
            dueAt: row.due_at,
            createdAt: row.created_at,
            updatedAt: row.updated_at
        };
    }

    /**
     * Map Postgres approval_action row to camelCase object
     */
    _mapDecisionRow(row) {
        return {
            id: row.id,
            actor: row.actor,
            action: row.action,
            comment: row.comment,
            createdAt: row.created_at
        };
    }

    /**
     * Map Postgres publish_job row to camelCase object
     */
    _mapJobRow(row) {
        return {
            id: row.id,
            approvalId: row.approval_id,
            versionId: row.version_id,
            status: row.status,
            attempts: Number(row.attempts),
            createdBy: row.created_by,
            createdAt: row.created_at,
            updatedAt: row.updated_at
        };
    }
}

module.exports = {
    PostgresWorkflowStore
};
