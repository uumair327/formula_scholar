const fs = require('fs');
const os = require('os');
const path = require('path');
const { runPublishWorker } = require('../lib/workflow/publish_worker');

function createTempStore(state) {
    const storePath = path.join(os.tmpdir(), `workflow-store-${Date.now()}-${Math.random().toString(16).slice(2)}.json`);
    fs.writeFileSync(storePath, JSON.stringify(state, null, 2));
    return storePath;
}

describe('publish worker', () => {
    test('queues a publish job for approved approvals', () => {
        const storePath = createTempStore({
            approvals: [
                { id: 'approval-1', targetType: 'formula_version', targetId: 'version-1', state: 'approved' },
                { id: 'approval-2', targetType: 'formula_version', targetId: 'version-2', state: 'pending' }
            ],
            publishJobs: [],
            auditLog: []
        });

        const result = runPublishWorker({ storePath, actor: 'tester' });
        const saved = JSON.parse(fs.readFileSync(storePath, 'utf8'));

        expect(result.approvalsScanned).toBe(1);
        expect(result.jobsQueued).toBe(1);
        expect(saved.publishJobs).toHaveLength(1);
        expect(saved.publishJobs[0].approvalId).toBe('approval-1');
        expect(saved.auditLog).toHaveLength(1);

        try {
            fs.unlinkSync(storePath);
        } catch (error) {
            // ignore cleanup errors
        }
    });
});
