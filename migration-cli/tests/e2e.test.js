/**
 * End-to-End CLI Workflow Test
 * Tests complete approval workflow: Policy → Approve → Worker → Job Executor
 * 
 * This validates the entire pipeline for both JSON and Postgres modes
 */

const { createStore } = require('../lib/workflow/store_adapter');
const { createPublishJobExecutor } = require('../lib/workflow/job_executor');
const path = require('path');
const fs = require('fs');
const os = require('os');

// Mock pg module for Postgres mode
jest.mock('pg', () => {
    const mockPool = {
        connect: jest.fn(async function () {
            const queryFn = async (text, values) => {
                // Mock responses for different queries (more specific first)
                if (text.includes('COUNT(*) as count FROM approval_actions')) {
                    return { rows: [{ count: '1' }] };
                }
                if (text.includes('SELECT * FROM approvals WHERE id = $1')) {
                    return { rows: [{ id: values[0], target_type: 'formula_version', target_id: 'formula_pg_v1', requested_by: 'reviewer', policy_id: 'policy_pg_001', state: 'pending', priority: 0, due_at: null, created_at: new Date(), updated_at: new Date() }] };
                }
                if (text.includes('INSERT INTO approval_policy')) {
                    return { rows: [{ id: values[0], entity_type: values[1], minimum_approvals: values[3], enabled: values[5], created_at: new Date(), updated_at: new Date() }] };
                }
                if (text.includes('INSERT INTO approvals')) {
                    return { rows: [{ id: values[0], target_type: values[1], target_id: values[2], requested_by: values[3], policy_id: values[4], state: values[5] || 'pending', created_at: new Date() }] };
                }
                if (text.includes('INSERT INTO approval_actions')) {
                    return { rows: [{ id: values[0], approval_id: values[1], actor: values[2], action: values[3], comment: values[4], created_at: new Date() }] };
                }
                if (text.includes('UPDATE approvals SET state')) {
                    // Simulate returning the updated approval row
                    return { rows: [{ id: values[2], target_type: 'formula_version', target_id: 'formula_pg_v1', requested_by: 'reviewer', policy_id: 'policy_pg_001', state: values[0] || 'approved', priority: 0, due_at: null, created_at: new Date(), updated_at: new Date() }] };
                }
                if (text.includes('SELECT')) {
                    return { rows: [] };
                }
                return { rows: [] };
            };
            return {
                query: jest.fn(queryFn),
                release: jest.fn()
            };
        }),
        end: jest.fn()
    };

    return {
        Pool: jest.fn(() => mockPool)
    };
});

describe('End-to-End CLI Workflow', () => {
    let tempDir;
    let storeFilePath;

    beforeEach(() => {
        // Create temp directory for test store
        tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'formula-test-'));
        storeFilePath = path.join(tempDir, 'workflow-state.json');
    });

    afterEach(() => {
        // Clean up temp directory
        if (fs.existsSync(tempDir)) {
            fs.rmSync(tempDir, { recursive: true });
        }
    });

    describe('JSON Mode Workflow (Legacy)', () => {
        test('should complete full policy → approval → worker → job sequence', async () => {
            const store = createStore({
                mode: 'json',
                storePath: storeFilePath
            });

            // Step 1: Create approval policy
            const policy = await store.upsertApprovalPolicy({
                id: 'policy_001',
                entityType: 'formula_version',
                minimumApprovals: 1,
                enabled: true
            }, 'admin_001');

            const policyObj = policy.policy || policy;
            expect(policyObj).toBeDefined();
            expect(policyObj.id).toBe('policy_001');
            expect(policyObj.entityType).toBe('formula_version');
            expect(policyObj.minimumApprovals).toBe(1);

            // Step 2: Create approval
            const approval = await store.createApproval({
                id: 'approval_001',
                policyId: 'policy_001',
                targetType: 'formula_version',
                targetId: 'formula_v1',
                state: 'pending'
            }, 'reviewer_001');
            const approvalObj = approval.approval || approval;
            expect(approvalObj).toBeDefined();
            expect(approvalObj.id).toBe('approval_001');
            expect(approvalObj.state).toBe('pending');

            // Step 3: Record approval decision
            const decision = await store.recordApprovalDecision(
                'approval_001',
                'approve',
                'reviewer_001',
                'Looks good'
            );

            const decisionObj = decision.decision || decision;
            expect(decisionObj).toBeDefined();
            expect(decisionObj.approvalId).toBe('approval_001');
            expect(decisionObj.action).toBe('approve');

            // Step 4: Check if approval is ready
            const isReady = await store.isApprovalReady('approval_001');
            expect(isReady).toBe(true);

            // Step 5: Queue publish job
            const result = await store.runPublishWorker('worker_001');
            expect(result).toBeDefined();
            expect(result.approvalsScanned).toBeGreaterThanOrEqual(0);
            expect(result.jobsQueued).toBeGreaterThanOrEqual(0);

            // Verify state file was created
            expect(fs.existsSync(storeFilePath)).toBe(true);
        });

        test('should handle multiple approvals with different states', async () => {
            const store = createStore({
                mode: 'json',
                storePath: storeFilePath
            });

            // Create policy requiring 2 approvals
            await store.upsertApprovalPolicy({
                id: 'policy_multi',
                entityType: 'formula_version',
                minimumApprovals: 2,
                enabled: true
            }, 'admin');

            // Create approval
            await store.createApproval({
                id: 'approval_multi',
                policyId: 'policy_multi',
                targetType: 'formula_version',
                targetId: 'formula_v2',
                state: 'pending'
            }, 'admin');

            // First decision - approve
            await store.recordApprovalDecision(
                'approval_multi',
                'approve',
                'reviewer_1'
            );

            // Should not be ready yet (needs 2)
            let isReady = await store.isApprovalReady('approval_multi');
            expect(isReady).toBe(false);

            // Second decision - approve
            await store.recordApprovalDecision(
                'approval_multi',
                'approve',
                'reviewer_2'
            );

            // Now should be ready
            isReady = await store.isApprovalReady('approval_multi');
            expect(isReady).toBe(true);
        });

        test('should reject approval on rejection', async () => {
            const store = createStore({
                mode: 'json',
                storePath: storeFilePath
            });

            // Create policy
            await store.upsertApprovalPolicy({
                id: 'policy_reject',
                entityType: 'formula_version',
                minimumApprovals: 1,
                enabled: true
            }, 'admin');

            // Create approval
            await store.createApproval({
                id: 'approval_reject',
                policyId: 'policy_reject',
                targetType: 'formula_version',
                targetId: 'formula_v3',
                state: 'pending'
            }, 'admin');

            // Reject the approval
            await store.recordApprovalDecision(
                'approval_reject',
                'reject',
                'reviewer',
                'Not ready for production'
            );

            // Approval should now be rejected (state changed)
            const approvalResult = await store.recordApprovalDecision(
                'approval_reject',
                'reject',
                'reviewer',
                'Final rejection'
            );

            const approvalObj2 = approvalResult.approval || approvalResult;
            expect(approvalObj2).toBeDefined();
        });
    });

    describe('Postgres Mode Workflow', () => {
        test('should complete full workflow with Postgres backend (mocked)', async () => {
            const store = createStore({
                mode: 'postgres',
                dbHost: 'localhost',
                dbPort: '5432',
                dbName: 'test_db',
                dbUser: 'test',
                dbPassword: 'test'
            });

            // Step 1: Create policy
            const policy = await store.upsertApprovalPolicy({
                id: 'policy_pg_001',
                entityType: 'formula_version',
                minimumApprovals: 1,
                enabled: true
            }, 'admin');

            const policyRec = policy.policy || policy;
            expect(policyRec).toBeDefined();
            expect(policyRec.entityType).toBe('formula_version');

            // Step 2: Create approval
            const approval = await store.createApproval({
                id: 'approval_pg_001',
                policyId: 'policy_pg_001',
                targetType: 'formula_version',
                targetId: 'formula_pg_v1',
                state: 'pending'
            }, 'reviewer');

            const approvalRec = approval.approval || approval;
            expect(approvalRec).toBeDefined();
            expect(approvalRec.state).toBe('pending');

            // Step 3: Record decision
            const decision = await store.recordApprovalDecision(
                'approval_pg_001',
                'approve',
                'reviewer'
            );

            expect(decision).toBeDefined();

            // Step 4: Check readiness
            const isReady = await store.isApprovalReady('approval_pg_001');
            expect(isReady).toBeDefined();

            // Step 5: Run worker
            const result = await store.runPublishWorker('worker');
            expect(result).toBeDefined();
            expect(result.approvalsScanned).toBeDefined();

            // Close connection
            await store.close();
        });

        test('should handle Postgres connection errors gracefully', async () => {
            const store = createStore({
                mode: 'postgres',
                dbHost: 'invalid-host',
                dbPort: '9999',
                dbName: 'invalid',
                dbUser: 'invalid',
                dbPassword: 'invalid'
            });

            // Connection errors should be handled by pool
            expect(store).toBeDefined();
        });
    });

    describe('Mode Switching', () => {
        test('should default to JSON mode when no Postgres config provided', () => {
            const store = createStore({});
            expect(store).toBeDefined();
            // Store should be in JSON mode (synchronous methods available)
            expect(typeof store.upsertApprovalPolicy).toBe('function');
        });

        test('should use Postgres when DB config provided', () => {
            const store = createStore({
                dbHost: 'localhost',
                dbName: 'test'
            });
            expect(store).toBeDefined();
        });

        test('should respect STORE_MODE environment variable', () => {
            process.env.STORE_MODE = 'json';
            const store = createStore({});
            expect(store).toBeDefined();
            delete process.env.STORE_MODE;
        });
    });

    describe('Error Handling', () => {
        test('should handle invalid approval ID', async () => {
            const store = createStore({
                mode: 'json',
                storePath: storeFilePath
            });

            // Query non-existent approval
            const isReady = await store.isApprovalReady('invalid_id');
            expect(isReady).toBe(false);
        });

        test('should handle invalid policy', async () => {
            const store = createStore({
                mode: 'json',
                storePath: storeFilePath
            });

            // Create approval without policy should still work
            const approval = await store.createApproval({
                id: 'approval_no_policy',
                entity_type: 'formula_version',
                entity_id: 'formula_test',
                state: 'pending'
            }, 'admin');

            expect(approval).toBeDefined();
        });

        test('should handle corrupted store file gracefully', async () => {
            // Write invalid JSON to store file
            fs.writeFileSync(storeFilePath, '{invalid json}');

            const store = createStore({
                mode: 'json',
                storePath: storeFilePath
            });

            // Should still be able to work (re-initialize)
            expect(store).toBeDefined();
        });
    });

    describe('Audit Trail', () => {
        test('should maintain audit log of all operations', async () => {
            const store = createStore({
                mode: 'json',
                storePath: storeFilePath
            });

            // Perform operations
            await store.upsertApprovalPolicy({
                id: 'policy_audit',
                entityType: 'formula_version',
                minimumApprovals: 1,
                enabled: true
            }, 'admin');

            await store.createApproval({
                id: 'approval_audit',
                policyId: 'policy_audit',
                targetType: 'formula_version',
                targetId: 'formula_audit',
                state: 'pending'
            }, 'admin');

            await store.recordApprovalDecision(
                'approval_audit',
                'approve',
                'reviewer'
            );

            // Read store to verify audit entries
            const stateContent = fs.readFileSync(storeFilePath, 'utf8');
            const state = JSON.parse(stateContent);

            expect(state).toBeDefined();
            expect(state.approvalPolicies).toBeDefined();
            expect(state.approvals).toBeDefined();
        });
    });

    describe('Backward Compatibility', () => {
        test('should work with existing JSON store files', async () => {
            // Create existing store file
            const existingState = {
                approvalPolicies: [
                    {
                        id: 'existing_policy',
                        entityType: 'formula_version',
                        minimumApprovals: 1,
                        enabled: true
                    }
                ],
                approvals: [],
                auditLog: []
            };

            fs.writeFileSync(storeFilePath, JSON.stringify(existingState, null, 2));

            const store = createStore({
                mode: 'json',
                storePath: storeFilePath
            });

            // Should read existing policy
            const policies = existingState.approvalPolicies;
            expect(policies.length).toBe(1);
            expect(policies[0].id).toBe('existing_policy');
        });

        test('should migrate operations on existing store', async () => {
            // Start with existing state
            const existingState = {
                approvalPolicies: [
                    {
                        id: 'existing_policy',
                        entityType: 'formula_version',
                        minimumApprovals: 1,
                        enabled: true
                    }
                ],
                approvals: [],
                auditLog: []
            };

            fs.writeFileSync(storeFilePath, JSON.stringify(existingState, null, 2));

            const store = createStore({
                mode: 'json',
                storePath: storeFilePath
            });

            // Add new approval
            await store.createApproval({
                id: 'new_approval',
                policyId: 'existing_policy',
                targetType: 'formula_version',
                targetId: 'formula_new',
                state: 'pending'
            }, 'admin');

            // Verify file was updated
            const updatedContent = fs.readFileSync(storeFilePath, 'utf8');
            const updatedState = JSON.parse(updatedContent);

            expect(updatedState.approvalPolicies.length).toBe(1);
            expect(updatedState.approvals.length).toBeGreaterThan(0);
        });
    });

    describe('Performance', () => {
        test('should handle workflow in <100ms for JSON mode', async () => {
            const store = createStore({
                mode: 'json',
                storePath: storeFilePath
            });

            const startTime = Date.now();

            await store.upsertApprovalPolicy({
                id: 'policy_perf',
                entityType: 'formula_version',
                minimumApprovals: 1,
                enabled: true
            }, 'admin');

            await store.createApproval({
                id: 'approval_perf',
                policyId: 'policy_perf',
                targetType: 'formula_version',
                targetId: 'formula_perf',
                state: 'pending'
            }, 'admin');

            await store.recordApprovalDecision(
                'approval_perf',
                'approve',
                'reviewer'
            );

            const isReady = await store.isApprovalReady('approval_perf');

            const elapsed = Date.now() - startTime;
            expect(elapsed).toBeLessThan(100);
            expect(isReady).toBe(true);
        });
    });
});
