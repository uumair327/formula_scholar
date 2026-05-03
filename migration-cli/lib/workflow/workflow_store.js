const fs = require('fs');
const path = require('path');

function getDefaultState() {
    return {
        approvalPolicies: [],
        approvals: [],
        publishJobs: [],
        auditLog: []
    };
}

function resolveStorePath(filePath) {
    if (filePath) {
        return filePath;
    }

    const dataDir = path.join(process.cwd(), 'data');
    return path.join(dataDir, 'workflow-state.json');
}

function loadState(filePath) {
    const storePath = resolveStorePath(filePath);
    if (!fs.existsSync(storePath)) {
        return getDefaultState();
    }

    const raw = fs.readFileSync(storePath, 'utf8');
    if (!raw.trim()) {
        return getDefaultState();
    }

    return JSON.parse(raw);
}

function saveState(state, filePath) {
    const storePath = resolveStorePath(filePath);
    fs.mkdirSync(path.dirname(storePath), { recursive: true });
    fs.writeFileSync(storePath, JSON.stringify(state, null, 2));
}

function ensureStateShape(state) {
    return {
        approvalPolicies: Array.isArray(state.approvalPolicies) ? state.approvalPolicies : [],
        approvals: Array.isArray(state.approvals) ? state.approvals : [],
        publishJobs: Array.isArray(state.publishJobs) ? state.publishJobs : [],
        auditLog: Array.isArray(state.auditLog) ? state.auditLog : []
    };
}

function createId(prefix) {
    return `${prefix}_${Date.now()}_${Math.random().toString(16).slice(2)}`;
}

function createAuditEntry(action, targetType, targetId, actor, details = {}) {
    return {
        id: createId('audit'),
        action,
        entityType: targetType,
        entityId: targetId,
        performedBy: actor,
        delta: details,
        createdAt: new Date().toISOString()
    };
}

function upsertApprovalPolicy(state, policy, actor = 'system') {
    const nextState = ensureStateShape(state);
    const policyRecord = {
        id: policy.id || createId('policy'),
        entityType: policy.entityType || policy.entity_type,
        regionId: policy.regionId || policy.region_id || null,
        minimumApprovals: Number(policy.minimumApprovals || policy.minimum_approvals || 1),
        requiresSequentialSignoff: Boolean(policy.requiresSequentialSignoff),
        enabled: policy.enabled !== false,
        createdAt: policy.createdAt || new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    const existingIndex = nextState.approvalPolicies.findIndex((item) => item.id === policyRecord.id);
    if (existingIndex >= 0) {
        nextState.approvalPolicies[existingIndex] = policyRecord;
    } else {
        nextState.approvalPolicies.push(policyRecord);
    }

    nextState.auditLog.push(
        createAuditEntry('approval_policy_upserted', 'approval_policy', policyRecord.id, actor, policyRecord)
    );

    return { state: nextState, policy: policyRecord };
}

function createApproval(state, approval, actor = 'system') {
    const nextState = ensureStateShape(state);
    const record = {
        id: approval.id || createId('approval'),
        targetType: approval.targetType || approval.entity_type || approval.entityType,
        targetId: approval.targetId || approval.entity_id || approval.entityId,
        requestedBy: approval.requestedBy || approval.requested_by || actor,
        policyId: approval.policyId || approval.policy_id || null,
        state: approval.state || 'pending',
        priority: Number(approval.priority || 0),
        dueAt: approval.dueAt || null,
        createdAt: approval.createdAt || new Date().toISOString(),
        decisions: Array.isArray(approval.decisions) ? approval.decisions : (Array.isArray(approval.decision) ? approval.decision : [])
    };

    nextState.approvals.push(record);
    nextState.auditLog.push(
        createAuditEntry('approval_requested', 'approval', record.id, actor, record)
    );

    return { state: nextState, approval: record };
}

function recordApprovalDecision(state, approvalId, decision, actor = 'system', comment = '') {
    const nextState = ensureStateShape(state);
    const approval = nextState.approvals.find((item) => item.id === approvalId);
    if (!approval) {
        throw new Error(`Approval not found: ${approvalId}`);
    }

    const decisionRecord = {
        id: createId('decision'),
        actor,
        action: decision,
        approvalId: approval.id,
        comment,
        createdAt: new Date().toISOString()
    };

    approval.decisions.push(decisionRecord);
    // Only mark final states on explicit rejection or cancellation.
    if (decision === 'reject') {
        approval.state = 'rejected';
    } else if (decision === 'cancel') {
        approval.state = 'cancelled';
    }

    nextState.auditLog.push(
        createAuditEntry('approval_decision_recorded', 'approval', approval.id, actor, decisionRecord)
    );

    return { state: nextState, approval, decision: decisionRecord };
}

function resolvePolicyForApproval(state, approval) {
    const nextState = ensureStateShape(state);
    const directPolicy = nextState.approvalPolicies.find((item) => item.id === approval.policyId);
    if (directPolicy) {
        return directPolicy;
    }

    const matchedPolicy = nextState.approvalPolicies.find(
        (item) => item.enabled && item.entityType === approval.targetType
    );
    if (matchedPolicy) {
        return matchedPolicy;
    }

    return {
        id: 'default',
        entityType: approval.targetType,
        regionId: null,
        minimumApprovals: 1,
        requiresSequentialSignoff: false,
        enabled: true
    };
}

function countApprovalDecisions(approval) {
    return (approval.decisions || []).filter((decision) => decision.action === 'approve').length;
}

function isApprovalReady(state, approval) {
    if (approval.state === 'approved') {
        return true;
    }

    const policy = resolvePolicyForApproval(state, approval);
    if (!policy || !policy.enabled) {
        return false;
    }

    return countApprovalDecisions(approval) >= policy.minimumApprovals;
}

module.exports = {
    getDefaultState,
    ensureStateShape,
    createId,
    createAuditEntry,
    loadState,
    saveState,
    upsertApprovalPolicy,
    createApproval,
    recordApprovalDecision,
    resolvePolicyForApproval,
    countApprovalDecisions,
    isApprovalReady
};
