/**
 * Migration CLI Command
 * Wrapper for JSON to Postgres migration
 */

const path = require('path');
const { createStore } = require('../workflow/store_adapter');
const jsonToPgMigration = require('../workflow/json_to_postgres_migration');

async function migratCommand(sourceFile, options) {
    console.log('\n🔄 Starting JSON to Postgres migration...\n');

    const migrationOptions = {
        source: sourceFile,
        'db-host': options.dbHost,
        'db-port': options.dbPort,
        'db-name': options.dbName,
        'db-user': options.dbUser,
        'db-password': options.dbPassword
    };

    // Re-run with proper arguments
    process.argv = [
        'node',
        'json_to_postgres_migration.js',
        '--source',
        sourceFile,
        '--db-host',
        options.dbHost || 'localhost',
        '--db-port',
        options.dbPort || '5432',
        '--db-name',
        options.dbName || 'formula_factory',
        '--db-user',
        options.dbUser || 'postgres',
        '--db-password',
        options.dbPassword || ''
    ];

    require('../workflow/json_to_postgres_migration.js');
}

module.exports = migratCommand;
