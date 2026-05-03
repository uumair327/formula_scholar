/**
 * Store adapter tests
 * Tests the unified adapter that works with both JSON and Postgres backends
 */

const { StoreAdapter, createStore } = require('../lib/workflow/store_adapter');
const fs = require('fs');
const path = require('path');

// Test with JSON mode (no database needed)
describe('StoreAdapter - JSON Mode', () => {
    let adapter;
    const testStorePath = path.join(__dirname, 'test-store.json');

    beforeEach(() => {
        adapter = new StoreAdapter('json', { storePath: testStorePath });
        // Clean up test store
        if (fs.existsSync(testStorePath)) {
            fs.unlinkSync(testStorePath);
        }
    });

    afterEach(() => {
        if (fs.existsSync(testStorePath)) {
            fs.unlinkSync(testStorePath);
        }
    });

    test('should create adapter in JSON mode', () => {
        expect(adapter.mode).toBe('json');
        expect(adapter.storePath).toBe(testStorePath);
    });

    test('should upsert approval policy in JSON mode', async () => {
        const result = await adapter.upsertApprovalPolicy(
            {
                id: 'policy_1',
                entityType: 'formula_version',
                minimumApprovals: 2,
                requiresSequentialSignoff: false,
                enabled: true
            },
            'admin'
        );

        expect(result.policy).toBeDefined();
        expect(result.policy.id).toBe('policy_1');
        expect(result.policy.entityType).toBe('formula_version');
        expect(result.policy.minimumApprovals).toBe(2);

        // Verify state was persisted
        const state = JSON.parse(fs.readFileSync(testStorePath, 'utf8'));
        expect(state.approvalPolicies.length).toBe(1);
        expect(state.approvalPolicies[0].id).toBe('policy_1');
    });

    test('should record approval decision in JSON mode', async () => {
        // First create an approval
        const approvalPolicy = await adapter.upsertApprovalPolicy(
            {
                id: 'policy_1',
                entityType: 'formula_version',
                minimumApprovals: 1,
                enabled: true
            },
            'admin'
        );

        // Create an approval (manual for now - would use createApproval in real scenario)
        const { loadState, saveState, createApproval } = require('../lib/workflow/workflow_store');
        const state = loadState(testStorePath);
        const result = createApproval(
            state,
            {
                id: 'approval_1',
                targetType: 'formula_version',
                targetId: 'v123',
                requestedBy: 'user1'
            },
            'system'
        );
        saveState(result.state, testStorePath);

        // Now record a decision
        const decisionResult = await adapter.recordApprovalDecision(
            'approval_1',
            'approve',
            'reviewer1',
            'LGTM'
        );

        expect(decisionResult.approval).toBeDefined();
        expect(decisionResult.approval.state).toBe('pending');
        expect(decisionResult.decision.action).toBe('approve');
    });

    test('should check if approval is ready in JSON mode', async () => {
        // Set up approval
        const { loadState, saveState, createApproval, recordApprovalDecision } = require('../lib/workflow/workflow_store');
        let state = loadState(testStorePath);

        let result = createApproval(
            state,
            {
                id: 'approval_1',
                targetType: 'formula_version',
                targetId: 'v123'
            },
            'system'
        );
        state = result.state;

        result = recordApprovalDecision(state, 'approval_1', 'approve', 'reviewer1', '');
        saveState(result.state, testStorePath);

        // Check readiness
        const isReady = await adapter.isApprovalReady('approval_1');
        expect(isReady).toBe(true);
    });
});

describe('StoreAdapter - Factory Function', () => {
    test('should create JSON store by default', () => {
        process.env.STORE_MODE = undefined;
        const store = createStore();
        expect(store.mode).toBe('json');
    });

    test('should create Postgres store when DB_HOST is set', () => {
        const store = createStore({
            mode: 'postgres',
            dbHost: 'localhost',
            dbName: 'test_db'
        });
        expect(store.mode).toBe('postgres');
    });

    test('should throw error for unknown mode', () => {
        expect(() => {
            new StoreAdapter('unknown_mode', {});
        }).toThrow('Unknown store mode: unknown_mode');
    });

    test('should respect environment variables', () => {
        process.env.DB_HOST = 'db.example.com';
        process.env.DB_NAME = 'formula_factory';

        const store = createStore({ mode: 'postgres' });

        // Verify connection config was built from env
        expect(store.config.host).toBe('db.example.com');
        expect(store.config.database).toBe('formula_factory');

        delete process.env.DB_HOST;
        delete process.env.DB_NAME;
    });
});
