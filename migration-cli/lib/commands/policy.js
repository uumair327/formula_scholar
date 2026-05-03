const { createStore } = require('../workflow/store_adapter');
const { loadState, saveState, upsertApprovalPolicy } = require('../workflow/workflow_store');

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
            const result = await store.upsertApprovalPolicy(
                {
                    id: opts.id,
                    entityType: opts.entityType,
                    regionId: opts.regionId,
                    minimumApprovals: opts.minimumApprovals,
                    requiresSequentialSignoff: opts.requiresSequentialSignoff,
                    enabled: opts.enabled !== false
                },
                opts.actor || 'system'
            );
            console.log(
                `Saved approval policy ${result.policy.id} for ${result.policy.entityType} (minimum=${result.policy.minimumApprovals})`
            );
        } finally {
            await store.close();
        }
    } else {
        // Use JSON store (legacy)
        const state = loadState(opts.store);
        const result = upsertApprovalPolicy(
            state,
            {
                id: opts.id,
                entityType: opts.entityType,
                regionId: opts.regionId,
                minimumApprovals: opts.minimumApprovals,
                requiresSequentialSignoff: opts.requiresSequentialSignoff,
                enabled: opts.enabled !== false
            },
            opts.actor || 'system'
        );

        saveState(result.state, opts.store);
        console.log(
            `Saved approval policy ${result.policy.id} for ${result.policy.entityType} (minimum=${result.policy.minimumApprovals})`
        );
    }
};
