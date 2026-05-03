/**
 * Store adapter that provides a unified interface for both JSON and Postgres backends
 * Allows commands to work transparently with either storage mechanism
 */

const fs = require('fs');
const path = require('path');
const { PostgresWorkflowStore } = require('./postgres_store');

class StoreAdapter {
    constructor(mode = 'json', config = {}) {
        this.mode = mode;
        this.config = config;
        this.backend = null;

        if (mode === 'postgres') {
            this.backend = new PostgresWorkflowStore(config);
        } else if (mode === 'json') {
            this.storePath = config.storePath || path.join(process.cwd(), 'data', 'workflow-state.json');
        } else {
            throw new Error(`Unknown store mode: ${mode}`);
        }
    }

    async connect() {
        if (this.mode === 'postgres') {
            return await this.backend.connect();
        }
        return true;
    }

    async close() {
        if (this.mode === 'postgres') {
            return await this.backend.close();
        }
    }

    /**
     * Upsert an approval policy
     */
    async upsertApprovalPolicy(policy, actor = 'system') {
        if (this.mode === 'postgres') {
            return await this.backend.upsertApprovalPolicy(policy, actor);
        } else {
            // JSON mode - use synchronous JSON store
            const { loadState, saveState, upsertApprovalPolicy } = require('./workflow_store');
            const state = loadState(this.storePath);
            const result = upsertApprovalPolicy(state, policy, actor);
            saveState(result.state, this.storePath);
            return { policy: result.policy };
        }
    }

    /**
     * Create a new approval
     */
    async createApproval(approval, actor = 'system') {
        if (this.mode === 'postgres') {
            return await this.backend.createApproval(approval, actor);
        } else {
            const { loadState, saveState, createApproval } = require('./workflow_store');
            const state = loadState(this.storePath);
            const result = createApproval(state, approval, actor);
            saveState(result.state, this.storePath);
            return { approval: result.approval };
        }
    }

    /**
     * Record an approval decision
     */
    async recordApprovalDecision(approvalId, decision, actor = 'system', comment = '') {
        if (this.mode === 'postgres') {
            return await this.backend.recordApprovalDecision(approvalId, decision, actor, comment);
        } else {
            const { loadState, saveState, recordApprovalDecision } = require('./workflow_store');
            const state = loadState(this.storePath);
            const result = recordApprovalDecision(state, approvalId, decision, actor, comment);
            saveState(result.state, this.storePath);
            return { approval: result.approval, decision: result.decision };
        }
    }

    /**
     * Run the publish worker
     */
    async runPublishWorker(actor = 'system') {
        if (this.mode === 'postgres') {
            return await this.backend.runPublishWorker(actor);
        } else {
            const { loadState, saveState } = require('./workflow_store');
            const { runPublishWorker } = require('./publish_worker');
            // Note: publish_worker still uses sync interface, wrap it
            const result = runPublishWorker({ storePath: this.storePath, actor });
            return result;
        }
    }

    /**
     * Count approval decisions for an approval
     */
    async countApprovalDecisions(approvalId, action = 'approve') {
        if (this.mode === 'postgres') {
            return await this.backend.countApprovalDecisions(approvalId, action);
        } else {
            // For JSON mode, we'd need to load state and count - not typically needed
            throw new Error('countApprovalDecisions not supported in JSON mode');
        }
    }

    /**
     * Check if an approval is ready
     */
    async isApprovalReady(approvalId) {
        if (this.mode === 'postgres') {
            return await this.backend.isApprovalReady(approvalId);
        } else {
            const { loadState, isApprovalReady } = require('./workflow_store');
            const state = loadState(this.storePath);
            const approval = state.approvals.find((a) => a.id === approvalId);
            if (!approval) return false;
            return isApprovalReady(state, approval);
        }
    }
}

/**
 * Factory function to create a store based on environment or config
 */
function createStore(options = {}) {
    const mode = options.mode || process.env.STORE_MODE || 'json';

    if (mode === 'postgres') {
        const connectionConfig = {
            host: options.dbHost || process.env.DB_HOST || 'localhost',
            port: options.dbPort || process.env.DB_PORT || 5432,
            database: options.dbName || process.env.DB_NAME || 'formula_factory',
            user: options.dbUser || process.env.DB_USER || 'postgres',
            password: options.dbPassword || process.env.DB_PASSWORD,
            max: options.dbPoolSize || 10,
            idleTimeoutMillis: 30000,
            connectionTimeoutMillis: 2000
        };
        return new StoreAdapter('postgres', connectionConfig);
    } else {
        return new StoreAdapter('json', { storePath: options.storePath });
    }
}

module.exports = {
    StoreAdapter,
    createStore
};
