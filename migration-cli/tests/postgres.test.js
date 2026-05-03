/**
 * Postgres workflow store tests
 * Tests the PostgresWorkflowStore class with mocked pg queries
 */

jest.mock('pg', () => {
    return {
        Pool: jest.fn().mockImplementation(function () {
            return {
                connect: jest.fn().mockResolvedValue({
                    query: jest.fn(async function (sql, params) {
                        // Simulate table existence checks and return mock data
                        if (sql.includes('CREATE TABLE')) {
                            return { rows: [] };
                        }
                        if (sql.includes('SELECT * FROM approval_policy WHERE id')) {
                            // Return a mock policy
                            return {
                                rows: [{
                                    id: params[0],
                                    entity_type: 'formula_version',
                                    region: null,
                                    minimum_approvals: 1,
                                    sequential_signoff: false,
                                    enabled: true,
                                    created_at: new Date().toISOString(),
                                    updated_at: new Date().toISOString()
                                }]
                            };
                        }
                        if (sql.includes('INSERT INTO approval_policy')) {
                            return {
                                rows: [{
                                    id: params[0],
                                    entity_type: params[1],
                                    region: params[2],
                                    minimum_approvals: params[3],
                                    sequential_signoff: params[4],
                                    enabled: params[5],
                                    created_at: params[6],
                                    updated_at: params[7]
                                }]
                            };
                        }
                        if (sql.includes('INSERT INTO approval_actions')) {
                            return {
                                rows: [{
                                    id: params[0],
                                    approval_id: params[1],
                                    actor: params[2],
                                    action: params[3],
                                    comment: params[4],
                                    created_at: params[5]
                                }]
                            };
                        }
                        if (sql.includes('SELECT a.* FROM approvals')) {
                            return { rows: [] };
                        }
                        if (sql.includes('INSERT INTO publish_job')) {
                            return {
                                rows: [{
                                    id: params[0],
                                    approval_id: params[1],
                                    version_id: params[2],
                                    status: params[3],
                                    attempts: params[4],
                                    created_by: params[5],
                                    created_at: params[6],
                                    updated_at: params[7]
                                }]
                            };
                        }
                        if (sql.includes('UPDATE approvals SET state')) {
                            return {
                                rows: [{
                                    id: params[2],
                                    target_type: 'formula_version',
                                    target_id: 'v123',
                                    requested_by: 'reviewer1',
                                    policy_id: null,
                                    state: params[0],
                                    priority: 0,
                                    due_at: null,
                                    created_at: new Date().toISOString(),
                                    updated_at: params[1]
                                }]
                            };
                        }
                        if (sql.includes('SELECT * FROM approvals WHERE id')) {
                            return {
                                rows: [{
                                    id: params[0],
                                    target_type: 'formula_version',
                                    target_id: 'v123',
                                    requested_by: 'reviewer1',
                                    policy_id: null,
                                    state: 'pending',
                                    priority: 0,
                                    due_at: null,
                                    created_at: new Date().toISOString(),
                                    updated_at: new Date().toISOString()
                                }]
                            };
                        }
                        if (sql.includes('COUNT(*) as count FROM approval_actions')) {
                            return { rows: [{ count: '0' }] };
                        }
                        if (sql.includes('INSERT INTO audit_log')) {
                            return { rows: [{ id: 1 }] };
                        }
                        if (sql.includes('BEGIN') || sql.includes('COMMIT') || sql.includes('ROLLBACK')) {
                            return { rows: [] };
                        }
                        return { rows: [] };
                    }),
                    release: jest.fn()
                }),
                end: jest.fn().mockResolvedValue(undefined)
            };
        })
    };
});

const { PostgresWorkflowStore } = require('../lib/workflow/postgres_store');

describe('PostgresWorkflowStore', () => {
    let store;

    beforeEach(() => {
        store = new PostgresWorkflowStore({
            host: 'localhost',
            port: 5432,
            database: 'test_db',
            user: 'test_user'
        });
    });

    afterEach(async () => {
        if (store) {
            await store.close();
        }
    });

    test('should connect to database', async () => {
        const result = await store.connect();
        expect(result).toBe(true);
    });

    test('should upsert an approval policy', async () => {
        const result = await store.upsertApprovalPolicy(
            {
                id: 'policy_1',
                entityType: 'formula_version',
                regionId: null,
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
        expect(result.policy.enabled).toBe(true);
    });

    test('should map camelCase policy rows correctly', () => {
        const row = {
            id: 'p1',
            entity_type: 'formula_version',
            region: 'US',
            minimum_approvals: 3,
            sequential_signoff: true,
            enabled: true,
            created_at: '2024-01-01',
            updated_at: '2024-01-02'
        };

        const mapped = store._mapPolicyRow(row);

        expect(mapped.id).toBe('p1');
        expect(mapped.entityType).toBe('formula_version');
        expect(mapped.regionId).toBe('US');
        expect(mapped.minimumApprovals).toBe(3);
        expect(mapped.requiresSequentialSignoff).toBe(true);
        expect(mapped.enabled).toBe(true);
    });

    test('should map approval rows correctly', () => {
        const row = {
            id: 'a1',
            target_type: 'formula_version',
            target_id: 'v123',
            requested_by: 'user1',
            policy_id: 'p1',
            state: 'pending',
            priority: 1,
            due_at: '2024-02-01',
            created_at: '2024-01-01',
            updated_at: '2024-01-02'
        };

        const mapped = store._mapApprovalRow(row);

        expect(mapped.id).toBe('a1');
        expect(mapped.targetType).toBe('formula_version');
        expect(mapped.targetId).toBe('v123');
        expect(mapped.requestedBy).toBe('user1');
        expect(mapped.policyId).toBe('p1');
        expect(mapped.state).toBe('pending');
        expect(mapped.priority).toBe(1);
    });

    test('should map decision rows correctly', () => {
        const row = {
            id: 'd1',
            actor: 'reviewer1',
            action: 'approve',
            comment: 'Looks good',
            created_at: '2024-01-01'
        };

        const mapped = store._mapDecisionRow(row);

        expect(mapped.id).toBe('d1');
        expect(mapped.actor).toBe('reviewer1');
        expect(mapped.action).toBe('approve');
        expect(mapped.comment).toBe('Looks good');
    });

    test('should count approval decisions', async () => {
        const count = await store.countApprovalDecisions('approval_1', 'approve');
        expect(typeof count).toBe('number');
    });

    test('should record an approval decision', async () => {
        const result = await store.recordApprovalDecision(
            'approval_1',
            'approve',
            'reviewer1',
            'LGTM'
        );

        expect(result.approval).toBeDefined();
        expect(result.decision).toBeDefined();
        expect(result.decision.action).toBe('approve');
        expect(result.decision.comment).toBe('LGTM');
    });

    test('should resolve policy for approval', async () => {
        const approval = {
            id: 'a1',
            target_type: 'formula_version',
            policy_id: 'p1'
        };

        const policy = await store.resolvePolicyForApproval(approval);
        expect(policy).toBeDefined();
        expect(policy.entityType).toBe('formula_version');
    });

    test('should check if approval is ready', async () => {
        const isReady = await store.isApprovalReady('approval_1');
        expect(typeof isReady).toBe('boolean');
    });

    test('should run publish worker and queue jobs', async () => {
        const result = await store.runPublishWorker('system');

        expect(result).toBeDefined();
        expect(result.approvalsScanned).toBeGreaterThanOrEqual(0);
        expect(result.jobsQueued).toBeGreaterThanOrEqual(0);
        expect(Array.isArray(result.jobs)).toBe(true);
    });

    test('should close database connection', async () => {
        await store.close();
        // Verify end was called on the pool
        expect(store.pool.end).toHaveBeenCalled();
    });
});
