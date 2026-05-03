const { PublishJobExecutor } = require('../workflow/job_executor');

module.exports = async function (opts) {
    const connectionConfig = {
        host: opts.dbHost || process.env.DB_HOST || 'localhost',
        port: opts.dbPort || process.env.DB_PORT || 5432,
        database: opts.dbName || process.env.DB_NAME || 'formula_factory',
        user: opts.dbUser || process.env.DB_USER || 'postgres',
        password: opts.dbPassword || process.env.DB_PASSWORD,
        max: opts.poolSize || 10
    };

    const executor = new PublishJobExecutor(connectionConfig);

    try {
        await executor.connect();
        console.log('✅ Connected to Postgres');

        // Handle graceful shutdown
        process.on('SIGTERM', async () => {
            console.log('\n🛑 Received SIGTERM, shutting down gracefully...');
            await executor.close();
            process.exit(0);
        });

        process.on('SIGINT', async () => {
            console.log('\n🛑 Received SIGINT, shutting down gracefully...');
            await executor.close();
            process.exit(0);
        });

        // Start polling for jobs
        await executor.start();
    } catch (err) {
        console.error('❌ Executor failed:', err.message);
        process.exit(1);
    }
};
