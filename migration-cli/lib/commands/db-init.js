const { initializeDatabase } = require('../workflow/db_init');

module.exports = async function (opts) {
    const connectionConfig = {
        host: opts.dbHost || process.env.DB_HOST || 'localhost',
        port: opts.dbPort || process.env.DB_PORT || 5432,
        database: opts.dbName || process.env.DB_NAME || 'formula_factory',
        user: opts.dbUser || process.env.DB_USER || 'postgres',
        password: opts.dbPassword || process.env.DB_PASSWORD
    };

    try {
        console.log(`Connecting to ${connectionConfig.user}@${connectionConfig.host}:${connectionConfig.port}/${connectionConfig.database}`);
        await initializeDatabase(connectionConfig);
        console.log('✓ Database initialization complete');
    } catch (err) {
        console.error('✗ Database initialization failed:', err.message);
        process.exit(1);
    }
};
