const {
    ensureStateShape,
    createAuditEntry,
    createId,
    loadState,
    saveState,
    isApprovalReady
} = require('./workflow_store');

function runPublishWorker(options = {}) {
    const storePath = options.storePath;
    const actor = options.actor || 'system';
    const state = ensureStateShape(loadState(storePath));

    const readyApprovals = state.approvals.filter((approval) => isApprovalReady(state, approval));
    const processedJobs = [];

    for (const approval of readyApprovals) {
        const existingJob = state.publishJobs.find((job) => job.approvalId === approval.id);
        if (existingJob) {
            continue;
        }

        const job = {
            id: createId('job'),
            approvalId: approval.id,
            versionId: approval.targetId,
            status: 'queued',
            attempts: 0,
            createdBy: actor,
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString()
        };

        state.publishJobs.push(job);
        state.auditLog.push(
            createAuditEntry('publish_job_queued', 'publish_job', job.id, actor, {
                approvalId: approval.id,
                versionId: approval.targetId
            })
        );
        processedJobs.push(job);
    }

    saveState(state, storePath);

    return {
        approvalsScanned: readyApprovals.length,
        jobsQueued: processedJobs.length,
        jobs: processedJobs
    };
}

module.exports = {
    runPublishWorker
};
