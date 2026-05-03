const { createStore } = require('../workflow/store_adapter');
const { loadState, saveState, recordApprovalDecision } = require('../workflow/workflow_store');

module.exports = async function (opts) {
    // Support both old JSON mode and new Postgres mode
    if (opts.dbHost || opts.dbName || process.env.DB_HOST) {
        // Use Postgres store
        const store = createStore({
            mode: 'postgres',
            dbHost: opts.dbHost,
            dbPort: opts.dbPort,
            dbName: opts.dbName,
            dbUser: opts.dbUser,
            dbPassword: opts.dbPassword
        });

        try {
            await store.connect();
            const result = await store.recordApprovalDecision(
                opts.approvalId,
                opts.action,
                opts.actor || 'system',
                opts.comment || ''
            );
            console.log(
                `Recorded ${result.decision.action} for approval ${result.approval.id}. Current state=${result.approval.state}`
            );
        } finally {
            await store.close();
        }
    } else {
        // Use JSON store (legacy)
        const state = loadState(opts.store);
        const result = recordApprovalDecision(
            state,
            opts.approvalId,
            opts.action,
            opts.actor || 'system',
            opts.comment || ''
        );

        saveState(result.state, opts.store);
        console.log(
            `Recorded ${result.decision.action} for approval ${result.approval.id}. Current state=${result.approval.state}`
        );
    }
};
