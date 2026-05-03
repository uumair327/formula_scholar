const { createStore } = require('../workflow/store_adapter');
const { runPublishWorker } = require('../workflow/publish_worker');

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
            const result = await store.runPublishWorker(opts.actor || 'system');
            console.log(
                `Processed ${result.approvalsScanned} approved approvals and queued ${result.jobsQueued} publish jobs.`
            );
            if (result.jobs.length > 0) {
                console.log(JSON.stringify(result.jobs, null, 2));
            }
        } finally {
            await store.close();
        }
    } else {
        // Use JSON store (legacy)
        const result = runPublishWorker({
            storePath: opts.store,
            actor: opts.actor
        });

        console.log(
            `Processed ${result.approvalsScanned} approved approvals and queued ${result.jobsQueued} publish jobs.`
        );
        if (result.jobs.length > 0) {
            console.log(JSON.stringify(result.jobs, null, 2));
        }
    }
};
